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

//- (void)addFrame:(UIFrame *)frame
//{
//    [_framesData addObject:frame];
////    NSLog(@"addFrame[%lu] : %@", (unsigned long)_framesData.count, frame);
//}


- (UIFrame *)getFrameAtTime:(NSTimeInterval)time
{
    UIFrame * frame;
    if (time > 0 && self.framesData.count > _curDisplayPointer)
    {

        UIFrame * curframe = (UIFrame *)self.framesData[_curDisplayPointer];
        if (time > curframe.frameTime && self.framesData.count > _curDisplayPointer + 1) //has more frames
        {
            UIFrame * nextframe = (UIFrame *)self.framesData[_curDisplayPointer + 1];
            
            while (time > nextframe.frameTime && self.framesData.count > _curDisplayPointer + 1) {
                curframe = nextframe;
                _curDisplayPointer++;
                if (self.framesData.count > _curDisplayPointer + 1) {
                    nextframe = (UIFrame *)self.framesData[_curDisplayPointer + 1];
                }
            }
            
            if (time > nextframe.frameTime || curframe.frameTime == nextframe.frameTime) //reach last frame
            {
                frame = nextframe;
            }else //now time between cur and next;
            {
                double ratio = (time - curframe.frameTime) / (nextframe.frameTime - curframe.frameTime);
                frame = [UIFrame initWithFrame:curframe AndFrame:nextframe atRatio:ratio];
//                NSLog(@"getFrame:[time:%fl][ratio:%fl]:%@", time, ratio, frame);

            }
        }else
        {
            frame = curframe;
        }
        
    }
    
//    if (self.framesData.count == 30){
//        //test
//        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.framesData];
//        
//        NSMutableArray * test = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        
//        //NSLog(@"NSKeyedUnarchiver : %@", test);
//        
//    }

    
    return frame;
}

@end
