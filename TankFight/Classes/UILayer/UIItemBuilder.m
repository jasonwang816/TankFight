//
//  UIItemBuilder.m
//  TankFight
//
//  Created by Min Wang on 2014-04-08.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "UIItemBuilder.h"
#import "Constants.h"
#import "DisplayItem.h"
#import "UIItem.h"
#import "Game.h"

@implementation UIItemBuilder

+ (void)addLogicDisplayItem:(LogicDisplayItem *)logicItem ToParentNode:(CCNode *)parent{
    
}

//Create a uiItem with new ID
+ (UIItem *)buildUIItem:(LogicDisplayItem *)logicItem{
    UIItem * uiItem = [self createUIItem:logicItem];
    return uiItem;
}

//need set ItemID manually ?? maybe not!
//Not for game field
+ (UIItem *)createUIItem:(LogicDisplayItem *)logicItem{
    
    UIItem * uiItem;
    
    CCUnitType iType = logicItem.itemType;
    
    switch(iType) {
//        case CCUnitType_Field:
//            result = @"CCUnitType_Field";
//            break;
        case CCUnitType_Bullet:
            uiItem = [UIItem spriteWithImageNamed:@"bullet.png" LinkToLogicItem:logicItem];
            break;
        case CCUnitType_RadarLaser:
        {
            uiItem = [UIItem spriteWithImageNamed:@"darkBlue_350_200.png" LinkToLogicItem:logicItem];
            CGFloat range = logicItem.owner.getRadarRange;
            uiItem.textureRect = CGRectMake(0, 0, range, 0.3);
            uiItem.anchorPoint = CGPointZero;
            
            CCSprite * ccRadar = [CCSprite spriteWithImageNamed:@"radar.png"];
            ccRadar.position  = CGPointZero;
            ccRadar.rotation = 0; //tank.rotation;
            [uiItem addChild:ccRadar];
            break;
        }
        case CCUnitType_Cannon:
            uiItem = [UIItem spriteWithImageNamed:@"cannon.png" LinkToLogicItem:logicItem];
            uiItem.anchorPoint = ccp(0.25, 0.5);
            break;
//        case CCUnitType_Radar:
//            result = @"CCUnitType_Radar";
//            break;
        case CCUnitType_Tank:
            uiItem = [UIItem spriteWithImageNamed:@"Body.png" LinkToLogicItem:logicItem];
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected CCUnitType."];
    }
    
    return uiItem;

}

@end
