
#import "Game.h"
//#import "Card.h"
//#import "Deck.h"
#import "Packet.h"
#import "PacketActivatePlayer.h"
//#import "PacketDealCards.h"
//#import "PacketPlayerCalledSnap.h"
//#import "PacketPlayerShouldSnap.h"
#import "PacketServerReady.h"
#import "PacketSignInResponse.h"
#import "PacketOtherClientQuit.h"
#import "Player.h"
//#import "Stack.h"

// For faking missed ActivatePlayer messages.
//PlayerPosition testPosition;

typedef enum
{
	GameStateWaitingForSignIn,
	GameStateWaitingForReady,
	GameStateDealing,
	GameStatePlaying,
	GameStateGameOver,
	GameStateQuitting,
}
GameState;

@implementation Game
{
	GameState _state;
    
	GKSession *_session;
	NSString *_serverPeerID;
	NSString *_localPlayerName;
	int _sendPacketNumber;
    
	NSMutableDictionary *_players;
	PlayerPosition _startingPlayerPosition;
	PlayerPosition _activePlayerPosition;
    
	BOOL _firstTime;
	BOOL _busyDealing;
	BOOL _hasTurnedCard;
	BOOL _haveSnap;
	BOOL _mustPayCards;
	NSMutableSet *_matchingPlayers;
}

@synthesize delegate = _delegate;
@synthesize isServer = _isServer;

- (id)init
{
	if ((self = [super init]))
	{
		_players = [NSMutableDictionary dictionaryWithCapacity:4];
		_matchingPlayers = [NSMutableSet setWithCapacity:4];
	}
	return self;
}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

#pragma mark - Game Logic

- (void)startServerGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients
{
	self.isServer = YES;
    
	_session = session;
	_session.available = NO;
	_session.delegate = self;
	[_session setDataReceiveHandler:self withContext:nil];
    
	_state = GameStateWaitingForSignIn;
    
	[self.delegate gameWaitingForClientsReady:self];
    
	// Create the Player object for the server.
	Player *player = [[Player alloc] init];
	player.name = name;
	player.peerID = _session.peerID;
	player.position = PlayerPositionBottom;
	[_players setObject:player forKey:player.peerID];
    
	// Add a Player object for each client.
	int index = 0;
	for (NSString *peerID in clients)
	{
		Player *player = [[Player alloc] init];
		player.peerID = peerID;
		[_players setObject:player forKey:player.peerID];
        
		if (index == 0)
			player.position = ([clients count] == 1) ? PlayerPositionTop : PlayerPositionLeft;
		else if (index == 1)
			player.position = PlayerPositionTop;
		else
			player.position = PlayerPositionRight;
        
		index++;
	}
    
	Packet *packet = [Packet packetWithType:PacketTypeSignInRequest];
	[self sendPacketToAllClients:packet];
}

- (void)startClientGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID
{
	self.isServer = NO;
    
	_session = session;
	_session.available = NO;
	_session.delegate = self;
	[_session setDataReceiveHandler:self withContext:nil];
    
	_serverPeerID = peerID;
	_localPlayerName = name;
    
	_state = GameStateWaitingForSignIn;
    
	[self.delegate gameWaitingForServerReady:self];
}

- (void)startSinglePlayerGame
{
	self.isServer = YES;
    
	Player *player = [[Player alloc] init];
	player.name = NSLocalizedString(@"You", @"Single player mode, name of user (bottom player)");
	player.peerID = @"1";
	player.position = PlayerPositionBottom;
	[_players setObject:player forKey:player.peerID];
    
	player = [[Player alloc] init];
	player.name = NSLocalizedString(@"Ray", @"Single player mode, name of left player");
	player.peerID = @"2";
	player.position = PlayerPositionLeft;
	[_players setObject:player forKey:player.peerID];
    
    
	[self beginGame];
}

- (BOOL)isSinglePlayerGame
{
	return (_session == nil);
}

- (void)quitGameWithReason:(QuitReason)reason
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
    
	_state = GameStateQuitting;
    
	if (reason == QuitReasonUserQuit && ![self isSinglePlayerGame])
	{
		if (self.isServer)
		{
			Packet *packet = [Packet packetWithType:PacketTypeServerQuit];
			[self sendPacketToAllClients:packet];
		}
		else
		{
			Packet *packet = [Packet packetWithType:PacketTypeClientQuit];
			[self sendPacketToServer:packet];
		}
	}
    
	[_session disconnectFromAllPeers];
	_session.delegate = nil;
	_session = nil;
    
	[self.delegate game:self didQuitWithReason:reason];
}

