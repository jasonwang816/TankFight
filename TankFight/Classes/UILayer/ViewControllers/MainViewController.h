
#import "HostViewController.h"
#import "JoinViewController.h"
#import "GameViewController.h"
#import "ExGameInfo.h"

@interface MainViewController : UIViewController <HostViewControllerDelegate, JoinViewControllerDelegate, GameViewControllerDelegate>

@property (nonatomic) ExGameInfo * gameInfo;

@end
