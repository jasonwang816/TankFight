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

@property (nonatomic, weak) DisplayItem * logicItem;

- (void)syncToDisplayItem;
- (void)syncFromDisplayItem;
//- (void)syncToDisplayItem:(DisplayItem *) display;
//- (void)syncFromDisplayItem:(DisplayItem *) display;

+(id)spriteWithImageNamed:(NSString*)imageName LinkToLogicItem:(DisplayItem *)logicItem;

@end
