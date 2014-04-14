
#import "Player.h"

@class Game;

@protocol GameDelegate <NSObject>

- (void)gameWaitingForClientsReady:(Game *)game;  // server only
- (void)gameWaitingForServerReady:(Game *)game;   // clients only

- (void)gameDidBegin:(Game *)game;
- (void)gameDidBeginNewRound:(Game *)game;

- (void)game:(Game *)game didActivatePlayer:(Player *)player;
- (void)game:(Game *)game roundDidEndWithWinner:(Player *)player;

- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer redistributedCards:(NSDictionary *)redistributedCards;
- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason;

@end

@interface Game : NSObject <GKSessionDelegate>

@property (nonatomic, weak) id <GameDelegate> delegate;
@property (nonatomic, assign) BOOL isServer;

- (void)startServerGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients;
- (void)startClientGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID;
- (void)startSinglePlayerGame;

- (void)quitGameWithReason:(QuitReason)reason;

- (Player *)playerAtPosition:(PlayerPosition)position;
- (Player *)activePlayer;

- (void)beginRound;
- (void)nextRound;

@end