- (void)beginGame
{
	_state = GameStateDealing;
	_firstTime = YES;
    
	// This prevents the player from turning over cards while the dealing
	// animation is still taking place.
	_busyDealing = YES;
    
	[self.delegate gameDidBegin:self];
    
	if (self.isServer)
	{
		[self dealCards];
	}
    
}

- (void)nextRound
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
    
	_state = GameStateDealing;
	_firstTime = YES;
	_busyDealing = YES;
    
	[self.delegate gameDidBeginNewRound:self];
    
	[_players enumerateKeysAndObjectsUsingBlock:^(id key, Player *player, BOOL *stop)
     {
//         [player.closedCards removeAllCards];
//         [player.openCards removeAllCards];
     }];
    
	if (self.isServer)
	{
		[self dealCards];
	}
}

- (void)dealCards
{
	NSAssert(self.isServer, @"Must be server");
	NSAssert(_state == GameStateDealing, @"Wrong state");
    
}

- (void)beginRound
{
	_busyDealing = NO;
	_hasTurnedCard = NO;
	_haveSnap = NO;
	_mustPayCards = NO;
	[_matchingPlayers removeAllObjects];
    
	if ([self isSinglePlayerGame])
		_state = GameStatePlaying;
    
	[self activatePlayerAtPosition:_activePlayerPosition];
}

- (void)endRoundWithWinner:(Player *)winner
{
#ifdef DEBUG
	NSLog(@"End of the round, winner is %@", winner);
#endif
    
	_state = GameStateGameOver;
    
	winner.gamesWon++;
	[self.delegate game:self roundDidEndWithWinner:winner];
}

- (void)activatePlayerAtPosition:(PlayerPosition)playerPosition
{
	_hasTurnedCard = NO;
    
//	if ([self isSinglePlayerGame])
//	{
//		if (_activePlayerPosition != PlayerPositionBottom)
////			[self scheduleTurningCardForComputerPlayer];
//	}
//	else if (self.isServer)
//	{
//		NSString *peerID = [self activePlayer].peerID;
//		Packet* packet = [PacketActivatePlayer packetWithPeerID:peerID];
//		[self sendPacketToAllClients:packet];
//	}
    
	[self.delegate game:self didActivatePlayer:[self activePlayer]];
}

- (void)activateNextPlayer
{
	NSAssert(self.isServer, @"Must be server");

}


- (Player *)checkWinner
{
	__block Player *winner;
    
//	[_players enumerateKeysAndObjectsUsingBlock:^(id key, Player *obj, BOOL *stop)
//     {
//         if ([obj totalCardCount] == 52)
//         {
//             winner = obj;
//             *stop = YES;
//         }
//     }];
    
	return winner;
}


{
    static const NSUInteger kItemsPerView = 20;
    NSUInteger startIndex = viewIndex * kItemsPerView;
    NSUInteger count = MIN( completeArray.count - startIndex, kItemsPerView );
    NSArray *itemsForView = [completeArray subarrayWithRange: NSMakeRange( startIndex, count )];
}

#pragma mark - Networking

- (void)sendPacketToAllClients:(Packet *)packet
{
	if ([self isSinglePlayerGame])
		return;
    
	// If packet numbering is enabled, each packet that we send out gets a
	// unique number that keeps increasing. This is used to ignore packets
	// that arrive out-of-order.
	if (packet.packetNumber != -1)
		packet.packetNumber = _sendPacketNumber++;
    
	[_players enumerateKeysAndObjectsUsingBlock:^(id key, Player *obj, BOOL *stop)
     {
         obj.receivedResponse = [_session.peerID isEqualToString:obj.peerID];
     }];
    
	GKSendDataMode dataMode = packet.sendReliably ? GKSendDataReliable : GKSendDataUnreliable;
    
	NSData *data = [packet data];
	NSError *error;
	if (![_session sendDataToAllPeers:data withDataMode:dataMode error:&error])
	{
		NSLog(@"Error sending data to clients: %@", error);
	}
}

- (void)sendPacketToServer:(Packet *)packet
{
	NSAssert(![self isSinglePlayerGame], @"Should not send packets in single player mode");
    
	if (packet.packetNumber != -1)
		packet.packetNumber = _sendPacketNumber++;
    
	GKSendDataMode dataMode = packet.sendReliably ? GKSendDataReliable : GKSendDataUnreliable;
    
	NSData *data = [packet data];
	NSError *error;
	if (![_session sendData:data toPeers:[NSArray arrayWithObject:_serverPeerID] withDataMode:dataMode error:&error])
	{
		NSLog(@"Error sending data to server: %@", error);
	}
}

- (Player *)playerWithPeerID:(NSString *)peerID
{
	return [_players objectForKey:peerID];
}

- (BOOL)receivedResponsesFromAllPlayers
{
	for (NSString *peerID in _players)
	{
		Player *player = [self playerWithPeerID:peerID];
		if (!player.receivedResponse)
			return NO;
	}
	return YES;
}

