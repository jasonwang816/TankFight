//
//  Tank.h
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayItem.h"

@interface Tank : DisplayItem

@property (nonatomic) NSString * name;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger health;

- (id)initWithPosition:(CGPoint)pos AndAngle:(float)angle AndName:(NSString *) name;

@end
