//
//  BasicAIProvider.m
//  TankFight
//
//  Created by Jason Wang on 2014-04-20.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "BasicAIProvider.h"
#import "gameAIManager.h"
#import "TankAction.h"

@implementation BasicAIProvider

- (AIResult *)getAIResult:(GameIntel *)intel{
    
    AIResult * result = [[AIResult alloc] init];
    
    TankAction * action = [[TankAction alloc] initWithType:TankActionType_Move AndTarget:[GameAIManager getRandomPointInSize:intel.fieldSize]];
    [result.actions addObject:action];
    
    action = [[TankAction alloc] initWithType:TankActionType_Scan AndTarget:[GameAIManager getRandomPointInSize:intel.fieldSize]];
    [result.actions addObject:action];
    
    action = [[TankAction alloc] initWithType:TankActionType_Fire AndTarget:[GameAIManager getRandomPointInSize:intel.fieldSize]];
    [result.actions addObject:action];
    
    return result;
}

@end
