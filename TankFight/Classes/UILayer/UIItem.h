//
//  UIItem.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-08.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "DisplayItem.h"
#import "UIFrame.h"

@interface UIItem : CCSprite

@property (nonatomic) NSUInteger itemID;
@property (nonatomic, weak) LogicDisplayItem * logicItem;

- (void)syncToLogicDisplayItem;
- (void)syncFromLogicDisplayItem;
- (void)syncToLogicDisplayItem:(LogicDisplayItem *) display;
- (void)syncFromLogicDisplayItem:(LogicDisplayItem *) display;
- (void)syncFromFrame:(UIFrame *)frame;

- (CCUnitType)userObjectType;

+(id)spriteWithImageNamed:(NSString*)imageName LinkToLogicItem:(LogicDisplayItem *)logicItem;

@end
