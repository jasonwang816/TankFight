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

@interface ExTank : NSObject

//exchangable data
@property (nonatomic) NSString * name;
@property (nonatomic) NSInteger health;
@property (nonatomic) CGFloat attackLevel;
@property (nonatomic) CGFloat defenceLevel;
@property (nonatomic) CGFloat speedLevel;
@property (nonatomic) CGFloat bulletLevel;
@property (nonatomic) CGFloat radarLevel;
@property (nonatomic) NSInteger colorID;

- (id)initWithName:(NSString *)name;

@end
