//
//  GameUIData.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIFrame;

@interface GameUIData : NSObject

@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSMutableArray * framesData;
@property (nonatomic) long curDisplayPointer;

- (id)initWithStartTime:(NSTimeInterval)startTime;
//- (void)addFrame:(UIFrame *)frame;
- (UIFrame *)getFrameAtTime:(NSTimeInterval)time;
@end
