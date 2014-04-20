
#import "MainViewController.h"
#import "NSData+Additions.h"
#import "Game.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameScene.h"
#import "IntroScene.h"

@interface MainViewController ()

@property (nonatomic, weak) IBOutlet UIButton *hostGameButton;
@property (nonatomic, weak) IBOutlet UIButton *joinGameButton;
@property (nonatomic, weak) IBOutlet UIButton *singlePlayerGameButton;

@end

@implementation MainViewController
{
	BOOL _buttonsEnabled;
	BOOL _performAnimations;
}

@synthesize hostGameButton = _hostGameButton;
@synthesize joinGameButton = _joinGameButton;
@synthesize singlePlayerGameButton = _singlePlayerGameButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		_performAnimations = YES;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self.hostGameButton rw_applySnapStyle];
	[self.joinGameButton rw_applySnapStyle];
	[self.singlePlayerGameButton rw_applySnapStyle];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if (_performAnimations)
		[self prepareForIntroAnimation];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (_performAnimations)
		[self performIntroAnimation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)prepareForIntroAnimation
{
	
	self.hostGameButton.alpha = 0.0f;
	self.joinGameButton.alpha = 0.0f;
	self.singlePlayerGameButton.alpha = 0.0f;

	_buttonsEnabled = NO;
}

- (void)performIntroAnimation
{
		
	[UIView animateWithDuration:0.5f
		delay:1.0f
		options:UIViewAnimationOptionCurveEaseOut
		animations:^
		{
			self.hostGameButton.alpha = 1.0f;
			self.joinGameButton.alpha = 1.0f;
			self.singlePlayerGameButton.alpha = 1.0f;
		}
		completion:^(BOOL finished)
		{
			_buttonsEnabled = YES;
		}];
}

- (void)performExitAnimationWithCompletionBlock:(void (^)(BOOL))block
{
	_buttonsEnabled = NO;
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
     {

     }
                     completion:block];
    
    [UIView animateWithDuration:0.3f
                          delay:0.3f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         self.hostGameButton.alpha = 0.0f;
         self.joinGameButton.alpha = 0.0f;
         self.singlePlayerGameButton.alpha = 0.0f;
     }
                     completion:nil];
}

- (IBAction)hostGameAction:(id)sender
{
	if (_buttonsEnabled)
	{
		[self performExitAnimationWithCompletionBlock:^(BOOL finished)
		{	
			HostViewController *controller = [[HostViewController alloc] initWithNibName:@"HostViewController" bundle:nil];
			controller.delegate = self;

			[self presentViewController:controller animated:NO completion:nil];
		}];
	}
}

- (IBAction)joinGameAction:(id)sender
{
	if (_buttonsEnabled)
	{
		[self performExitAnimationWithCompletionBlock:^(BOOL finished)
		{
			JoinViewController *controller = [[JoinViewController alloc] initWithNibName:@"JoinViewController" bundle:nil];
			controller.delegate = self;

			[self presentViewController:controller animated:NO completion:nil];
		}];
	}
}

- (IBAction)singlePlayerGameAction:(id)sender
{
	if (_buttonsEnabled)
	{
		[self performExitAnimationWithCompletionBlock:^(BOOL finished)
		{
            _gameInfo = [self buildSingleGameInfo];
			[self startGameWithBlock:^(Game *game)
			{
				[game startSinglePlayerGame];
			}];
		}];
	}
}

- (void)showNoNetworkAlert
{
	UIAlertView *alertView = [[UIAlertView alloc] 
		initWithTitle:NSLocalizedString(@"No Network", @"No network alert title")
		message:NSLocalizedString(@"To use multiplayer, please enable Bluetooth or Wi-Fi in your device's Settings.", @"No network alert message")
		delegate:nil
		cancelButtonTitle:NSLocalizedString(@"OK", @"Button: OK")
		otherButtonTitles:nil];

	[alertView show];
}

- (void)showDisconnectedAlert
{
	UIAlertView *alertView = [[UIAlertView alloc] 
		initWithTitle:NSLocalizedString(@"Disconnected", @"Client disconnected alert title")
		message:NSLocalizedString(@"You were disconnected from the game.", @"Client disconnected alert message")
		delegate:nil
		cancelButtonTitle:NSLocalizedString(@"OK", @"Button: OK")
		otherButtonTitles:nil];

	[alertView show];
}

- (void)startGameWithBlock:(void (^)(Game *))block
{
//	GameViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
//	gameViewController.delegate = self;
//
//	[self presentViewController:gameViewController animated:NO completion:^
//	{
//		Game *game = [[Game alloc] init];
//		gameViewController.game = game;
//		game.delegate = gameViewController;
//		block(game);
//	}];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    GameScene * startScene = (GameScene *)[[CCDirector sharedDirector] runningScene];
    Game *game = [[Game alloc] init];
    game.gameInfo = _gameInfo; //test
    startScene.game = game;
    game.delegate = startScene;
    block(game);
}

- (ExTank *)getTestWithPosition:(CGPoint)pos AndAngle:(float)angle AndName:(NSString *)name AndTeam:(NSInteger)team
{
    ExTank * tank = [[ExTank alloc] initWithPosition:pos AndAngle:angle AndName:name AndTeam:team];
    return tank;
}

