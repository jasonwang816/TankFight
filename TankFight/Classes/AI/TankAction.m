//
//  TankAction.m
//  TankFight
//
//  Created by Min Wang on 2014-04-19.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "TankAction.h"

@implementation TankAction

- (id)initWithType:(TankActionType)type AndTarget:(CGPoint)position{
    
    self = [super init];
    if (self) {
        self.actionType = type;
        self.targetPosition = position;
    }
    return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"TankAction: %d; position [%@]",
            self.actionType, NSStringFromCGPoint( self.targetPosition)];
}

@end
