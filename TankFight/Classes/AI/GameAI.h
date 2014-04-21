//
//  GameAI.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-20.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gameAIManager.h"

@protocol GameAIProvider <NSObject>

- (AIResult *)getAIResult:(GameIntel *)intel;

@end

@protocol GameAIDelegate <NSObject>

- (void)resultReady:(AIResult *)result;

@end

@interface GameAI : NSObject

@property (nonatomic, weak) id<GameAIDelegate> delegate;
@property (nonatomic) id<GameAIProvider> aiProvider;

- (void)getActions:(GameIntel *)intel;

@end
