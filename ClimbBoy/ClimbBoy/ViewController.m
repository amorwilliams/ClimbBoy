/*
 * Copyright (c) 2013 Steffen Itterheim.
 * Released under the MIT License:
 * KoboldAid/licenses/KoboldKitFree.License.txt
 */

#import <KoboldKit.h>
#import "ViewController.h"
#import "IntroScene.h"
#import "GameManager.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[GameManager sharedGameManager] setView:self.kkView];
}

-(void) presentFirstScene
{
	NSLog(@"%@", koboldKitCommunityVersion());
	NSLog(@"%@", koboldKitProVersion());
    
#if TARGET_OS_IPHONE
	// create and present first scene
    IntroScene* scene = [IntroScene sceneWithSize:self.view.bounds.size];
	[self.kkView presentScene:scene];
#else //Mac OS
    
#endif

}

@end
