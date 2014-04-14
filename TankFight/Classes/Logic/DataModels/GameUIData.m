//
//  GameUIData.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//
//Used for update UI or replay


#import "GameUIData.h"
#import "UIFrame.h"

@implementation GameUIData

- (id)initWithStartTime:(NSTimeInterval)startTime{
    
    self = [super init];
    
    if (self){
        _startTime = startTime;
        _framesData = [[NSMutableArray alloc] init];
        _curDisplayPointer = 0;
    }
    
    return self;
}

- (void)addFrame:(UIFrame *)frame
{
    [_framesData addObject:frame];
    NSLog(@"logic.gameData addFrame:frame: %f", frame.frameTime);
}


- (UIFrame *)getFrameAtTime:(NSTimeInterval)time
{
    UIFrame * frame;
    if (time > 0)
    {
        if (time > _curDisplayPointer)
        [_framesData addObject:frame];
    }
    NSLog(@"getFrameAtTime: %f", time);
}

@end
