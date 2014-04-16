//
//  PacketFrames.m
//  TankFight
//
//  Created by Min Wang on 2014-04-15.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//

#import "PacketFrames.h"

@implementation PacketFrames

+ (id)packetWithFrames:(NSArray *)frames
{
	return [[[self class] alloc] initWithFrames:frames];
}

- (id)initWithFrames:(NSArray *)frames
{
	if ((self = [super initWithType:PacketTypeFrames]))
	{
		self.frames = frames;
	}
	return self;
}

+ (id)packetWithData:(NSData *)data
{
    NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[data bytes] + PACKET_HEADER_SIZE
                                         length:data.length
                                   freeWhenDone:NO];
    
	NSArray *frames = [NSKeyedUnarchiver unarchiveObjectWithData:chunk];
	return [[self class] packetWithFrames:frames];
}

- (void)addPayloadToData:(NSMutableData *)data
{
    NSData * frameData = [NSKeyedArchiver archivedDataWithRootObject:self.frames];
	[data appendData:frameData];
}


@end
