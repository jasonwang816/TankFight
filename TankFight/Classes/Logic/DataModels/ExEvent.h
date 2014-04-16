//
//  ExEvent.h
//  TankFight
//
//  Created by Jason Wang on 2014-04-15.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	ExEventType_Fire,    // Tank Fire
	ExEventType_TankHit,          // Tank hit

}ExEventType;

@interface ExEvent : NSObject

@end
