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
        _level = 0;
        _health = 100;
    }
    
	return self;
}

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndName:(NSString *) name{
    
    self = [super init];
    
    if (self){
        self.position = pos;
        self.rotation = angle;
        self.name = name;
    }
    
    return self;
}

//Should based on level
- (CGFloat)getRadarRange{
    return 150;
}

@end
