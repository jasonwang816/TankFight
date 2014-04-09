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

@interface UIItem : CCSprite

@property (nonatomic, weak) LogicDisplayItem * logicItem;

- (void)syncToLogicDisplayItem;
- (void)syncFromLogicDisplayItem;
//- (void)syncToLogicDisplayItem:(LogicDisplayItem *) display;
//- (void)syncFromLogicDisplayItem:(LogicDisplayItem *) display;

+(id)spriteWithImageNamed:(NSString*)imageName LinkToLogicItem:(LogicDisplayItem *)logicItem;

@end
