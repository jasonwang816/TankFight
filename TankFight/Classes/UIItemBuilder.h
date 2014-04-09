//
//  UIItemBuilder.h
//  TankFight
//
//  Created by Min Wang on 2014-04-08.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIItem.h"

@interface UIItemBuilder : NSObject

+ (UIItem *)buildUIItem:(LogicDisplayItem *)logicItem;

@end
