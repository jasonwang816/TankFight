//
//  Tank.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "Tank.h"

@implementation Tank

- (id)init
{
    self = [super init];
    
    if (self){

    }
    
	return self;
}

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndName:(NSString *) name{
    
    self = [super init];
    
    if (self){
        _level = 0;
        _health = 100;        
        self.name = name;
        
        self.body = [[DisplayItem alloc] initWithPosition:pos AndAngle:angle];
        self.cannon = [[DisplayItem alloc] initWithPosition:pos AndAngle:angle];
        self.radar = [[DisplayItem alloc] initWithPosition:pos AndAngle:angle];

    }
    
    return self;
}

//Should based on level
- (CGFloat)getRadarRange{
    return 150;
}

@end
