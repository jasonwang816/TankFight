//
//  GameLogic.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "GameLogic.h"
#import "Tank.h"

@implementation GameLogic

- (id) init
{
    self = [super init];
    
    if (self){
        //game field
        
        //tanks
        _tankHome = [[Tank alloc] initWithPosition:homeTankPosition AndAngle:0 AndName:@"Home"];
        _tankVisitor = [[Tank alloc] initWithPosition:visitorTankPosition AndAngle:0 AndName:@"visitor"];
    }
    
    return self;
}

@end
