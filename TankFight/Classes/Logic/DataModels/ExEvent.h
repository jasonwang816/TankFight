//
//  ExEvent.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-15.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayItem.h"

typedef enum
{
	ExEventType_RemoveItem,     // RemoveItem : bullet ...
	ExEventType_AddItem,        // AddItem : bullet ...
	ExEventType_Fire,           // Tank Fire
	ExEventType_TankHit,        // Tank hit

}ExEventType;

@interface ExEvent : NSObject<NSCoding>

@property (nonatomic) NSTimeInterval eventTime;
@property (nonatomic) ExEventType eventType;
//@property (nonatomic) NSUInteger itemID;
@property (nonatomic) LogicDisplayItem * item;

- (id)initWithTime:(NSTimeInterval)time AndType:(ExEventType)type AndItem:(LogicDisplayItem *)item;
//- (id)initWithTime:(NSTimeInterval)time AndType:(ExEventType)type AndID:(NSUInteger *)itemID;

@end
