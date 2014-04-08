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
    DisplayManager * physicsManager;
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

    GameLogic * logic = [[GameLogic alloc] init];
    
    physicsManager = [[DisplayManager alloc] initWithGameLogic:logic AtOrigin:CGPointZero WithPhysics:YES];
    [self addChild:physicsManager.rootNode];
    
    uiManager = [[DisplayManager alloc] initWithGameLogic:logic AtOrigin:CGPointMake(500, 0) WithPhysics:NO];
    [self addChild:uiManager.rootNode];
    
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
    
    //scan test
    [physicsManager.ccTankHome scan:160];
    //Fire test
    //[uiManager.ccTankHome fireAt:touchLocation]; return;
    //move test
    [physicsManager.ccTankHome moveTo:touchLocation];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self  selector:@selector(fireAT) userInfo:nil repeats:NO];

    
    
//    CCSprite * _player = uiManager.ccTankHome.ccBody;
//    CCActionRotateBy* actionSpin = [DisplayManager rotateAtLocation:_player.position From:_player.rotation ToFacePoint:touchLocation AtSpeed:90];
//    CCActionMoveTo * actionMove = [DisplayManager moveFrom:_player.position ToPoint:touchLocation AtSpeed:100 Distance:500];
//    [_player stopAllActions];
//    [_player runAction:[CCActionSequence actionWithArray:@[actionSpin, actionMove]]];

}

-(void)fireAT{
    [physicsManager.ccTankHome fireAt:CGPointMake(400, 200)];
}

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

- (void) update:(CCTime) time {
    [physicsManager updateUI];
    //NSLog(@"scene update.");
    [uiManager updateUI];
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