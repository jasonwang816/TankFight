//
//  DisplayItem.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "DisplayItem.h"

@implementation DisplayItem

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle{
    
    self = [super init];
    
    if (self){
        _position = pos;
        _rotation = angle;        
    }
    
    return self;
}

@end
