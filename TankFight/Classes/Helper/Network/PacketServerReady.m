
#import "PacketServerReady.h"
#import "NSData+Additions.h"
#import "Player.h"

@implementation PacketServerReady

+ (id)packetWithGameInfo:(ExGameInfo *)info
{
	return [[[self class] alloc] initWithGameInfo:info];
}

- (id)initWithGameInfo:(ExGameInfo *)info
{
	if ((self = [super initWithType:PacketTypeServerReady]))
	{
		self.gameInfo = info;
	}
	return self;
}

+ (id)packetWithData:(NSData *)data
{
    NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[data bytes] + PACKET_HEADER_SIZE
                                         length:data.length - PACKET_HEADER_SIZE
                                   freeWhenDone:NO];
    
	ExGameInfo *info = [NSKeyedUnarchiver unarchiveObjectWithData:chunk];
	return [[self class] packetWithGameInfo:info];
}

- (void)addPayloadToData:(NSMutableData *)data
{
    NSData * infoData = [NSKeyedArchiver archivedDataWithRootObject:self.gameInfo];
	[data appendData:infoData];
}

//+ (id)packetWithData:(NSData *)data
//{
//	NSMutableDictionary *players = [NSMutableDictionary dictionaryWithCapacity:4];
//
//	size_t offset = PACKET_HEADER_SIZE;
//	size_t count;
//
//	int numberOfPlayers = [data rw_int8AtOffset:offset];
//	offset += 1;
//
//	for (int t = 0; t < numberOfPlayers; ++t)
//	{
//		NSString *peerID = [data rw_stringAtOffset:offset bytesRead:&count];
//		offset += count;
//
//		NSString *name = [data rw_stringAtOffset:offset bytesRead:&count];
//		offset += count;
//
////		PlayerPosition position = [data rw_int8AtOffset:offset];
//		offset += 1;
//
//		Player *player = [[Player alloc] init];
//		player.peerID = peerID;
//		player.name = name;
////		player.position = position;
//		[players setObject:player forKey:player.peerID];
//	}
//
//	return [[self class] packetWithPlayers:players];
//}
//
//- (void)addPayloadToData:(NSMutableData *)data
//{
//	[data rw_appendInt8:[self.players count]];
//
//	[self.players enumerateKeysAndObjectsUsingBlock:^(id key, Player *player, BOOL *stop)
//	{
//		[data rw_appendString:player.peerID];
//		[data rw_appendString:player.name];
//		[data rw_appendInt8:player.screenPosition];
//	}];
//}

@end
