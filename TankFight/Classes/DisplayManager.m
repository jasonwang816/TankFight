//
//  DisplayManager.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//
#import "Constants.h"
#import "DisplayManager.h"
#import "ItemInfo.h"

@implementation DisplayManager

- (id)initWithGameLogic:(GameLogic *)logic AtOrigin:(CGPoint)originPoint WithPhysics:(BOOL)enabled{
    self = [super init];
    if (self){
        _logic = logic;
        _origin = originPoint;
        _isPhysicsEnable = enabled;
        
        _adjustAngle = 0;
        
//        CCTexture *texture = [cctexture]
//        [[CCTextureCache sharedTextureCache] addImage:@"myatlastexture.png"];
//        CCSprite *sprite =
//        [CCSprite spriteWithTexture:texture rect:CGRectMake(0,0,32,32)];
        
        [self setupGameFieldSprites];
        self.rootNode = _ccGameField;
        
        if (_isPhysicsEnable) {
            [self setupGameFieldPhysics];
            [_physicsWorld addChild:_ccGameField];
            self.rootNode = _physicsWorld;
        }

        _ccTankHome = [[UITank alloc] initWithTank:_logic.tankHome ByManager:self];
        _ccTankVisitor = [[UITank alloc] initWithTank:_logic.tankVisitor ByManager:self];  

    }
    return self;
}

- (void)setupGameFieldSprites{
    
    //game field
    GameField * field = _logic.gameField;
    _ccGameField = [CCSprite spriteWithImageNamed:@"field.jpg"];
    _ccGameField.anchorPoint = CGPointZero;
    _ccGameField.textureRect = CGRectMake(0, 0, field.fieldSize.width, field.fieldSize.height);
    _ccGameField.position  = ccpAdd(field.position, self.origin);
    _ccGameField.rotation = field.rotation;
    
}

- (void)setupGameFieldPhysics{
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    
    GameField * field = _logic.gameField;
    UIItem * edge;
    edge = [self buildEdgeAtPoint:CGPointMake(0, 0) WithSize:CGSizeMake(field.fieldSize.width, 0.1)];  //top
    [_ccGameField addChild:edge];
    edge = [self buildEdgeAtPoint:CGPointMake(0, 0) WithSize:CGSizeMake(0.1, field.fieldSize.height)];  //left
    [_ccGameField addChild:edge];
    edge = [self buildEdgeAtPoint:CGPointMake(field.fieldSize.width, 0) WithSize:CGSizeMake(0.1, field.fieldSize.height)];  //right
    [_ccGameField addChild:edge];
    edge = [self buildEdgeAtPoint:CGPointMake(0, field.fieldSize.height) WithSize:CGSizeMake(field.fieldSize.width, 0.1)];  //right
    [_ccGameField addChild:edge];    
}

- (UIItem * )buildEdgeAtPoint:(CGPoint)point WithSize:(CGSize )size{
    
    UIItem * sprite = [CCSprite spriteWithImageNamed:@"field.jpg"];
    sprite.anchorPoint = CGPointZero;
    sprite.textureRect = (CGRect){CGPointZero, size};
    sprite.position = point;
    sprite.userObject = [[ItemInfo alloc] initWithTank:nil AndType:UserObjectType_Field];
    
    NSString * collisionGroup = @"Field";
    sprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, size} cornerRadius:0]; // 1
    sprite.physicsBody.type = CCPhysicsBodyTypeStatic;
    sprite.physicsBody.collisionGroup = collisionGroup;
    sprite.physicsBody.collisionType = CT_FieldBody;
    
    return sprite;
}


// -----------------------------------------------------------------------
#pragma mark - Local methods
// -----------------------------------------------------------------------
//start game
- (void)start{
    
}

- (void)updateUI
{
    if (_isPhysicsEnable){
        if (_ccTankHome){
            [_ccTankHome adjustRelatedSprites];
        }
        if (_ccTankVisitor){
            [_ccTankVisitor adjustRelatedSprites];
        }
        [self updateLogicDataFromUI];
    }else
    {
        [self updateUIDataFromLogic];
    }
    //_logic.tankHome.position = _ccTankHome.bo
    
    //TODO: update game data in game logic!!!!!!!!!
}

