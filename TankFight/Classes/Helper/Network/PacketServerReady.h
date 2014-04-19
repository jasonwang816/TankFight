
#import "Packet.h"
#import "ExGameInfo.h"

@interface PacketServerReady : Packet

@property (nonatomic, strong) ExGameInfo *gameInfo;

+ (id)packetWithGameInfo:(ExGameInfo *)info;

@end
