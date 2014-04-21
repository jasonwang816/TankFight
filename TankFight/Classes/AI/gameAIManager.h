//
//  gameAIManager.h
//  TankFight
//
//  Created by Min Wang on 2014-04-19.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIResult.h"
#import "GameIntel.h"
#import "GameAI.h"
#import "TankAction.h"

@class GameAI;

@interface GameAIManager : NSObject

+ (GameAIManager *)sharedInstance;

- (GameAI *)getGameAI;

+ (CGPoint)getRandomPointInSize:(CGSize)size;

@end
