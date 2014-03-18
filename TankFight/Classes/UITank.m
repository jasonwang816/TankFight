//
//  UITank.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-18.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "UITank.h"
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



@end
