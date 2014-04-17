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
#import "UIItemBuilder.h"
#import "UIFrame.h"
#import "GameUIData.h"

int testCounter = 0;

@implementation DisplayManager

- (id)initWithGameLogic:(Game *)logic AtOrigin:(CGPoint)originPoint WithPhysics:(BOOL)enabled{
    self = [super init];
    if (self){
        _logic = logic;
        _origin = originPoint;
        _isPhysicsEnable = enabled;
        
        _adjustAngle = 0;
        _deltaTotal = 0;
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
        }else{
            //setup delegate only when this is not physics manager.
            //since UI manager need to be update when logic item changed.
            _logic.logicDelegate = self;
        }
        
        //uitanks
        UITank * uiTank;
        self.ccTanks = [[NSMutableArray alloc] init];
        for (int i=0; i<_logic.tanks.count; i++) {
            
            uiTank = [[UITank alloc] initWithTank:_logic.tanks[i] ByManager:self];
            [_ccTanks addObject:uiTank];
        }
        
        //uiitems
        _uiItems = [[NSMutableDictionary alloc] init];
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
    
    UIItem * sprite = [UIItem spriteWithImageNamed:@"field.jpg"];
    sprite.anchorPoint = CGPointZero;
    sprite.textureRect = (CGRect){CGPointZero, size};
    sprite.position = point;
    sprite.userObject = [[ItemInfo alloc] initWithTank:nil AndType:CCUnitType_Field];
    
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

- (void)updateUI:(CCTime) time
{
    //_deltaTotal += time;
    _deltaTotal = [[NSDate date] timeIntervalSince1970];sdgs
    //_deltaTotal = CACurrentMediaTime();
    
    if (_isPhysicsEnable){ //server
        for (int i=0; i<self.ccTanks.count; i++) {
            [self.ccTanks[i] adjustRelatedSprites];
        }
        
        if (testCounter % 4 == 0) //TODO: decide what's the number
        {
            testCounter = 0;
            [self updateLogicDataFromUI:_deltaTotal];
        }
        testCounter++;
        
    }else
    {
        [self updateUIDataFromLogic:_deltaTotal - 2];dfgdfh
    }
    
    //TODO: update game data in game logic!!!!!!!!!
}

//Used for update logic data from Physics manager
- (void) updateLogicDataFromUI:(CCTime) time{
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.ccTanks.count; i++) {
        UITank * uiTank = (UITank *)self.ccTanks[i];
        [uiTank syncToLogicTank:_logic.tanks[i]];
        [items addObject:uiTank.ccBody.logicItem];
        [items addObject:uiTank.ccCannon.logicItem];
        [items addObject:uiTank.ccLaser.logicItem];
    }
    
    for (id uiItemID in _uiItems) {
        UIItem * uiItem = [_uiItems objectForKey:uiItemID];
        [uiItem syncToLogicDisplayItem];
        [items addObject:uiItem.logicItem];
    }
    
    UIFrame * frame = [[UIFrame alloc] initWithFrameTime:time AndDisplayItems:items];
    [_logic addFrame:frame];
}


- (void) updateUIDataFromLogic:(CCTime) time{
    
    UIFrame * frame = [_logic.gameData getFrameAtTime:time];
    
    for (int i=0; i<self.ccTanks.count; i++) {
        [self.ccTanks[i] syncFromFrame:frame];
    }
    
    for (id uiItemID in _uiItems) {
        UIItem * uiItem = [_uiItems objectForKey:uiItemID];
        [uiItem syncFromFrame:frame];
    }
    
}
/* old code -----------------------------------
//Used fro update UI display from logic data.
//Note! It is possible displaymanager.uiItems doesn't have the uiitem in Logic.displayitems

- (void) updateUIDataFromLogic:(CCTime) time{
    for (int i=0; i<self.ccTanks.count; i++) {
        [self.ccTanks[i] syncFromLogicTank:_logic.tanks[i]];
    }

    for (id uiItemID in _uiItems) {
        UIItem * uiItem = [_uiItems objectForKey:uiItemID];
        [uiItem syncFromLogicDisplayItem];
    }
//no use: use delegate instead.
//    for (id logicItemID in _logic.logicDisplayItems) {
//        LogicDisplayItem * logicItem = [_logic.logicDisplayItems objectForKey:logicItemID];
//        UIItem * uiItem = [_uiItems objectForKey:@(logicItem.itemID)];
//        if (!uiItem) { //create uiItem if not exist.
//            uiItem = [UIItemBuilder buildUIItem:logicItem];
//            [self.rootNode addChild:uiItem];  //add to scene;
//            [_uiItems setObject:uiItem forKey:@(uiItem.itemID)];
//        }
//        [uiItem syncFromLogicDisplayItem];
//    }
//    //check if uiItem has been removed.
//    for (id uiItemID in _uiItems) {
//        UIItem * uiItem = [_uiItems objectForKey:uiItemID];
//        LogicDisplayItem * logicItem = [_logic.logicDisplayItems objectForKey:uiItemID];
//        if (!logicItem) {
//            [uiItem removeFromParent];
//            [_uiItems removeObjectForKey:@(uiItem.itemID)];
//        }
//    }

}
----------------------------------------------------*/

