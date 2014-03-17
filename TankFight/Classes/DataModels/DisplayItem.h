//
//  DisplayItem.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayItem : NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic) float rotation;

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle;

@end
