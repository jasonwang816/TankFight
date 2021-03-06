
//
//  Game.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "Game.h"
#import "Packet.h"
#import "PacketActivatePlayer.h"
#import "PacketFrames.h"
#import "PacketServerReady.h"
#import "PacketSignInResponse.h"
#import "PacketOtherClientQuit.h"
#import "Player.h"

#import "GameLogic.h"
#import "Tank.h"
#import "GameUIData.h"

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
    
	BOOL _firstTime;
    NSDate * timeBaseline;
    long syncedFramesCount;
}

static const int FramePacketSize = 10;

static NSUInteger nextUIItemID = 1; //start with 1.

@synthesize delegate = _delegate;
@synthesize isServer = _isServer;

- (id)init
{
	if ((self = [super init]))
	{
        [self resetData];
	}
	return self;
}

- (void)resetData{
    syncedFramesCount = 0;
    [self setupGameData];
}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

+ (NSUInteger)getNextUIItemID{
    NSUInteger num = nextUIItemID++;
    NSLog(@"getNextUIItemID : %lu", (unsigned long)num);
    return num;
}


//the time for server
- (NSTimeInterval) getGameTime{
    return [timeBaseline timeIntervalSinceNow] * -1000;
    //_gameTime = CACurrentMediaTime();
}
//the time for all client: 3 seconds delay of gametime
- (NSTimeInterval) getClientTime{
    return [timeBaseline timeIntervalSinceNow] * -1000 - 3000;
}

- (void)setupGameData{
    //game data
    //TODO: CFAbsoluteTimeGetCurrent
    //NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    
    timeBaseline = [NSDate dateWithTimeIntervalSinceReferenceDate:419492022];  //millisecons since 2014-4-17

    _gameData = [[GameUIData alloc] initWithStartTime:[[NSDate date] timeIntervalSince1970]];
    
    //logicDisplayItems - for server;
    _logicDisplayItems = [[NSMutableDictionary alloc] init];
}

- (void)addLogicDisplayItem:(LogicDisplayItem *)item{
    [_logicDisplayItems setObject:item forKey:@(item.itemID)];
    [self.logicDelegate addedLogicDisplayItem:item];
}

- (void)removeLogicDisplayItem:(LogicDisplayItem *)item{
    [_logicDisplayItems removeObjectForKey:@(item.itemID)];
    [self.logicDelegate removedLogicDisplayItem:item];
}

- (void)explodeAt:(CGPoint)position{
    [self.logicDelegate explodedAt:position];
}

- (void)addFrame:(UIFrame *)frame
{
    [self.gameData.framesData addObject:frame];
    //    NSLog(@"addFrame[%lu] : %@", (unsigned long)_framesData.count, frame);
    
    //TODO: move to a method
    //send frame data when have enough frames: FramePacketSize;
    if (self.gameData.framesData.count - syncedFramesCount >= FramePacketSize) {

        NSUInteger startIndex = syncedFramesCount;
        NSUInteger count = FramePacketSize;
        NSArray *frames = [self.gameData.framesData subarrayWithRange: NSMakeRange( startIndex, count )];

        Packet *packet = [PacketFrames packetWithFrames:frames];
        [self sendPacketToAllClients:packet];
        syncedFramesCount += FramePacketSize;

    }
    
}

- (void)addEvent:(ExEvent *)event{
    NSLog(@"GameTime: %f add event: %@", [self getGameTime], event);
    [self.gameData.eventsData addObject:event];
    //TODO: send event to client
    
}

- (void)handleEvents:(NSTimeInterval)time{
    NSArray * events = [self.gameData getEventAtTime:time];
    if (events){
        for (ExEvent * event in events) {
            switch (event.eventType) {
                case ExEventType_AddItem:
                    [self addLogicDisplayItem:event.item];
                    break;
                    
                case ExEventType_RemoveItem:
                    [self removeLogicDisplayItem:event.item];
                    break;
                    
                case ExEventType_Explode:
                    [self explodeAt:event.item.position];
                    break;
                    
                default:
                    break;
            }
            NSLog(@"handle event: %@", event);

        }
    }
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
    [self resetData];
    
	[self.delegate gameDidBeginNewRound:self];
    
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
    
	if ([self isSinglePlayerGame])
		_state = GameStatePlaying;
    
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
    
	[self.gameInfo.players enumerateKeysAndObjectsUsingBlock:^(id key, Player *obj, BOOL *stop)
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
    NSLog(@"PacketFrames : %lu", (unsigned long)data.length);
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
	return [self.gameInfo.players objectForKey:peerID];
}

- (BOOL)receivedResponsesFromAllPlayers
{
	for (NSString *peerID in self.gameInfo.players)
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
            //TODO:clientDidDisconnect. cannot remove player.!!!!!!!
			//[self.gameInfo.players removeObjectForKey:peerID];
            
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
                    
					Packet *packet = [PacketServerReady packetWithGameInfo:self.gameInfo];
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
                //TODO: all the info can be replaced?????
				self.gameInfo = ((PacketServerReady *)packet).gameInfo;
//				[self changeRelativePositionsOfPlayers];
                
				Packet *packet = [Packet packetWithType:PacketTypeClientReady];
				[self sendPacketToServer:packet];
                
				[self beginGame];
			}
			break;

        case PacketTypeFrames:
            {
                NSArray * frames = ((PacketFrames *)packet).frames;
                [self.gameData.framesData addObjectsFromArray:frames];
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
