//
//  StaticData.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-18.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tank.h"
typedef enum
{
	TankSpec_Demage,
	TankSpec_Defence,
	TankSpec_MovingSpeed,
	TankSpec_TurningSpeed,
	TankSpec_BulletSpeed,
	TankSpec_RadarSpeed,   //turn
	TankSpec_RadarRange,
}
TankSpec;

@interface StaticData : NSObject

+ (StaticData *)sharedInstance;

- (CGFloat)getTankSpec:(Tank *)tank Spec:(TankSpec)spec;

@end
