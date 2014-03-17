//
//  DisplayManager.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "GameLogic.h"
#import "Tank.h"
#import "GameField.h"

@interface DisplayManager : NSObject<CCPhysicsCollisionDelegate>

@property (nonatomic) GameLogic * logic;
@property (nonatomic) CCPhysicsNode * physicsWorld;

@property (nonatomic) CCSprite * ccGameField;
@property (nonatomic) CCSprite * ccTankHome;
@property (nonatomic) CCSprite * ccTankVisitor;

@end
