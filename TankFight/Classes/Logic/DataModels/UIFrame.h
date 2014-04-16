//
//  UIFrame.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIFrame :NSObject<NSCoding>

@property (nonatomic) NSTimeInterval frameTime;

//@property (nonatomic) NSMutableArray * tanks;
@property (nonatomic) NSMutableDictionary * logicDisplayItems;

- (id)initWithFrameTime:(NSTimeInterval)frameTime AndDisplayItems:(NSMutableArray *)displayItems;

+ (id)initWithFrame:(UIFrame *)first AndFrame:(UIFrame *)second atRatio:(double)ratio;

@end
