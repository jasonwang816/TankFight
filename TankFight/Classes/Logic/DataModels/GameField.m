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
    
    self = [self initWithPosition:pos AndAngle:angle AndType:CCUnitType_Field AndOwner:nil];
    
    if (self){
        self.fieldSize = size;
    }
    
    return self;
}
@end
