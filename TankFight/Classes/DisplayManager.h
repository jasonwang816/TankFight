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
#import "UITank.h"
#import "Tank.h"
#import "GameField.h"

@class UITank;

@interface DisplayManager : NSObject<CCPhysicsCollisionDelegate>

@property (nonatomic) CGFloat adjustAngle;

@property (nonatomic) GameLogic * logic;
@property (nonatomic) CCPhysicsNode * physicsWorld;

@property (nonatomic) CCSprite * ccGameField;
@property (nonatomic) UITank * ccTankHome;
@property (nonatomic) UITank * ccTankVisitor;

- (void)updateUI;

- (CCActionMoveTo *)moveFrom:(CGPoint)startPoint ToPoint:(CGPoint)targetPoint AtSpeed:(CGFloat)speed Distance:(CGFloat)distance;
///speed degree/second
- (CCActionRotateBy *)rotateFrom:(CGFloat)startAngle ToAngle:(CGFloat)targetAngle AtSpeed:(CGFloat)speed;

- (CCActionRotateBy *)rotateAtLocation:(CGPoint)location From:(CGFloat)startAngle ToFacePoint:(CGPoint)targetPoint AtSpeed:(CGFloat)speed;

- (CGFloat)getNormalizedDegree:(CGFloat)angle;

//angle: degree - ccSprite rotation
- (CGPoint)getPointFromPoint:(CGPoint)location AtAngle:(CGFloat)angle WithDistance:(CGFloat)distance;
@end
