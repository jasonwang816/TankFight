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
#import "UIItem.h"

@class UITank;

@interface DisplayManager : NSObject<CCPhysicsCollisionDelegate, GameLogicDelegate>{
    CCPhysicsNode * _physicsWorld;
    UIItem * _ccGameField;
}

@property (nonatomic) GameLogic * logic;
@property (nonatomic) CGPoint origin;

//if true, this dinstance is for real game physics logic;
//oterwise is just for display, no physics bodys for sprites.
@property (nonatomic) BOOL isPhysicsEnable;

@property (nonatomic) CGFloat adjustAngle;

//if isPhysicsEnable is true, root is physics world; otherwise is game field.
@property (nonatomic) CCNode * rootNode;

@property (nonatomic) NSMutableArray * ccTanks;
@property (nonatomic) NSMutableDictionary * uiItems;

- (id)initWithGameLogic:(GameLogic *)logic AtOrigin:(CGPoint)originPoint WithPhysics:(BOOL)enabled;
- (void)updateUI;
- (void)addUIItem:(UIItem *)item;
- (void)removeUIItem:(UIItem *)item;


- (CCActionMoveTo *)moveFrom:(CGPoint)startPoint ToPoint:(CGPoint)targetPoint AtSpeed:(CGFloat)speed Distance:(CGFloat)distance;
///speed degree/second
- (CCActionRotateBy *)rotateFrom:(CGFloat)startAngle ToAngle:(CGFloat)targetAngle AtSpeed:(CGFloat)speed;

- (CCActionRotateBy *)rotateAtLocation:(CGPoint)location From:(CGFloat)startAngle ToFacePoint:(CGPoint)targetPoint AtSpeed:(CGFloat)speed;

- (CGFloat)getNormalizedDegree:(CGFloat)angle;

//angle: degree - ccSprite rotation
- (CGPoint)getPointFromPoint:(CGPoint)location AtAngle:(CGFloat)angle WithDistance:(CGFloat)distance;
@end
