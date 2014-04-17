//
//  PacketFrames.h
//  TankFight
//
//  Created by Min Wang on 2014-04-15.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "Packet.h"

@interface PacketFrames : Packet

@property (nonatomic, copy) NSArray * frames;

+ (id)packetWithFrames:(NSArray *)frames;

@end