- (ExGameInfo *)buildSingleGameInfo{
    ExGameInfo * info = [[ExGameInfo alloc] init];
    
    info.field = [[GameField alloc] initWithPosition:CGPointMake(0, 0) AndAngle:0 AndSize:CGSizeMake(480, 320)];
    
    Player *player = [[Player alloc] init];
	player.name = NSLocalizedString(@"You", @"Single player mode, name of user");
	player.peerID = @"1";
	player.screenPosition = 1;
    player.team = 0;
    
    NSInteger tankID = 0;
    Tank * tank = [[Tank alloc] initWithInfo:[self getTestWithPosition:homeTankPosition AndAngle:90 AndName:[NSString stringWithFormat:@"%@%d", player.name, tankID] AndTeam:player.team]];
    tank.tankID = tankID;
    [player.tanks setObject:tank forKey:@(tank.tankID)];
    
	[info.players setObject:player forKey:player.peerID];
    
	player = [[Player alloc] init];
	player.name = NSLocalizedString(@"Ray", @"Single player mode, name of other player");
	player.peerID = @"2";
	player.screenPosition = 1;
    
    tankID = 1;
    tank = [[Tank alloc] initWithInfo:[self getTestWithPosition:visitorTankPosition AndAngle:90 AndName:[NSString stringWithFormat:@"%@%d", player.name, tankID] AndTeam:player.team]];
    tank.tankID = tankID;
    [player.tanks setObject:tank forKey:@(tank.tankID)];
    
	[info.players setObject:player forKey:player.peerID];
    
    return info;
}

- (ExGameInfo *)buildServerGameWithSession:(GKSession *)session AndClients:(NSArray *)clients
{
    ExGameInfo * info = [[ExGameInfo alloc] init];
    
    info.field = [[GameField alloc] initWithPosition:CGPointMake(0, 0) AndAngle:0 AndSize:CGSizeMake(480, 320)];
    
    Player *player = [[Player alloc] init];
	player.name = NSLocalizedString(@"You", @"Single player mode, name of user");
	player.peerID = session.peerID;;
	player.screenPosition = 1;
    player.team = 0;
    
    NSInteger tankID = 0;
    Tank * tank = [[Tank alloc] initWithInfo:[self getTestWithPosition:homeTankPosition AndAngle:90 AndName:[NSString stringWithFormat:@"%@%d", player.name, tankID] AndTeam:player.team]];
    tank.tankID = tankID;
    [player.tanks setObject:tank forKey:@(tank.tankID)];
    
	[info.players setObject:player forKey:player.peerID];
    
	// Add a Player object for each client.
	int index = 1;
	for (NSString *peerID in clients)
	{
        
        player = [[Player alloc] init];
        player.name = peerID ;
        player.peerID = peerID;
        player.screenPosition = index;
        
        tankID = index;
        tank = [[Tank alloc] initWithInfo:[self getTestWithPosition:visitorTankPosition AndAngle:90 AndName:[NSString stringWithFormat:@"%@%d", player.name, tankID] AndTeam:player.team]];
        tank.tankID = tankID;
        [player.tanks setObject:tank forKey:@(tank.tankID)];
        
        [info.players setObject:player forKey:player.peerID];
        
		index++;
	}
    
    return info;

}


#pragma mark - HostViewControllerDelegate

- (void)hostViewControllerDidCancel:(HostViewController *)controller
{
	[self dismissViewControllerAnimated:NO completion:nil];
}

- (void)hostViewController:(HostViewController *)controller didEndSessionWithReason:(QuitReason)reason
{
	if (reason == QuitReasonNoNetwork)
	{
		[self showNoNetworkAlert];
	}
}

- (void)hostViewController:(HostViewController *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients
{
	_performAnimations = NO;

	[self dismissViewControllerAnimated:NO completion:^
	{
		_performAnimations = YES;
        _gameInfo = [self buildServerGameWithSession:session AndClients:clients];
		[self startGameWithBlock:^(Game *game)
		{
			[game startServerGameWithSession:session playerName:name clients:clients];
		}];
	}];
}

#pragma mark - JoinViewControllerDelegate

- (void)joinViewControllerDidCancel:(JoinViewController *)controller
{
	[self dismissViewControllerAnimated:NO completion:nil];
}

- (void)joinViewController:(JoinViewController *)controller didDisconnectWithReason:(QuitReason)reason
{
	// The "No Wi-Fi/Bluetooth" alert does not close the Join screen,
	// but the "Connection Dropped" disconnect does.

	if (reason == QuitReasonNoNetwork)
	{
		[self showNoNetworkAlert];
	}
	else if (reason == QuitReasonConnectionDropped)
	{
		[self dismissViewControllerAnimated:NO completion:^
		{
			[self showDisconnectedAlert];
		}];
	}
}

- (void)joinViewController:(JoinViewController *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID
{
	_performAnimations = NO;

	[self dismissViewControllerAnimated:NO completion:^
	{
		_performAnimations = YES;
        _gameInfo = nil;
		[self startGameWithBlock:^(Game *game)
		{
			[game startClientGameWithSession:session playerName:name server:peerID];
		}];
	}];
}

#pragma mark - GameViewControllerDelegate

- (void)gameViewController:(GameViewController *)controller didQuitWithReason:(QuitReason)reason
{
	[self dismissViewControllerAnimated:NO completion:^
	{
		if (reason == QuitReasonConnectionDropped)
		{
			[self showDisconnectedAlert];
		}
	}];
}

@end
