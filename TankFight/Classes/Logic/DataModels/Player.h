
@interface Player : NSObject

//exchangable data
@property (nonatomic, assign) NSInteger screenPosition;
@property (nonatomic, assign) NSInteger team;  //0 or 1
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *peerID;
@property (nonatomic) CGPoint viewPortOrigin;
@property (nonatomic) NSMutableDictionary * tanks;

@property (nonatomic, assign) BOOL receivedResponse;
@property (nonatomic, assign) int lastPacketNumberReceived;
@property (nonatomic, assign) int gamesWon;

@end
