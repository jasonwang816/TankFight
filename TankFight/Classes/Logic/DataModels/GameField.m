//
//  GameField.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "GameField.h"

@implementation GameField

-(void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
    [encoder encodeCGSize:self.fieldSize forKey:@"fieldSize"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        self.fieldSize = [decoder decodeCGSizeForKey:@"fieldSize"];
    }
    return self;
}

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndSize:(CGSize) size{
    
    self = [self initWithPosition:pos AndAngle:angle AndType:CCUnitType_Field AndOwner:nil];
    
    if (self){
        self.fieldSize = size;
    }
    
    return self;
}
@end
