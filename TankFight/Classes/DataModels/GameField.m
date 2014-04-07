//
//  GameField.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "GameField.h"

@implementation GameField

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndSize:(CGSize) size{
    
    self = [super init];
    
    if (self){
        self.position = pos;
        self.rotation = angle;
        self.fieldSize = size;
    }
    
    return self;
}
@end
