//
//  ExGameInfo.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-18.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "ExGameInfo.h"

@implementation ExGameInfo

- (id)init
{
    self = [super init];
    
    if (self){
        _players = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

@end
