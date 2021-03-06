//
//  UITank.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-18.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Tank.h"
#import "DisplayManager.h"
#import "UIItem.h"
#import "gameAIManager.h"

@class DisplayManager;

@interface UITank : NSObject<GameAIDelegate>

@property (nonatomic, weak) DisplayManager * manager;
@property (nonatomic, weak) Tank * tank;
@property (nonatomic, weak) CCPhysicsNode * physicsWorld;

@property (nonatomic) UIItem * ccBody;
@property (nonatomic) UIItem * ccCannon;
@property (nonatomic) UIItem * ccLaser;

@property (nonatomic) GameAI * gameAI;

- (void)adjustRelatedSprites;

- (id)initWithTank:(Tank *)tank ByManager:(DisplayManager *)manager;
//- (id)initWithTank:(Tank *)tank InWorld:(CCPhysicsNode *)world;

//Sync data
- (void) syncToLogicTank:(Tank *) logicTank;
- (void) syncFromLogicTank:(Tank *) logicTank;
- (void) syncFromFrame:(UIFrame *) frame;

//Actions
- (void)moveTo:(CGPoint)locationPoint;
- (void)fireAt:(CGPoint)locationPoint;
- (void)scan:(CGFloat)angle;

//AI
- (void)runAI;
@end


