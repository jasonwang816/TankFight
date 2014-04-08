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
        _gameField = [[GameField alloc] initWithPosition:CGPointMake(0, 0) AndAngle:0 AndSize:CGSizeMake(480, 320)];
        //tanks
        _tankHome = [[Tank alloc] initWithPosition:homeTankPosition AndAngle:90 AndName:@"Home"];
        _tankVisitor = [[Tank alloc] initWithPosition:visitorTankPosition AndAngle:90 AndName:@"visitor"];
    }
    
    return self;
}

@end
