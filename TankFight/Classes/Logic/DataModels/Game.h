//
//  Game.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "Player.h"
#import <Foundation/Foundation.h>
#import "GameField.h"
#import "Tank.h"
#import "UIFrame.h"
#import "ExEvent.h"

@class Game;
@class GameUIData;

static const CGPoint homeTankPosition = (CGPoint){100, 200};
static const CGPoint visitorTankPosition = (CGPoint){350, 200};

@protocol GameLogicDelegate <NSObject>
@optional
- (void)addedLogicDisplayItem:(LogicDisplayItem *)logicItem;
- (void)removedLogicDisplayItem:(LogicDisplayItem *)logicItem;
- (void)explodedAt:(CGPoint)position;
@end

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

@property (nonatomic, assign) BOOL isServer;
//@property (nonatomic) GameLogic * logic;
@property (nonatomic, weak) id <GameDelegate> delegate;
@property (nonatomic, weak) id <GameLogicDelegate> logicDelegate;
@property (nonatomic) NSTimeInterval * updateInterval;

@property (nonatomic) GameUIData * gameData;
@property (nonatomic) GameField * gameField;
@property (nonatomic) NSMutableArray * tanks;
@property (nonatomic) NSMutableDictionary * logicDisplayItems;

//Logic
//- (void)addLogicDisplayItem:(LogicDisplayItem *)item;
//- (void)removeLogicDisplayItem:(LogicDisplayItem *)item;
- (void)explodeAt:(CGPoint)position;

- (void)addFrame:(UIFrame *)frame;
- (void)addEvent:(ExEvent *)event;
- (void)handleEvents:(NSTimeInterval)time;

//client-server
- (void)startServerGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients;
- (void)startClientGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID;
- (void)startSinglePlayerGame;
- (void)quitGameWithReason:(QuitReason)reason;

//the time for server
- (NSTimeInterval) getGameTime;
//the time for all client: 3 seconds delay of gametime
- (NSTimeInterval) getClientTime;

//- (Player *)playerAtPosition:(PlayerPosition)position;
//- (Player *)activePlayer;

- (void)beginRound;
- (void)nextRound;

//class methods
+ (NSUInteger)getNextUIItemID;


@end





