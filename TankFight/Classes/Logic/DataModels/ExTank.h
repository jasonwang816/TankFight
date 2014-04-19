//
//  ExTank.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-14.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "ExItem.h"

@interface ExTank : NSObject<NSCoding>

//exchangable data
@property (nonatomic) NSString * name;
@property (nonatomic) NSInteger health;
@property (nonatomic) NSInteger colorID;
@property (nonatomic) NSMutableDictionary * specLevel;

- (id)initWithName:(NSString *)name;

@end
