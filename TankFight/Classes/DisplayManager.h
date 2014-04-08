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

@interface DisplayManager : NSObject<CCPhysicsCollisionDelegate>{
    CCPhysicsNode * _physicsWorld;
    CCSprite * _ccGameField;
}

@property (nonatomic) GameLogic * logic;
@property (nonatomic) CGPoint origin;
@property (nonatomic) BOOL isPhysicsEnable;

@property (nonatomic) CGFloat adjustAngle;

@property (nonatomic) CCNode * rootNode;

@property (nonatomic) UITank * ccTankHome;
@property (nonatomic) UITank * ccTankVisitor;

- (id)initWithGameLogic:(GameLogic *)logic AtOrigin:(CGPoint)originPoint WithPhysics:(BOOL)enabled;
- (void)updateUI;

- (CCActionMoveTo *)moveFrom:(CGPoint)startPoint ToPoint:(CGPoint)targetPoint AtSpeed:(CGFloat)speed Distance:(CGFloat)distance;
///speed degree/second
- (CCActionRotateBy *)rotateFrom:(CGFloat)startAngle ToAngle:(CGFloat)targetAngle AtSpeed:(CGFloat)speed;

- (CCActionRotateBy *)rotateAtLocation:(CGPoint)location From:(CGFloat)startAngle ToFacePoint:(CGPoint)targetPoint AtSpeed:(CGFloat)speed;

- (CGFloat)getNormalizedDegree:(CGFloat)angle;

//angle: degree - ccSprite rotation
- (CGPoint)getPointFromPoint:(CGPoint)location AtAngle:(CGFloat)angle WithDistance:(CGFloat)distance;
@end
