//
//  UIFrame.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "UIFrame.h"
#import "ExItem.h"
#import "DisplayItem.h"


@implementation UIFrame

- (id)initWithFrameTime:(NSTimeInterval)frameTime AndDisplayItems:(NSMutableArray *)displayItems{
    
    self = [super init];
    
    if (self){
        self.frameTime = frameTime;
        self.logicDisplayItems = [[NSMutableDictionary alloc] initWithCapacity:displayItems.count];
        
        for(LogicDisplayItem * item in displayItems)
        {
             ExItem * eItem = [[ExItem alloc] initWithLogicDisplayItem:item];
             [self.logicDisplayItems setObject:eItem forKey:@(eItem.itemID)];
        };
        
    }
    
    return self;
}


@end
