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

@interface UITank : NSObject

@property (nonatomic, weak) Tank * tank;
@property (nonatomic, weak) CCPhysicsNode * physicsWorld;
@property (nonatomic) CCSprite * ccBody;
@property (nonatomic) CCSprite * ccCannon;
@property (nonatomic) CCSprite * ccRadar;

- (void)adjustRelatedSprites;

- (id)initWithTank:(Tank *)tank InWorld:(CCPhysicsNode *)world;
- (void)moveTo:(CGPoint)locationPoint;
- (void)fireAt:(CGPoint)locationPoint;
@end
