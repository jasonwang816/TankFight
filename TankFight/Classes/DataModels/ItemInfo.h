//
//  ItemInfo.h
//  TankFight
//
//  Created by Min Wang on 2014-04-07.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//
//Store information for ccsprite user object

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Tank.h"

@interface ItemInfo : NSObject

@property (nonatomic) Tank * tank;
@property (nonatomic) CCUnitType itemType;

- (id)initWithTank:(Tank *)tank AndType:(CCUnitType *)type;

@end
