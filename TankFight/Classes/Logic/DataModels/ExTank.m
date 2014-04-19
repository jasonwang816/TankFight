//
//  ExTank.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "ExTank.h"

@implementation ExTank

- (id)initWithName:(NSString *)name
{
    self = [super init];
    
    if (self){
        self.name = name;
        self.health = 100;
        self.attackLevel = 1;
        self.defenceLevel = 1;
        self.speedLevel = 1;
        self.bulletLevel = 1;
        self.radarLevel = 1;
        self.colorID = 0;
    }
    
    return self;
}

@end
