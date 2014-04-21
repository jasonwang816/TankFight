//
//  gameAIManager.m
//  TankFight
//
//  Created by Min Wang on 2014-04-19.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "GameAIManager.h"
#import "BasicAI.h"
#import "BasicAIProvider.h"

@implementation GameAIManager{
    BasicAI * basicAI;
}

static GameAIManager *_instance = nil;

+ (GameAIManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[GameAIManager alloc] init];
    });
    
    return _instance;
}

- (id)init
{
    if (_instance) return _instance;
    
    self = [super init];
    
    if (self){
        basicAI = [[BasicAI alloc] init];
        basicAI.aiProvider = [[BasicAIProvider alloc] init];
    }
	
    return self;
    
}

- (GameAI *)getGameAI{
    
    GameAI * ai = [[BasicAI alloc] init];
    ai.aiProvider = [[BasicAIProvider alloc] init];
    
    return ai;
}

+ (CGPoint)getRandomPointInSize:(CGSize)size{
    
    CGFloat x = ((float)rand() / RAND_MAX) * size.width;
    CGFloat y = ((float)rand() / RAND_MAX) * size.height;
    CGPoint point = CGPointMake(x, y);
    
    return point;
}


@end
