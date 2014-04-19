//
//  UITank.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-18.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "Constants.h"
#import "UITank.h"
#import "DisplayManager.h"
#import "CCTexture.h"
#import "ItemInfo.h"
#import "UIItemBuilder.h"

//#import "Tank.h"

@implementation UITank

- (id)init
{
    self = [super init];
    
    if (self){

    }
    
	return self;
}

- (id)initWithTank:(Tank *)tank ByManager:(DisplayManager *)manager{
    
    self = [super init];
    
    if (self){
        self.manager = manager;
//        self.physicsWorld = manager.physicsWorld;
        self.tank = tank;
        
        _ccBody = [UIItemBuilder buildUIItem:tank.body];
        _ccCannon = [UIItemBuilder buildUIItem:tank.cannon];
        _ccLaser = [UIItemBuilder buildUIItem:tank.radarLaser];
        
        if (manager.isPhysicsEnable) {
            [self setupPhysics];
        }
        
        //add to game field
        CCNode * ccGameField = manager.rootNode;
        [ccGameField addChild:_ccBody];
        [ccGameField addChild:_ccCannon];
        [ccGameField addChild:_ccLaser];
        //[_ccBody schedule:@selector(adjustRelatedSprites) ];
    }
    
    return self;
    
}

- (void)setupPhysics{
    
    _ccBody.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ccBody.contentSize} cornerRadius:0]; // 1
    _ccBody.physicsBody.collisionGroup = self.tank.tankInfo.name;
    _ccBody.physicsBody.collisionType = CT_TankBody;

    _ccLaser.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ccLaser.contentSize} cornerRadius:0]; // 1
    _ccLaser.physicsBody.collisionGroup = self.tank.tankInfo.name;
    _ccLaser.physicsBody.collisionType = CT_RadarBody;
    
}

//- (id)initWithTank:(Tank *)tank InWorld:(CCPhysicsNode *)world{
//    
//    self = [super init];
//    
//    if (self){
//        
//        self.physicsWorld = world;
//        self.tank = tank;
//        
//        _ccBody = [CCSprite spriteWithImageNamed:@"Body.png"];
//        _ccBody.position  = ccp(tank.position.x, tank.position.y);
//        _ccBody.rotation = tank.rotation;
//        
//        _ccBody.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ccBody.contentSize} cornerRadius:0]; // 1
//        _ccBody.physicsBody.collisionGroup = tank.name;
//        _ccBody.physicsBody.collisionType = @"TankBody";
//        
//        _ccCannon = [CCSprite spriteWithImageNamed:@"cannon.png"];
//        _ccCannon.position  = ccp(tank.position.x, tank.position.y);
//        _ccCannon.rotation = 0; //tank.rotation;
//        
//        //laser & radar
//        _ccLaser = [self getLaserSprite];
//        _ccLaser.anchorPoint = CGPointZero;
//        _ccLaser.rotation = -90;
//        _ccLaser.position  = ccp(tank.position.x, tank.position.y); // _ccRadar.position;
//        _ccLaser.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ccLaser.contentSize} cornerRadius:0]; // 1
//        _ccLaser.physicsBody.collisionGroup = self.tank.name;
//        _ccLaser.physicsBody.collisionType = @"RadarBody";
//        
//        CCSprite * ccRadar = [CCSprite spriteWithImageNamed:@"radar.png"];
//        ccRadar.position  = CGPointZero;
//        ccRadar.rotation = 90; //tank.rotation;
//        
//        [_ccLaser addChild:ccRadar];
//        
////        cannon.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, cannon.contentSize} cornerRadius:0]; // 1
////        cannon.physicsBody.collisionGroup = @"playerGroup"; // 2
//        
//        [world addChild:_ccBody];
//        [world addChild:_ccCannon];
//        [world addChild:_ccLaser];
//
//        //[_ccBody schedule:@selector(adjustRelatedSprites) ];
//    }
//    
//    return self;
//}

- (void)adjustRelatedSprites{
    _ccCannon.position = _ccBody.position;
    _ccLaser.position = _ccBody.position;
}

- (void)moveTo:(CGPoint)locationPoint{
    UIItem * _player = self.ccBody;

    CGPoint offset = ccpSub(_player.position, locationPoint);
    CGFloat offsetDistance = sqrtf(powf(offset.x, 2) + powf(offset.y, 2));
    
    if (offsetDistance < 0.2) //too small;
        return;
    
    CCActionRotateBy* actionSpin = [self.manager rotateAtLocation:_player.position From:_player.rotation ToFacePoint:locationPoint AtSpeed:180]; //TODO speed constant
    CCActionMoveTo * actionMove = [self.manager moveFrom:_player.position ToPoint:locationPoint AtSpeed:30 Distance:0];
    [_player stopAllActions];
    [_player runAction:[CCActionSequence actionWithArray:@[actionSpin, actionMove]]];
}

