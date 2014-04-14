//
//  GameLogic.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameField.h"
#import "Tank.h"

@class GameUIData;


static const CGPoint homeTankPosition = (CGPoint){100, 200};
static const CGPoint visitorTankPosition = (CGPoint){350, 200};

@protocol GameLogicDelegate <NSObject>
@optional
- (void)addedLogicDisplayItem:(LogicDisplayItem *)logicItem;
- (void)removedLogicDisplayItem:(LogicDisplayItem *)logicItem;
- (void)explodedAt:(CGPoint)position;
@end

@interface GameLogic : NSObject

@property (nonatomic, weak) id <GameLogicDelegate> delegate;

@property (nonatomic) NSTimeInterval * updateInterval;

@property (nonatomic) GameUIData * gameData;

@property (nonatomic) GameField * gameField;
@property (nonatomic) NSMutableArray * tanks;
@property (nonatomic) NSMutableDictionary * logicDisplayItems;

- (void)addLogicDisplayItem:(LogicDisplayItem *)item;
- (void)removeLogicDisplayItem:(LogicDisplayItem *)item;
- (void)explodeAt:(CGPoint)position;

+ (NSUInteger)getNextUIItemID;
@end
