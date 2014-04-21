//
//  GameAI.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-20.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "GameAI.h"

@implementation GameAI{

}

- (void)getActions:(GameIntel *)intel{
    if (_aiProvider) {
        AIResult * result = [_aiProvider getAIResult:intel];
        [self.delegate resultReady:result];
    }
}


@end
