//
//  GameScene.m
//  TankFight
//
//  Created by Jason Wang on 2014-03-13.
//  Copyright (c) 2014 Jason Wang. All rights reserved.
//
#import "IntroScene.h"
#import "GameScene.h"
#import "Tank.h"
#import "DisplayManager.h"

@implementation GameScene
{
    DisplayManager * physicsManager;
    DisplayManager * uiManager;
    CCLabelTTF  *textLabel;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (GameScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
    [self addChild:background];

    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    textLabel = [CCLabelTTF labelWithString:@"." fontName:@"Helvetica" fontSize:20];
    textLabel.position =  ccp(250,200);
    [self addChild:textLabel];
    
    textLabel = [CCLabelTTF labelWithString:@"test" fontName:@"Helvetica" fontSize:20];
    textLabel.position =  ccp(255,60);
    [self addChild:textLabel];
    //[[CCDirector sharedDirector] pause];
    
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    
    // 1
    CGPoint touchLocation = [touch locationInNode:self];
    
    //scan test
    //[physicsManager.ccTanks[0] scan:160];
    //Fire test
    //[physicsManager.ccTanks[0] fireAt:touchLocation]; return;
    //move test
    [physicsManager.ccTanks[0] moveTo:touchLocation];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self  selector:@selector(fireAT) userInfo:nil repeats:NO];


}

-(void)fireAT{
    [physicsManager.ccTanks[0] fireAt:CGPointMake(250, 200)];
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

- (void) update:(CCTime) time {
    [physicsManager updateUI:time];
    //NSLog(@"scene update.");
    [uiManager updateUI:time];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

//-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    CGPoint touchLoc = [touch locationInNode:self];
//    
//    // Log touch location
//    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
//    
//    // Move our sprite to touch location
//    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
//    [_sprite runAction:actionMove];
//}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------

#pragma mark - GameDelegate

- (void)gameWaitingForClientsReady:(Game *)game
{
    [textLabel setString:NSLocalizedString(@"Waiting for other players...", @"Status text: waiting for clients")];
	//self.centerLabel.text = NSLocalizedString(@"Waiting for other players...", @"Status text: waiting for clients");
}

- (void)gameWaitingForServerReady:(Game *)game
{
    [textLabel setString:NSLocalizedString(@"Waiting for game to start...", @"Status text: waiting for server")];

	//self.centerLabel.text = NSLocalizedString(@"Waiting for game to start...", @"Status text: waiting for server");
}

- (void)gameDidBegin:(Game *)game
{
    
    [textLabel setString:@"gameDidBegin."];
    
    CGPoint displayOrigin = CGPointZero;
    
    if (game.isServer) {
        [CCDirector sharedDirector].contentScaleFactor = 1;
        physicsManager = [[DisplayManager alloc] initWithGameLogic:game AtOrigin:CGPointMake(0, 320) WithPhysics:YES];
        [self addChild:physicsManager.rootNode];        
        //displayOrigin = CGPointMake(500, 0);
        
    }
    
    uiManager = [[DisplayManager alloc] initWithGameLogic:game AtOrigin:displayOrigin WithPhysics:NO];
    [self addChild:uiManager.rootNode];
    
    [[CCDirector sharedDirector] resume];
    
    //	[self showPlayerLabels];
    //	[self calculateLabelFrames];
    //	[self updateWinsLabels];
}

- (void)gameDidBeginNewRound:(Game *)game
{
    //	[self removeAllRemainingCardViews];
}

- (void)gameShouldDealCards:(Game *)game startingWithPlayer:(Player *)startingPlayer
{
    //	self.centerLabel.text = NSLocalizedString(@"Dealing...", @"Status text: dealing");
    //
    //	self.snapButton.hidden = YES;
    //	self.nextRoundButton.hidden = YES;
    //
    //	NSTimeInterval delay = 1.0f;
    //
    //	_dealingCardsSound.currentTime = 0.0f;
    //	[_dealingCardsSound prepareToPlay];
    //	[_dealingCardsSound performSelector:@selector(play) withObject:nil afterDelay:delay];
    //
    //	for (int t = 0; t < 26; ++t)
    //	{
    //		for (PlayerPosition p = startingPlayer.position; p < startingPlayer.position + 4; ++p)
    //		{
    //			Player *player = [self.game playerAtPosition:p % 4];
    //			if (player != nil && t < [player.closedCards cardCount])
    //			{
    //				CardView *cardView = [[CardView alloc] initWithFrame:CGRectMake(0, 0, CardWidth, CardHeight)];
    //				cardView.card = [player.closedCards cardAtIndex:t];
    //				[self.cardContainerView addSubview:cardView];
    //				[cardView animateDealingToPlayer:player withDelay:delay];
    //				delay += 0.1f;
    //			}
    //		}
    //	}
    //
    //	[self performSelector:@selector(afterDealing) withObject:nil afterDelay:delay];
}

- (void)afterDealing
{
    //	[_dealingCardsSound stop];
    //	self.snapButton.hidden = NO;
    //	[self.game beginRound];
}

- (void)game:(Game *)game didActivatePlayer:(Player *)player
{
    //	[self showIndicatorForActivePlayer];
    //	self.snapButton.enabled = YES;
}




- (void)game:(Game *)game roundDidEndWithWinner:(Player *)player
{
    //	self.centerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"** Winner: %@ **", @"Status text: winner of a round"), player.name];
    //
    //	self.snapButton.hidden = YES;
    //	self.nextRoundButton.hidden = !game.isServer;
    //
    //	[self updateWinsLabels];
    //	[self hideActivePlayerIndicator];
}

- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer redistributedCards:(NSDictionary *)redistributedCards
{
    //	[self hidePlayerLabelsForPlayer:disconnectedPlayer];
    //	[self hideActiveIndicatorForPlayer:disconnectedPlayer];
    //	[self hideSnapIndicatorForPlayer:disconnectedPlayer];
    
    //	for (PlayerPosition p = PlayerPositionBottom; p <= PlayerPositionRight; ++p)
    //	{
    //		Player *otherPlayer = [self.game playerAtPosition:p];
    //		if (otherPlayer != disconnectedPlayer)
    //		{
    //			NSArray *cards = [redistributedCards objectForKey:otherPlayer.peerID];
    //			for (Card *card in cards)
    //			{
    //				// Note: the CardView at this point has a Card object that has
    //				// the same suit and value as our "card", but on the client it
    //				// is actually a different Card object!
    //				CardView *cardView = [self cardViewForCard:card];
    //				cardView.card = card;
    //				[cardView animateCloseAndMoveFromPlayer:disconnectedPlayer toPlayer:otherPlayer withDelay:0.0f];
    //			}
    //		}
    //	}
}

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason
{
	//[self.delegate gameViewController:self didQuitWithReason:reason];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex)
	{
		// Stop any pending performSelector:withObject:afterDelay: messages.
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
        
		[self.game quitGameWithReason:QuitReasonUserQuit];
	}
}

@end