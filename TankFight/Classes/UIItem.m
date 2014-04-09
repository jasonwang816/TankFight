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

+(id)spriteWithImageNamed:(NSString*)imageName LinkToLogicItem:(LogicDisplayItem *)logicItem
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

- (void)syncToLogicDisplayItem{
    self.logicItem.position = self.position;
    self.logicItem.rotation = self.rotation;
}

- (void)syncFromLogicDisplayItem{
    self.position = self.logicItem.position;
    self.rotation = self.logicItem.rotation;
}

//- (void)syncToLogicDisplayItem:(LogicDisplayItem *) logic{
//    logic.position = self.position;
//    logic.rotation = self.rotation;
//}
//
//- (void)syncFromLogicDisplayItem:(LogicDisplayItem *) logic{
//    self.position = logic.position;
//    self.rotation = logic.rotation;
//}


@end
