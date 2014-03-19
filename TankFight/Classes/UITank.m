//
//  UITank.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-18.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "UITank.h"
#import "DisplayManager.h"
//#import "Tank.h"

@implementation UITank

- (id)init
{
    self = [super init];
    
    if (self){

    }
    
	return self;
}

- (id)initWithTank:(Tank *)tank InWorld:(CCPhysicsNode *)world{
    
    self = [super init];
    
    if (self){
        
        self.physicsWorld = world;
        self.tank = tank;
        
        _ccBody = [CCSprite spriteWithImageNamed:@"Body.png"];
        _ccBody.position  = ccp(tank.position.x, tank.position.y);
        _ccBody.rotation = tank.rotation;
        
        _ccBody.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ccBody.contentSize} cornerRadius:0]; // 1
        _ccBody.physicsBody.collisionGroup = tank.name;
        _ccBody.physicsBody.collisionType = @"TankBody";
        
        _ccCannon = [CCSprite spriteWithImageNamed:@"cannon.gif"];
        _ccCannon.position  = ccp(tank.position.x, tank.position.y);
        _ccCannon.rotation = 0; //tank.rotation;
        
        _ccRadar = [CCSprite spriteWithImageNamed:@"radar.gif"];
        _ccRadar.position  = ccp(tank.position.x, tank.position.y);
        _ccRadar.rotation = 0; //tank.rotation;
        
//        cannon.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, cannon.contentSize} cornerRadius:0]; // 1
//        cannon.physicsBody.collisionGroup = @"playerGroup"; // 2
        
        [world addChild:_ccBody];
        [world addChild:_ccCannon];
        [world addChild:_ccRadar];

        //[_ccBody schedule:@selector(adjustRelatedSprites) ];
    }
    
    return self;
}

- (void)adjustRelatedSprites{
    _ccCannon.position = _ccBody.position;
    _ccRadar.position = _ccBody.position;
}

- (void)moveTo:(CGPoint)locationPoint{

    CCSprite * _player = self.ccBody;
    CCActionRotateBy* actionSpin = [DisplayManager rotateAtLocation:_player.position From:_player.rotation ToFacePoint:locationPoint AtSpeed:180]; //TODO speed constant
    CCActionMoveTo * actionMove = [DisplayManager moveFrom:_player.position ToPoint:locationPoint AtSpeed:30 Distance:0];
    [_player stopAllActions];
    [_player runAction:[CCActionSequence actionWithArray:@[actionSpin, actionMove]]];
}

- (void)fireAt:(CGPoint)locationPoint{
    
    CCActionRotateBy* actionSpin = [DisplayManager rotateAtLocation:_ccBody.position From:(_ccCannon.rotation) ToFacePoint:locationPoint AtSpeed:180];//TODO speed constant
    CCActionCallBlock *actionBlock = [CCActionCallBlock actionWithBlock:^{
        CCSprite * bullet = [CCSprite spriteWithImageNamed:@"ball.gif"];
        bullet.position  = ccp(_ccBody.position.x, _ccBody.position.y);
        bullet.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, bullet.contentSize} cornerRadius:0]; // 1
        bullet.physicsBody.collisionGroup = self.tank.name; //TODO: shoot myself?
        bullet.physicsBody.collisionType = @"BulletBody";        
        
        [self.physicsWorld addChild:bullet];
        CCActionMoveTo * actionMove = [DisplayManager moveFrom:_ccBody.position ToPoint:locationPoint AtSpeed:200 Distance:500];  //TODO: set distance
        [bullet runAction:[CCActionSequence actionWithArray:@[actionMove, [CCActionRemove action]]]];
        NSLog(@"CCActionCallBlock");
    }];

    [_ccCannon stopAllActions];
    [_ccCannon runAction:[CCActionSequence actionWithArray:@[actionSpin, actionBlock]]];
    
}

//Private
///-------------------------------------
- (CGPoint)getCannonPosition{
    CGPoint point = _ccCannon.position;
    CGFloat degree = 90 - _ccCannon.rotation;
    CGFloat radian = CC_DEGREES_TO_RADIANS(degree);
    
    return point;
}

@end
