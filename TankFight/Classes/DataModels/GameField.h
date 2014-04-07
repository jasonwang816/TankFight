//
//  GameField.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayItem.h"

@interface GameField : DisplayItem

@property (nonatomic) CGSize fieldSize;

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndSize:(CGSize) size;

@end
