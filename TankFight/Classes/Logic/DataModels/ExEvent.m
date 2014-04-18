//
//  ExEvent.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-15.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "ExEvent.h"

@implementation ExEvent

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeDouble:self.eventTime forKey:@"eventTime"];
    [encoder encodeInt:self.eventType forKey:@"eventType"];
    [encoder encodeObject:self.item forKey:@"item"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.eventTime = [decoder decodeDoubleForKey:@"eventTime"];
        self.eventType = [decoder decodeIntForKey:@"eventType"];
        self.item = [decoder decodeObjectForKey:@"item"];
        //self.itemID = [decoder decodeInt64ForKey:@"itemID"];
    }
    return self;
}

- (id)initWithTime:(NSTimeInterval)time AndType:(ExEventType)type AndItem:(LogicDisplayItem *)item;
{
    self = [super init];
    
    if (self){
        _eventTime = time;
        _eventType = type;
        _item = item;
    }
    
    return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"time: %f; type %d, item:[%@]",
            self.eventTime, self.eventType, self.item];
}

@end
