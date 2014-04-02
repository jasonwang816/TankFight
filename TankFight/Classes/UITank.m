//
//  UITank.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-18.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "UITank.h"
#import "DisplayManager.h"
#import "CCTexture.h"
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

        _ccRadar.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ccRadar.contentSize} cornerRadius:0]; // 1
        _ccRadar.physicsBody.collisionGroup = self.tank.name; //TODO: shoot myself?
        _ccRadar.physicsBody.collisionType = @"RadarBody";
        
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
        bullet.position  = [self getCannonPosition];
        bullet.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, bullet.contentSize} cornerRadius:0]; // 1
        bullet.physicsBody.collisionGroup = self.tank.name; //TODO: shoot myself?
        bullet.physicsBody.collisionType = @"BulletBody";        
        
        [self.physicsWorld addChild:bullet];
        
        CCActionMoveTo * actionMove = [DisplayManager moveFrom:bullet.position ToPoint:locationPoint AtSpeed:200 Distance:500];  //TODO: set distance
        [bullet runAction:[CCActionSequence actionWithArray:@[actionMove, [CCActionRemove action]]]];
    }];

    [_ccCannon stopAllActions];
    [_ccCannon runAction:[CCActionSequence actionWithArray:@[actionSpin, actionBlock]]];
    
}



//angle : degree
- (void)scan:(CGFloat)angle{
    
    //radar
    CGFloat targetAngle = _ccRadar.rotation + angle;
    CCActionRotateBy* actionSpin =  [DisplayManager rotateFrom:_ccRadar.rotation ToAngle:targetAngle AtSpeed:180];
    
    //laser

    CCSprite * laser = [self getLaserSprite];
    
    laser.anchorPoint = CGPointZero;
    laser.position  = CGPointMake(20, 10); // _ccRadar.position;
//    laser.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, laser.contentSize} cornerRadius:0]; // 1
//    laser.physicsBody.collisionGroup = self.tank.name; //TODO: shoot myself?
//    laser.physicsBody.collisionType = @"RadarBody";
    
    //[self.physicsWorld addChild:laser];
    [_ccRadar addChild:laser];

    [_ccRadar stopAllActions];
    [_ccRadar runAction:[CCActionSequence actionWithArray:@[actionSpin]]];
    
//    CCActionRotateBy* actionSpinL =  [DisplayManager rotateFrom:_ccRadar.rotation ToAngle:targetAngle AtSpeed:90];
//    [laser runAction:[CCActionSequence actionWithArray:@[actionSpinL, [CCActionRemove action]]]];
    
}



- (void)scanFrom:(CGPoint)startPoint To:(CGPoint)endPoint{
    
//    CCActionRotateBy* actionSpin = [DisplayManager rotateAtLocation:_ccBody.position From:(_ccCannon.rotation) ToFacePoint:locationPoint AtSpeed:180];//TODO speed constant
//    CCActionCallBlock *actionBlock = [CCActionCallBlock actionWithBlock:^{
//        CCSprite * bullet = [CCSprite spriteWithImageNamed:@"ball.gif"];
//        bullet.position  = [self getCannonPosition];
//        bullet.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, bullet.contentSize} cornerRadius:0]; // 1
//        bullet.physicsBody.collisionGroup = self.tank.name; //TODO: shoot myself?
//        bullet.physicsBody.collisionType = @"BulletBody";
//        
//        [self.physicsWorld addChild:bullet];
//        
//        CCActionMoveTo * actionMove = [DisplayManager moveFrom:bullet.position ToPoint:locationPoint AtSpeed:200 Distance:500];  //TODO: set distance
//        [bullet runAction:[CCActionSequence actionWithArray:@[actionMove, [CCActionRemove action]]]];
//    }];
//    
//    [_ccCannon stopAllActions];
//    [_ccCannon runAction:[CCActionSequence actionWithArray:@[actionSpin, actionBlock]]];
    
}


//Private
///-------------------------------------
- (CGPoint)getCannonPosition{
    CGPoint point = _ccCannon.position;
    CGFloat angle = _ccCannon.rotation;
    CGFloat distance = _ccCannon.contentSize.height/2;
    
    CGPoint result = [DisplayManager getPointFromPoint:point AtAngle:angle WithDistance:distance];
    
    NSLog(@"getPointFromPoint: angle:%f; point:%@ ; result:%@", angle, NSStringFromCGPoint(point), NSStringFromCGPoint(result));
    return result;
}

- (CCSprite*) createSpriteRectangleWithSize:(CGSize)size
{
    CCSprite *sprite = [CCSprite node];
    GLubyte *buffer = malloc(sizeof(GLubyte)*4);
    for (int i=0;i<4;i++) {buffer=255;}
    CCTexture *tex = [[CCTexture alloc] initWithData:buffer pixelFormat:CCTexturePixelFormat_RGB5A1 pixelsWide:1 pixelsHigh:1 contentSizeInPixels:size contentScale:1];
    
    [sprite setTexture:tex];
    [sprite setTextureRect:CGRectMake(0, 0, size.width, size.height)];
    free(buffer);
    return sprite;
}

- (CCSprite *) getLaserSprite
{
    CCSprite * sprite = [CCSprite spriteWithImageNamed:@"darkBlue_350_200.png"];
    sprite.textureRect = CGRectMake(0, 0, 350, 0);
    
//    CCSprite *sprite = [self createSpriteRectangleWithSize:CGSizeMake(250,2)];
//    sprite.color = [CCColor blueColor];
    
    return sprite;
}
@end