- (void) updateLogicDataFromUI{
    
    [_ccTankHome syncToLogicTank:_logic.tankHome];
    [_ccTankVisitor syncToLogicTank:_logic.tankVisitor];
    
}

- (void) updateUIDataFromLogic{
    
    [_ccTankHome syncFromLogicTank:_logic.tankHome];
    [_ccTankVisitor syncFromLogicTank:_logic.tankVisitor];
    
}

// -----------------------------------------------------------------------

// -----------------------------------------------------------------------
#pragma mark - collisionDelegate
// -----------------------------------------------------------------------

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair TankBody:(CCNode *)tankA TankBody:(CCNode *)tankB {
//    [monster removeFromParent];
//    [projectile removeFromParent];
    NSLog(@"TankBody:(CCNode *)tankA TankBody");
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair Default:(CCNode *)itemA Default:(CCNode *)itemB {
    //    [monster removeFromParent];
    //    [projectile removeFromParent];
    
    
    
    
    
    NSLog(@"\n itemA : %@ \n itemB : %@ \n ----------------------------------------------------------- ", (ItemInfo * )itemA.userObject, (ItemInfo * )itemB.userObject);
    return YES;
}


// -----------------------------------------------------------------------
#pragma mark - static functions
// -----------------------------------------------------------------------

- (CCActionMoveTo *)moveFrom:(CGPoint)startPoint ToPoint:(CGPoint)targetPoint AtSpeed:(CGFloat)speed Distance:(CGFloat)distance{
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

- (CGFloat) findAngleAtLocation:(CGPoint)location ToFacePoint:(CGPoint)target {
    CGPoint offset = ccpSub(target, location);
//    CGFloat angle = CC_RADIANS_TO_DEGREES(atan2f(offset.y, offset.x));
    CGFloat angle = CC_RADIANS_TO_DEGREES(ccpToAngle(offset));
    CGFloat resultAngle = _adjustAngle - angle;
//    NSLog(@"findAngleAtLocation: %f; resultAngle: %f", angle, resultAngle);

    return resultAngle;
}

///speed degree/second
- (CCActionRotateBy *)rotateFrom:(CGFloat)startAngle ToAngle:(CGFloat)targetAngle AtSpeed:(CGFloat)speed{
    if (speed <= 0)
        speed = 1;
    
    CGFloat totalAngle = targetAngle - startAngle;
    

    totalAngle = [self getNormalizedDegree:totalAngle];

//    NSLog(@"2.findAngleAtLocation: targetAngle:%f; startAngle: %f; totalAngle: %f", targetAngle, startAngle, totalAngle);
    CGFloat duration = fabsf(totalAngle / speed);
    CCActionRotateBy* action = [CCActionRotateBy actionWithDuration:duration angle:totalAngle];
    
    return action;
}

- (CCActionRotateBy *)rotateAtLocation:(CGPoint)location From:(CGFloat)startAngle ToFacePoint:(CGPoint)targetPoint AtSpeed:(CGFloat)speed{
    
    CGFloat targetAngle = [self findAngleAtLocation:location ToFacePoint:targetPoint];
    
    return [self rotateFrom:startAngle ToAngle:targetAngle AtSpeed:speed];
}

// -180 To 180
- (CGFloat)getNormalizedDegree:(CGFloat)angle{
    CGFloat totalAngle = angle;
    
    if (angle > 180)
        totalAngle -= 360;
    if (angle < -180)
        totalAngle += 360;
    return totalAngle;
    
    //return fmodf((angle + 180) , 360) - 180;
}

//angle: degree - ccSprite rotation
- (CGPoint)getPointFromPoint:(CGPoint)location AtAngle:(CGFloat)angle WithDistance:(CGFloat)distance{
    CGPoint sub = ccpForAngle(CC_DEGREES_TO_RADIANS(_adjustAngle - angle));
    CGPoint result = CGPointMake(location.x + distance * sub.x, location.y + distance * sub.y);
    return result;
}

@end
