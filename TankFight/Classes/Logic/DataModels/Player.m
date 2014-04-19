
#import "Player.h"
//#import "Card.h"
//#import "Stack.h"

@implementation Player

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInteger:self.screenPosition forKey:@"screenPosition"];
    [encoder encodeInteger:self.team forKey:@"team"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.peerID forKey:@"peerID"];
    [encoder encodeCGPoint:self.viewPortOrigin forKey:@"viewPortOrigin"];
    [encoder encodeObject:self.tanks forKey:@"tanks"];
    //TODO:other properties:
//    @property (nonatomic, assign) BOOL receivedResponse;
//    @property (nonatomic, assign) int lastPacketNumberReceived;
//    @property (nonatomic, assign) int gamesWon;
}

//[encoder en
//self. = [decoder de
//:self. f
//F
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.screenPosition = [decoder decodeIntegerForKey:@"screenPosition"];
        self.team = [decoder decodeIntegerForKey:@"team"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.peerID = [decoder decodeObjectForKey:@"peerID"];
        self.viewPortOrigin = [decoder decodeCGPointForKey:@"viewPortOrigin"];
        self.tanks = [decoder decodeObjectForKey:@"tanks"];
        
    }
    return self;
}

- (id)init
{
	if ((self = [super init]))
	{
		_lastPacketNumberReceived = -1;
        _tanks = [[NSMutableDictionary alloc] init];

	}
	return self;
}

- (void)dealloc
{
	#ifdef DEBUG
	NSLog(@"dealloc %@", self);
	#endif
}

//- (Card *)turnOverTopCard
//{
//	NSAssert([self.closedCards cardCount] > 0, @"No more cards");
//
//	Card *card = [self.closedCards topmostCard];
//	card.isTurnedOver = YES;
//	[self.openCards addCardToTop:card];
//	[self.closedCards removeTopmostCard];
//
//	return card;
//}
//
//- (BOOL)shouldRecycle
//{
//	return ([self.closedCards cardCount] == 0) && ([self.openCards cardCount] > 1);
//}
//
//- (NSArray *)recycleCards
//{
//	return [self giveAllOpenCardsToPlayer:self];
//}
//
//- (NSArray *)giveAllOpenCardsToPlayer:(Player *)otherPlayer
//{
//	NSUInteger count = [self.openCards cardCount];
//	NSMutableArray *movedCards = [NSMutableArray arrayWithCapacity:count];
//
//	for (NSUInteger t = 0; t < count; ++t)
//	{
//		Card *card = [self.openCards cardAtIndex:t];
//		card.isTurnedOver = NO;
//		[otherPlayer.closedCards addCardToBottom:card];
//		[movedCards addObject:card];
//	}
//
//	[self.openCards removeAllCards];
//	return movedCards;
//}
//
//- (int)totalCardCount
//{
//	return [self.closedCards cardCount] + [self.openCards cardCount];
//}
//
//- (Card *)giveTopmostClosedCardToPlayer:(Player *)otherPlayer
//{
//	Card *card = [self.closedCards topmostCard];
//	if (card != nil)
//	{
//		[otherPlayer.closedCards addCardToBottom:card];
//		[self.closedCards removeTopmostCard];
//	}
//	return card;
//}
//
//- (NSString *)description
//{
//	return [NSString stringWithFormat:@"%@ peerID = %@, name = %@, position = %d", [super description], self.peerID, self.name, self.position];
//}

@end