- (void)fireAt:(CGPoint)locationPoint{
    
    CCActionRotateBy* actionSpin = [self.manager rotateAtLocation:_ccBody.position From:(_ccCannon.rotation) ToFacePoint:locationPoint AtSpeed:180];//TODO speed constant
    CCActionCallBlock *actionBlock = [CCActionCallBlock actionWithBlock:^{
        LogicDisplayItem * logicBullet = [[LogicDisplayItem alloc] initWithPosition:[self getCannonPosition] AndAngle:_ccCannon.rotation AndType:CCUnitType_Bullet AndOwner:self.tank];
        UIItem * bullet = [UIItemBuilder buildUIItem:logicBullet];
        
        bullet.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, bullet.contentSize} cornerRadius:0]; // 1
        bullet.physicsBody.collisionGroup = self.tank.tankInfo.name; //TODO: shoot itself?
        bullet.physicsBody.collisionType = CT_BulletBody;
        
        [self.manager addUIItem:bullet];
        
        CCActionMoveTo * actionMove = [self.manager moveFrom:bullet.position ToPoint:locationPoint AtSpeed:200 Distance:500];  //TODO: set distance
        [bullet runAction:[CCActionSequence actionWithArray:@[actionMove]]];
    }];

    [_ccCannon stopAllActions];
    [_ccCannon runAction:[CCActionSequence actionWithArray:@[actionSpin, actionBlock]]];
    
}

//angle : degree
- (void)scan:(CGFloat)angle{

    CGFloat targetAngle = _ccLaser.rotation + angle;
    CCActionRotateBy* actionSpin =  [self.manager rotateFrom:_ccLaser.rotation ToAngle:targetAngle AtSpeed:180];

    [_ccLaser stopAllActions];
    [_ccLaser runAction:[CCActionSequence actionWithArray:@[actionSpin]]];
    
//    CCActionRotateBy* actionSpinL =  [DisplayManager rotateFrom:_ccRadar.rotation ToAngle:targetAngle AtSpeed:90];
//    [laser runAction:[CCActionSequence actionWithArray:@[actionSpinL, [CCActionRemove action]]]];
    
}

//Private
///-------------------------------------
//get the position of where the bullet should start.
- (CGPoint)getCannonPosition{
    CGPoint point = _ccCannon.position;
    CGFloat angle = _ccCannon.rotation;
    CGFloat distance = _ccCannon.contentSize.width * 0.75;
    
    CGPoint result = [self.manager getPointFromPoint:point AtAngle:angle WithDistance:distance];
    
//    NSLog(@"getPointFromPoint: angle:%f; point:%@ ; result:%@", angle, NSStringFromCGPoint(point), NSStringFromCGPoint(result));
    return result;
}

- (void) syncToLogicTank:(Tank *) logicTank{
    
    [self.ccBody syncToLogicDisplayItem];
    [self.ccCannon syncToLogicDisplayItem];
    [self.ccLaser syncToLogicDisplayItem];
   
}


- (void) syncFromLogicTank:(Tank *) logicTank{
    
    [self.ccBody syncFromLogicDisplayItem];
    [self.ccCannon syncFromLogicDisplayItem];
    [self.ccLaser syncFromLogicDisplayItem];
    
}

- (void) syncFromFrame:(UIFrame *) frame{
    
    [self.ccBody syncFromFrame:frame];
    [self.ccCannon syncFromFrame:frame];
    [self.ccLaser syncFromFrame:frame];
    
}

// -----------------------------------------------------------------------

#pragma mark - No use code
//No use code:
//----------------------------------------------

//no use
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


//no use
- (UIItem *) createSpriteRectangleWithSize:(CGSize)size
{
    UIItem *sprite = [UIItem node];
    GLubyte *buffer = malloc(sizeof(GLubyte)*4);
    for (int i=0;i<4;i++) {buffer=255;}
    CCTexture *tex = [[CCTexture alloc] initWithData:buffer pixelFormat:CCTexturePixelFormat_RGB5A1 pixelsWide:1 pixelsHigh:1 contentSizeInPixels:size contentScale:1];
    
    [sprite setTexture:tex];
    [sprite setTextureRect:CGRectMake(0, 0, size.width, size.height)];
    free(buffer);
    return sprite;
}
@end
