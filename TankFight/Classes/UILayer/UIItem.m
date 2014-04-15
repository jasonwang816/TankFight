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
#import "ExItem.h"

@implementation UIItem

+(id)spriteWithImageNamed:(NSString*)imageName LinkToLogicItem:(LogicDisplayItem *)logicItem
{
    UIItem * sprite = [[self alloc] initWithImageNamed:imageName];
    sprite.itemID = logicItem.itemID;
    sprite.logicItem = logicItem;
    
    if (logicItem){
        sprite.position = logicItem.position;
        sprite.rotation = logicItem.rotation;
        ItemInfo * info = [[ItemInfo alloc] initWithTank:logicItem.owner AndType:logicItem.itemType];
        sprite.userObject = info;
    }
    //sprite.scale = 0.5;
    return sprite;
}

-(void)setPosition:(CGPoint)pos
{
    if (pos.x < 0 || pos.x > 3000 || pos.y < 0 || pos.y > 3000) {
        NSLog(@"%@", NSStringFromCGPoint(pos));
    }
	[super setPosition:pos];
}

//-(CGAffineTransform) nodeToParentTransform
//{
//    ItemInfo * info = self.userObject;
//    
//    if (info.itemType == CCUnitType_Tank) {
//        NSLog(@"nodeToParentTransform");
//    }
//    
//    CGAffineTransform trans = [super nodeToParentTransform];
//    
//    return trans;
//}

- (CCUnitType)userObjectType{
    return ((ItemInfo *)self.userObject).itemType;
}

- (void)syncToLogicDisplayItem{
    [self syncToLogicDisplayItem:self.logicItem];
}

- (void)syncToLogicDisplayItem:(LogicDisplayItem *) logic{
    logic.position = self.position;
    logic.rotation = self.rotation;
}

- (void)syncFromLogicDisplayItem{
    [self syncFromLogicDisplayItem:self.logicItem];
}

- (void)syncFromLogicDisplayItem:(LogicDisplayItem *) logic{
    self.position = logic.position;
    self.rotation = logic.rotation;
}


- (void)syncFromFrame:(UIFrame *)frame{
    
    ExItem * eItem = [frame.logicDisplayItems objectForKey:@(self.itemID)];
    if (eItem){
        self.position = eItem.position;
        self.rotation = eItem.rotation;
    }
}

@end
