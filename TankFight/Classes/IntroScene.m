//
//  IntroScene.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright Jason Wang 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "GameScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    // Helloworld scene button
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[ Start ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.35f);
    [helloWorldButton setTarget:self selector:@selector(loadMyViewController)];
    [self addChild:helloWorldButton];

//    // Helloworld scene button
//    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[ Start ]" fontName:@"Verdana-Bold" fontSize:18.0f];
//    helloWorldButton.positionType = CCPositionTypeNormalized;
//    helloWorldButton.position = ccp(0.5f, 0.35f);
//    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
//    [self addChild:helloWorldButton];
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
//    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    [[CCDirector sharedDirector] replaceScene:[GameScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];


}

- (void)loadMyViewController {
    //[[CCDirector sharedDirector] replaceScene:[GameScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
    
    _viewController = [[MainViewController alloc] init];
    
    [[CCDirector sharedDirector] presentModalViewController:_viewController animated:YES];

    
//    AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
//    [app.navController pushViewController:myView animated:YES];
    //[[CCDirector sharedDirector] pause];
}

// -----------------------------------------------------------------------
//
//
//#pragma mark - GameDelegate
//
//- (void)gameWaitingForClientsReady:(Game *)game
//{
//	//self.centerLabel.text = NSLocalizedString(@"Waiting for other players...", @"Status text: waiting for clients");
//}
//
//- (void)gameWaitingForServerReady:(Game *)game
//{
//	//self.centerLabel.text = NSLocalizedString(@"Waiting for game to start...", @"Status text: waiting for server");
//}
//
//- (void)gameDidBegin:(Game *)game
//{
//    [[CCDirector sharedDirector] resume];
//    
//    
////	[self showPlayerLabels];
////	[self calculateLabelFrames];
////	[self updateWinsLabels];
//}
//
//- (void)gameDidBeginNewRound:(Game *)game
//{
////	[self removeAllRemainingCardViews];
//}
//
//- (void)gameShouldDealCards:(Game *)game startingWithPlayer:(Player *)startingPlayer
//{
////	self.centerLabel.text = NSLocalizedString(@"Dealing...", @"Status text: dealing");
////    
////	self.snapButton.hidden = YES;
////	self.nextRoundButton.hidden = YES;
////    
////	NSTimeInterval delay = 1.0f;
////    
////	_dealingCardsSound.currentTime = 0.0f;
////	[_dealingCardsSound prepareToPlay];
////	[_dealingCardsSound performSelector:@selector(play) withObject:nil afterDelay:delay];
////    
////	for (int t = 0; t < 26; ++t)
////	{
////		for (PlayerPosition p = startingPlayer.position; p < startingPlayer.position + 4; ++p)
////		{
////			Player *player = [self.game playerAtPosition:p % 4];
////			if (player != nil && t < [player.closedCards cardCount])
////			{
////				CardView *cardView = [[CardView alloc] initWithFrame:CGRectMake(0, 0, CardWidth, CardHeight)];
////				cardView.card = [player.closedCards cardAtIndex:t];
////				[self.cardContainerView addSubview:cardView];
////				[cardView animateDealingToPlayer:player withDelay:delay];
////				delay += 0.1f;
////			}
////		}
////	}
////    
////	[self performSelector:@selector(afterDealing) withObject:nil afterDelay:delay];
//}
//
//- (void)afterDealing
//{
////	[_dealingCardsSound stop];
////	self.snapButton.hidden = NO;
////	[self.game beginRound];
//}
//
//- (void)game:(Game *)game didActivatePlayer:(Player *)player
//{
////	[self showIndicatorForActivePlayer];
////	self.snapButton.enabled = YES;
//}
//
//
//
//
//- (void)game:(Game *)game roundDidEndWithWinner:(Player *)player
//{
////	self.centerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"** Winner: %@ **", @"Status text: winner of a round"), player.name];
////    
////	self.snapButton.hidden = YES;
////	self.nextRoundButton.hidden = !game.isServer;
////    
////	[self updateWinsLabels];
////	[self hideActivePlayerIndicator];
//}
//
//- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer redistributedCards:(NSDictionary *)redistributedCards
//{
////	[self hidePlayerLabelsForPlayer:disconnectedPlayer];
////	[self hideActiveIndicatorForPlayer:disconnectedPlayer];
////	[self hideSnapIndicatorForPlayer:disconnectedPlayer];
//    
////	for (PlayerPosition p = PlayerPositionBottom; p <= PlayerPositionRight; ++p)
////	{
////		Player *otherPlayer = [self.game playerAtPosition:p];
////		if (otherPlayer != disconnectedPlayer)
////		{
////			NSArray *cards = [redistributedCards objectForKey:otherPlayer.peerID];
////			for (Card *card in cards)
////			{
////				// Note: the CardView at this point has a Card object that has
////				// the same suit and value as our "card", but on the client it
////				// is actually a different Card object!
////				CardView *cardView = [self cardViewForCard:card];
////				cardView.card = card;
////				[cardView animateCloseAndMoveFromPlayer:disconnectedPlayer toPlayer:otherPlayer withDelay:0.0f];
////			}
////		}
////	}
//}
//
//- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason
//{
//	//[self.delegate gameViewController:self didQuitWithReason:reason];
//}
//
//#pragma mark - UIAlertViewDelegate
//
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//	if (buttonIndex != alertView.cancelButtonIndex)
//	{
//		// Stop any pending performSelector:withObject:afterDelay: messages.
//		[NSObject cancelPreviousPerformRequestsWithTarget:self];
//        
//		[self.game quitGameWithReason:QuitReasonUserQuit];
//	}
//}
//
@end
