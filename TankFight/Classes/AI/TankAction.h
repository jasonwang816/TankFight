//
//  TankAction.h
//  TankFight
//
//  Created by Min Wang on 2014-04-19.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

typedef enum
{
    TankActionType_None,
	TankActionType_Fire,
	TankActionType_Move,
	TankActionType_Scan,
}
TankActionType;


#import <Foundation/Foundation.h>

@interface TankAction : NSObject

@property (nonatomic) TankActionType actionType;
@property (nonatomic) CGPoint targetPosition;

- (id)initWithType:(TankActionType)type AndTarget:(CGPoint)position;

@end