-(void) addUIItem:(UIItem *)item{
    [self.rootNode addChild:item];
    [_uiItems setObject:item forKey:@(item.itemID)];
    [_logic addLogicDisplayItem:item.logicItem];
}

-(void) removeUIItem:(UIItem *)item{
    [item removeFromParent];
    [_uiItems removeObjectForKey:@(item.itemID)];
    [_logic removeLogicDisplayItem:item.logicItem];
}

// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
#pragma mark - For UI manager
// -----------------------------------------------------------------------
- (void)explodedAt:(CGPoint)position{
    CCSprite * expl = [CCSprite spriteWithImageNamed:@"explosion.png"];
    expl.position  = position;
    expl.scale = 0.5;
    [self.rootNode addChild:expl];
    
    CCActionScaleBy* scaleAction = [CCActionScaleBy actionWithDuration:0.15 scale:1.0];
    [expl runAction:[CCActionSequence actionWithArray:@[scaleAction, [CCActionRemove action]]]];
}

// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
#pragma mark - GameLogicDelegate
// -----------------------------------------------------------------------
- (void)addedLogicDisplayItem:(LogicDisplayItem *)logicItem{
    UIItem * uiItem = [UIItemBuilder buildUIItem:logicItem];
    [self.rootNode addChild:uiItem];  //add to scene;
    [_uiItems setObject:uiItem forKey:@(uiItem.itemID)];
}

- (void)removedLogicDisplayItem:(LogicDisplayItem *)logicItem{
    UIItem * uiItem = [_uiItems objectForKey:@(logicItem.itemID)];
    if (uiItem)
    {
        [uiItem removeFromParent];
        [_uiItems removeObjectForKey:@(uiItem.itemID)];
    }
}

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
    
    NSLog(@"\n itemA : %@ \n itemB : %@ \n ----------------------------------------------------------- ", (ItemInfo *)itemA.userObject, (ItemInfo *)itemB.userObject);
    //return YES;
    //    [monster removeFromParent];
    //    [projectile removeFromParent];
    NSArray * items = [NSArray arrayWithObjects:itemA, itemB, nil];
    
    UIItem * theOne;  //the item with checking CCUnitType
    UIItem * theOther; //the other item
    
    //check field border
    NSInteger index = [self indexOfType:CCUnitType_Field InArray:items];
    if ( index >= 0) {
        theOne = items[index];
        theOther = items[1-index];
        
        if (theOther.userObjectType == CCUnitType_Bullet) //bullet hit border
        {
            [self removeUIItem:theOther];
            return NO;
        }
        
        if (theOther.userObjectType == CCUnitType_RadarLaser) //laser hit border
        {
            return NO;
        }
        
        //for tank body/cannon
        return YES;
    }
    
    //bullet
    index = [self indexOfType:CCUnitType_Bullet InArray:items];
    if ( index >= 0) {
        theOne = items[index]; //bullet
        theOther = items[1-index];
        
        if (theOther.userObjectType == CCUnitType_Tank) //bullet hit tank
        {
            //explode
            [self.logic explodeAt:theOne.position];
            
            //update
            [theOther.logicItem.owner physicsCollisionWith:theOne.logicItem];
            [self removeUIItem:theOne]; //remove bullet
            //
            return YES;
        }
        return NO;
    }
    
    //radar laser
    index = [self indexOfType:CCUnitType_RadarLaser InArray:items];
    if ( index >= 0) {
        theOne = items[index]; //radar laser
        theOther = items[1-index];
        
        if (theOther.userObjectType == CCUnitType_Tank) //bullet hit tank
        {
            //update tank intel: found other tank.
            [theOne.logicItem.owner physicsCollisionWith:theOther.logicItem];
        }
        return NO;
    }
    
    //Tank to Tank
    
    return YES;
}

//returns: -1 : none; otherwise the index of item with checking type
- (NSInteger)indexOfType:(CCUnitType)type InArray:(NSArray *)infoArray{
    
    for (int i=0; i<infoArray.count; i++) {
        UIItem * uiItem = infoArray[i];
        if (uiItem.userObjectType == type) {
            return i;
        }
    }
    return -1;
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
    //TODO: offsetDistance too samll
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
    
    if (targetPosition.x < 0 || targetPosition.x > 3000 || targetPosition.y < 0 || targetPosition.y > 3000)
    {
        NSLog(@"startPoint: %@; targetPoint: %@  \n duration: %f | %@", NSStringFromCGPoint(startPoint), NSStringFromCGPoint(targetPoint), duration, NSStringFromCGPoint(targetPosition));
    }
    
    
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