- (void)clientDidDisconnect:(NSString *)peerID
{
	if (_state != GameStateQuitting)
	{
		Player *player = [self playerWithPeerID:peerID];
		if (player != nil)
		{
			[_players removeObjectForKey:peerID];
            
			if (_state != GameStateWaitingForSignIn)
			{
				// Tell the other clients that this one is now disconnected.
				// Give the cards of the disconnected player to the others.
				if (self.isServer)
				{
//					PacketOtherClientQuit *packet = [PacketOtherClientQuit packetWithPeerID:peerID];
//					[self sendPacketToAllClients:packet];
				}
			}
		}
	}
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
	NSLog(@"Game: peer %@ changed state %d", peerID, state);
#endif
	
	if (state == GKPeerStateDisconnected)
	{
		if (self.isServer)
		{
			[self clientDidDisconnect:peerID];
		}
		else if ([peerID isEqualToString:_serverPeerID])
		{
			[self quitGameWithReason:QuitReasonConnectionDropped];
		}
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"Game: connection request from peer %@", peerID);
#endif
    
	[session denyConnectionFromPeer:peerID];
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: connection with peer %@ failed %@", peerID, error);
#endif
    
	// Not used.
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: session failed %@", error);
#endif
    
	if ([[error domain] isEqualToString:GKSessionErrorDomain])
	{
		if (_state != GameStateQuitting)
		{
			[self quitGameWithReason:QuitReasonConnectionDropped];
		}
	}
}
#pragma mark

#pragma mark - GKSession Data Receive Handler

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context
{
#ifdef DEBUG
	NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
#endif
    
	Packet *packet = [Packet packetWithData:data];
	if (packet == nil)
	{
		NSLog(@"Invalid packet: %@", data);
		return;
	}
    
	Player *player = [self playerWithPeerID:peerID];
	if (player != nil)
	{
		if (packet.packetNumber != -1 && packet.packetNumber <= player.lastPacketNumberReceived)
		{
			NSLog(@"Out-of-order packet!");
			return;
		}
        
		player.lastPacketNumberReceived = packet.packetNumber;
		player.receivedResponse = YES;
	}
    
	if (self.isServer)
		[self serverReceivedPacket:packet fromPlayer:player];
	else
		[self clientReceivedPacket:packet];
}

- (void)serverReceivedPacket:(Packet *)packet fromPlayer:(Player *)player
{
	switch (packet.packetType)
	{
		case PacketTypeSignInResponse:
			if (_state == GameStateWaitingForSignIn)
			{
				player.name = ((PacketSignInResponse *)packet).playerName;
                
				if ([self receivedResponsesFromAllPlayers])
				{
					_state = GameStateWaitingForReady;
                    
					Packet *packet = [PacketServerReady packetWithPlayers:_players];
					[self sendPacketToAllClients:packet];
				}
			}
			break;
            
		case PacketTypeClientReady:
			if (_state == GameStateWaitingForReady && [self receivedResponsesFromAllPlayers])
			{
				[self beginGame];
			}
			break;
            
		case PacketTypeClientQuit:
			[self clientDidDisconnect:player.peerID];
			break;
            
		default:
			NSLog(@"Server received unexpected packet: %@", packet);
			break;
	}
}

- (void)clientReceivedPacket:(Packet *)packet
{
	switch (packet.packetType)
	{
		case PacketTypeSignInRequest:
			if (_state == GameStateWaitingForSignIn)
			{
				_state = GameStateWaitingForReady;
                
				Packet *packet = [PacketSignInResponse packetWithPlayerName:_localPlayerName];
				[self sendPacketToServer:packet];
			}
			break;
            
		case PacketTypeServerReady:
			if (_state == GameStateWaitingForReady)
			{
				_players = ((PacketServerReady *)packet).players;
//				[self changeRelativePositionsOfPlayers];
                
				Packet *packet = [Packet packetWithType:PacketTypeClientReady];
				[self sendPacketToServer:packet];
                
				[self beginGame];
			}
			break;
            
		case PacketTypeActivatePlayer:
			if (_state == GameStatePlaying)
			{
//				[self handleActivatePlayerPacket:(PacketActivatePlayer *)packet];
			}
			break;
            
		case PacketTypeOtherClientQuit:
			if (_state != GameStateQuitting)
			{
				PacketOtherClientQuit *quitPacket = ((PacketOtherClientQuit *)packet);
				[self clientDidDisconnect:quitPacket.peerID];
			}
			break;
            
		case PacketTypeServerQuit:
			[self quitGameWithReason:QuitReasonServerQuit];
			break;
            
		default:
			NSLog(@"Client received unexpected packet: %@", packet);
			break;
	}
}





@end
