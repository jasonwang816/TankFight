//
//  UIItem.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-07.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "UIItem.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "ItemInfo.h"

@implementation UIItem

+(id)spriteWithImageNamed:(NSString*)imageName LinkToLogicItem:(DisplayItem *)logicItem
{
    UIItem * sprite = [[self alloc] initWithImageNamed:imageName];
    sprite.logicItem = logicItem;
    
    if (logicItem){
        sprite.position = logicItem.position;
        sprite.rotation = logicItem.rotation;
    }
    //sprite.scale = 0.5;
    return sprite;
}


//-(CGAffineTransform) nodeToParentTransform
//{
//    ItemInfo * info = self.userObject;
//    
//    if (info.itemType == UserObjectType_Tank) {
//        NSLog(@"nodeToParentTransform");
//    }
//    
//    CGAffineTransform trans = [super nodeToParentTransform];
//    
//    return trans;
//}

- (void)syncToDisplayItem{
    self.logicItem.position = self.position;
    self.logicItem.rotation = self.rotation;
}

- (void)syncFromDisplayItem{
    self.position = self.logicItem.position;
    self.rotation = self.logicItem.rotation;
}

//- (void)syncToDisplayItem:(DisplayItem *) display{
//    display.position = self.position;
//    display.rotation = self.rotation;
//}
//
//- (void)syncFromDisplayItem:(DisplayItem *) display{
//    self.position = display.position;
//    self.rotation = display.rotation;
//}


@end
