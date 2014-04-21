//
//  GameIntel.h
//  TankFight
//
//  Created by Min Wang on 2014-04-19.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//  this is used for recording game imformation

#import <Foundation/Foundation.h>

@interface GameIntel : NSObject

@property (nonatomic) CGSize fieldSize;
@property (nonatomic) NSMutableArray * tanks;

@end
