//
//  GameUIData.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIFrame;
@class ExEvent;

@interface GameUIData : NSObject

@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSMutableArray * framesData;
@property (nonatomic) NSMutableArray * eventsData;

@property (nonatomic) long curDisplayPointer;
@property (nonatomic) long nextEventPointer;

- (id)initWithStartTime:(NSTimeInterval)startTime;
//- (void)addFrame:(UIFrame *)frame;

- (UIFrame *)getFrameAtTime:(NSTimeInterval)time;
- (NSArray *)getEventAtTime:(NSTimeInterval)time;
@end
