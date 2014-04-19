//
//  ExGameInfo.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-18.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameField.h"

@interface ExGameInfo : NSObject<NSCoding>

@property (nonatomic) GameField * field;
@property (nonatomic) NSMutableDictionary * players;

@end
