//
//  ItemInfo.m
//  TankFight
//
//  Created by Min Wang on 2014-04-07.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "ItemInfo.h"

@implementation ItemInfo

- (id)initWithTank:(Tank *)tank AndType:(CCUserObjectType *)type{
    
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

- (NSString*)formatTypeToString:(CCUserObjectType)formatType {
    
    NSString *result = @"unknow";
    
    switch(formatType) {
        case UserObjectType_Field:
            result = @"UserObjectType_Field";
            break;
        case UserObjectType_Bullet:
            result = @"UserObjectType_Bullet";
            break;
        case UserObjectType_Radar:
            result = @"UserObjectType_Radar";
            break;
        case UserObjectType_Tank:
            result = @"UserObjectType_Tank";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    return result;
}

@end
