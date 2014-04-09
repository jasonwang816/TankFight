//
//  ItemInfo.m
//  TankFight
//
//  Created by Min Wang on 2014-04-07.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "ItemInfo.h"

@implementation ItemInfo

- (id)initWithTank:(Tank *)tank AndType:(CCUnitType *)type{
    
    self = [super init];
    
    if (self){
        self.tank = tank;
        self.itemType = type;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", _tank.name, [self formatTypeToString:_itemType]];
}

- (NSString*)formatTypeToString:(CCUnitType)formatType {
    
    NSString *result = @"unknow";
    
    switch(formatType) {
        case CCUnitType_Field:
            result = @"CCUnitType_Field";
            break;
        case CCUnitType_Bullet:
            result = @"CCUnitType_Bullet";
            break;
        case CCUnitType_Laser:
            result = @"CCUnitType_Laser";
            break;
        case CCUnitType_Cannon:
            result = @"CCUnitType_Cannon";
            break;
        case CCUnitType_Radar:
            result = @"CCUnitType_Radar";
            break;
        case CCUnitType_Tank:
            result = @"CCUnitType_Tank";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    return result;
}

@end
