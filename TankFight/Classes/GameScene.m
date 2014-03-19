//
//  GameScene.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//
#import "IntroScene.h"
#import "GameScene.h"
#import "Tank.h"
#import "DisplayManager.h"

@implementation GameScene
{
    DisplayManager * uiManager;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (GameScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
    [self addChild:background];

    uiManager = [[DisplayManager alloc] init];
    [self addChild:uiManager.physicsWorld];

//    [self addChild:uiManager.ccTankHome];
//    [self addChild:uiManager.ccTankVisitor];
    
    // Animate sprite with action
//    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
//    [_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    
    // 1
    CGPoint touchLocation = [touch locationInNode:self];
    
    //[uiManager.ccTankHome moveTo:touchLocation];
    [uiManager.ccTankHome fireAt:touchLocation];
    
    
//    CCSprite * _player = uiManager.ccTankHome.ccBody;
//    CCActionRotateBy* actionSpin = [DisplayManager rotateAtLocation:_player.position From:_player.rotation ToFacePoint:touchLocation AtSpeed:90];
//    CCActionMoveTo * actionMove = [DisplayManager moveFrom:_player.position ToPoint:touchLocation AtSpeed:100 Distance:500];
//    [_player stopAllActions];
//    [_player runAction:[CCActionSequence actionWithArray:@[actionSpin, actionMove]]];

}

//+ (CCActionMoveTo *)moveFrom:(CGPoint)startPoint ToPoint:(CGPoint)targetPoint AtSpeed:(CGFloat)speed Distance:(CGFloat)distance{
//    
//    CGFloat totalDistance = distance;
//    
//    CGPoint offset = ccpSub(targetPoint, startPoint);
//    CGFloat offsetDistance = sqrtf(powf(offset.x, 2) + powf(offset.y, 2));;
//    
//    if (totalDistance <= 0)
//    {
//        totalDistance = offsetDistance;
//        if (totalDistance <= 0)
//        {
//            totalDistance = 500;
//        }
//    }
//    
//    float ratio = totalDistance/offsetDistance;
//    int targetX   = startPoint.x + offset.x * ratio;
//    int targetY   = startPoint.y + offset.y * ratio;
//    CGPoint targetPosition = ccp(targetX,targetY);
//
//    
//    CGFloat duration = totalDistance / speed;
//    CCActionMoveTo * action = [CCActionMoveTo actionWithDuration:duration position:targetPosition];
//    
//    return action;
//}


// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

//-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    CGPoint touchLoc = [touch locationInNode:self];
//    
//    // Log touch location
//    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
//    
//    // Move our sprite to touch location
//    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
//    [_sprite runAction:actionMove];
//}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end