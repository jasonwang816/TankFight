//
//  AIResult.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-20.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "AIResult.h"

@implementation AIResult

- (id)init{
    self = [super init];
    if (self) {
        _actions = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
