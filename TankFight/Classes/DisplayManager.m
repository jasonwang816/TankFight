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
        
        _ccTankHome = [[UITank alloc] initWithTank:_logic.tankHome InWorld:_physicsWorld];
        _ccTankVisitor = [[UITank alloc] initWithTank:_logic.tankVisitor InWorld:_physicsWorld];

    }
    return self;
}


// -----------------------------------------------------------------------
#pragma mark - Local methods
// -----------------------------------------------------------------------
//no use.
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

//    CCPhysicsJoint * joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:sprite.physicsBody bodyB:cannon.physicsBody anchorA:CGPointMake(30, 30) anchorB:CGPointMake(25, 30)];
    CCPhysicsJoint * joint = [CCPhysicsJoint connectedPivotJointWithBodyA:sprite.physicsBody bodyB:cannon.physicsBody anchorA:CGPointMake(30, 30)];

    //ChipmunkPinJoint *pinJoint = [ChipmunkPinJoint pinJointWithBodyA:sprite.physicsBody bodyB:sprite.physicsBody anchr1:cpv(30, 30) anchr2:cpv(25, 30)];
    
    
//    ChipmunkPinJoint *pinJoint = [ChipmunkPinJoint pinJointWithBodyA:(CCPhysicsBody*)(sprite.physicsBody).body bodyB:(CCPhysicsBody*)(cannon.physicsBody).body anchr1:cpv(30, 30) anchr2:cpv(25, 30)];
//    [pinJoint setDist:40];
//    [[self space] addConstraint:pinJoint];
    
    

    NSLog(@"%@", joint);
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

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair TankBody:(CCNode *)tankA TankBody:(CCNode *)tankB {
//    [monster removeFromParent];
//    [projectile removeFromParent];
    return NO;
}


// -----------------------------------------------------------------------
#pragma mark - static functions
// -----------------------------------------------------------------------

+ (CCActionMoveTo *)moveFrom:(CGPoint)startPoint ToPoint:(CGPoint)targetPoint AtSpeed:(CGFloat)speed Distance:(CGFloat)distance{
    if (speed <= 0)
        speed = 1;
    
    CGFloat totalDistance = distance;
    
    CGPoint offset = ccpSub(targetPoint, startPoint);
    CGFloat offsetDistance = sqrtf(powf(offset.x, 2) + powf(offset.y, 2));
    
    if (totalDistance <= 0)
    {
        totalDistance = offsetDistance;
        if (totalDistance <= 0)
        {
            totalDistance = 500;
        }
    }
    
    float ratio = totalDistance / offsetDistance;
    int targetX   = startPoint.x + offset.x * ratio;
    int targetY   = startPoint.y + offset.y * ratio;
    CGPoint targetPosition = ccp(targetX,targetY);
    
    
    CGFloat duration = fabsf(totalDistance / speed);
    CCActionMoveTo * action = [CCActionMoveTo actionWithDuration:duration position:targetPosition];
    
    return action;
}

+ (CGFloat) findAngleAtLocation:(CGPoint)location ToFacePoint:(CGPoint)target {
    CGPoint offset = ccpSub(target, location);
    CGFloat angle = CC_RADIANS_TO_DEGREES(atan2f(offset.y, offset.x));
    CGFloat resultAngle = 90 - angle;
    NSLog(@"findAngleAtLocation: %f; resultAngle: %f", angle, resultAngle);

    return resultAngle;
}

///speed degree/second
+ (CCActionRotateBy *)rotateFrom:(CGFloat)startAngle ToAngle:(CGFloat)targetAngle AtSpeed:(CGFloat)speed{
    if (speed <= 0)
        speed = 1;
    
    CGFloat totalAngle = targetAngle - startAngle;
    
    if (totalAngle > 180)
        totalAngle -= 360;
    if (totalAngle < -180)
        totalAngle += 360;
    
    NSLog(@"2.findAngleAtLocation: targetAngle:%f; startAngle: %f; totalAngle: %f", targetAngle, startAngle, totalAngle);
    CGFloat duration = fabsf(totalAngle / speed);
    CCActionRotateBy* action = [CCActionRotateBy actionWithDuration:duration angle:totalAngle];
    
    return action;
}

+ (CCActionRotateBy *)rotateAtLocation:(CGPoint)location From:(CGFloat)startAngle ToFacePoint:(CGPoint)targetPoint AtSpeed:(CGFloat)speed{
    
    CGFloat targetAngle = [DisplayManager findAngleAtLocation:location ToFacePoint:targetPoint];
    
    return [DisplayManager rotateFrom:startAngle ToAngle:targetAngle AtSpeed:speed];
}

@end
