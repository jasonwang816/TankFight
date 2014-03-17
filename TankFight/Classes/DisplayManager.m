//
//  DisplayManager.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "DisplayManager.h"

@implementation DisplayManager

- (id)init{
    self = [super init];
    if (self){
        _logic = [[GameLogic alloc] init];

        _physicsWorld = [CCPhysicsNode node];
        _physicsWorld.gravity = ccp(0,0);
        _physicsWorld.debugDraw = YES;
        _physicsWorld.collisionDelegate = self;
        
//        [self addChild:_physicsWorld];
        
        _ccTankHome = [self buildTank:_logic.tankHome];
        _ccTankVisitor = [self buildTank:_logic.tankVisitor];

    }
    return self;
}


// -----------------------------------------------------------------------
#pragma mark - Local methods
// -----------------------------------------------------------------------

- (CCSprite * )buildTank:(Tank *)tank{
    
    CCSprite * sprite = [CCSprite spriteWithImageNamed:@"Body.png"];
    sprite.position  = ccp(tank.position.x, tank.position.y);
    sprite.rotation = tank.rotation;
    
    sprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, sprite.contentSize} cornerRadius:0]; // 1
    sprite.physicsBody.collisionGroup = @"playerGroup"; // 2
    
    CCSprite * cannon = [CCSprite spriteWithImageNamed:@"cannon.gif"];
    cannon.position  = ccp(tank.position.x, tank.position.y);
    cannon.rotation = tank.rotation;
    
    cannon.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, cannon.contentSize} cornerRadius:0]; // 1
    cannon.physicsBody.collisionGroup = @"playerGroup"; // 2
    
    [_physicsWorld addChild:sprite];
    [_physicsWorld addChild:cannon];
    
    [CCPhysicsJoint connectedPivotJointWithBodyA:sprite.physicsBody bodyB:cannon.physicsBody anchorA:sprite.position];
    
    return sprite;
}

- (void)fire:(CCSprite *)player At:(CGPoint)targetPos{
    
    //    CCSprite * player = home;
    
//    CGPoint offset    = ccpSub(targetPos, player.position);
//    float   ratio     = offset.y/offset.x;
//    int     targetX   = player.contentSize.width/2 + self.contentSize.width;
//    int     targetY   = (targetX*ratio) + player.position.y;
//    CGPoint targetPosition = ccp(targetX,targetY);
//    
//    // 3
//    CCSprite *bullet = [CCSprite spriteWithImageNamed:@"ball.gif"];
//    bullet.position = player.position;
//    [self addChild:bullet ];
//    
//    // 4
//    CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
//    CCActionRemove *actionRemove = [CCActionRemove action];
//    [bullet runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
}

// -----------------------------------------------------------------------

// -----------------------------------------------------------------------
#pragma mark - collisionDelegate
// -----------------------------------------------------------------------

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)monster projectileCollision:(CCNode *)projectile {
//    [monster removeFromParent];
//    [projectile removeFromParent];
    return YES;
}

@end
