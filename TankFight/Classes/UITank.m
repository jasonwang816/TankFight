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
        _ccCannon.position  = ccp(_ccBody.contentSize.width/2, _ccBody.contentSize.height/2);
        _ccCannon.rotation = 0; //tank.rotation;
        
        _ccRadar = [CCSprite spriteWithImageNamed:@"radar.gif"];
        _ccRadar.position  = ccp(_ccBody.contentSize.width/2, _ccBody.contentSize.height/2);
        _ccRadar.rotation = 0; //tank.rotation;
        
//        cannon.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, cannon.contentSize} cornerRadius:0]; // 1
//        cannon.physicsBody.collisionGroup = @"playerGroup"; // 2
        
        [_ccBody addChild:_ccCannon];
        [_ccBody addChild:_ccRadar];
        [world addChild:_ccBody];
        
    }
    
    return self;
}

- (void)moveTo:(CGPoint)locationPoint{

    CCSprite * _player = self.ccBody;
    CCActionRotateBy* actionSpin = [DisplayManager rotateAtLocation:_player.position From:_player.rotation ToFacePoint:locationPoint AtSpeed:90]; //TODO speed constant
    CCActionMoveTo * actionMove = [DisplayManager moveFrom:_player.position ToPoint:locationPoint AtSpeed:100 Distance:0];
    [_player stopAllActions];
    [_player runAction:[CCActionSequence actionWithArray:@[actionSpin, actionMove]]];
}

- (void)fireAt:(CGPoint)locationPoint{
    
    CCSprite * bullet = [CCSprite spriteWithImageNamed:@"ball.gif"];
    bullet.position  = ccp(_ccBody.position.x, _ccBody.position.y);
    bullet.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, bullet.contentSize} cornerRadius:0]; // 1
    bullet.physicsBody.collisionGroup = self.tank.name; //TODO: shoot myself?
    bullet.physicsBody.collisionType = @"BulletBody";
    
    CCActionRotateBy* actionSpin = [DisplayManager rotateAtLocation:_ccBody.position From:(_ccBody.rotation + _ccCannon.rotation) ToFacePoint:locationPoint AtSpeed:90];//TODO speed constant
    CCActionCallBlock *actionBlock = [CCActionCallBlock actionWithBlock:^{
        [self.physicsWorld addChild:bullet];
        CCActionMoveTo * actionMove = [DisplayManager moveFrom:_ccBody.position ToPoint:locationPoint AtSpeed:100 Distance:500];  //TODO: set distance
        [bullet runAction:[CCActionSequence actionWithArray:@[actionMove]]];
        NSLog(@"CCActionCallBlock");
    }];

    [_ccCannon stopAllActions];
    [_ccCannon runAction:[CCActionSequence actionWithArray:@[actionSpin, actionBlock]]];
    
}


@end
