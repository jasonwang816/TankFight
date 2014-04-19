
#import "Packet.h"
#import "PacketActivatePlayer.h"
#import "PacketFrames.h"
#import "PacketOtherClientQuit.h"
//#import "PacketPlayerCalledSnap.h"
//#import "PacketPlayerShouldSnap.h"
#import "PacketServerReady.h"
#import "PacketSignInResponse.h"
#import "NSData+Additions.h"

const size_t PACKET_HEADER_SIZE = 10;

@implementation Packet

@synthesize packetNumber = _packetNumber;
@synthesize packetType = _packetType;
@synthesize sendReliably = _sendReliably;

+ (id)packetWithType:(PacketType)packetType
{
	return [[[self class] alloc] initWithType:packetType];
}

- (id)initWithType:(PacketType)packetType
{
	if ((self = [super init]))
	{
		self.packetNumber = -1;
		self.packetType = packetType;
		self.sendReliably = YES;
	}
	return self;
}


//build packet from received data
+ (id)packetWithData:(NSData *)data
{
	if ([data length] < PACKET_HEADER_SIZE)
	{
		NSLog(@"Error: Packet too small");
		return nil;
	}

	if ([data rw_int32AtOffset:0] != 'SNAP')
	{
		NSLog(@"Error: Packet has invalid header");
		return nil;
	}

	int packetNumber = [data rw_int32AtOffset:4];
	PacketType packetType = [data rw_int16AtOffset:8];

	Packet *packet;

	switch (packetType)
	{
		case PacketTypeSignInRequest:
		case PacketTypeClientReady:
//		case PacketTypeClientDealtCards:
//		case PacketTypeClientTurnedCard:
		case PacketTypeServerQuit:
		case PacketTypeClientQuit:
			packet = [Packet packetWithType:packetType];
			break;

		case PacketTypeSignInResponse:
			packet = [PacketSignInResponse packetWithData:data];
			break;

		case PacketTypeServerReady:
			packet = [PacketServerReady packetWithData:data];
			break;

		case PacketTypeFrames:
			packet = [PacketFrames packetWithData:data];
			break;

		case PacketTypeActivatePlayer:
			packet = [PacketActivatePlayer packetWithData:data];
			break;

//		case PacketTypePlayerShouldSnap:
//			packet = [PacketPlayerShouldSnap packetWithData:data];
//			break;

//		case PacketTypePlayerCalledSnap:
//			packet = [PacketPlayerCalledSnap packetWithData:data];
//			break;

		case PacketTypeOtherClientQuit:
			packet = [PacketOtherClientQuit packetWithData:data];
			break;

		default:
			NSLog(@"Error: Packet has invalid type");
			return nil;
	}

	packet.packetNumber = packetNumber;
	return packet;
}


//return data to send;
- (NSData *)data
{
	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];

	[data rw_appendInt32:'SNAP'];   // 0x534E4150
	[data rw_appendInt32:self.packetNumber];
	[data rw_appendInt16:self.packetType];

	[self addPayloadToData:data];
	return data;
}


//override by children to prepare data
- (void)addPayloadToData:(NSMutableData *)data
{
	// base class does nothing
}


- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ number=%d, type=%d", [super description], self.packetNumber, self.packetType];
}

@end
