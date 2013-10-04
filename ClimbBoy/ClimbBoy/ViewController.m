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
    [self.kkView setMultipleTouchEnabled:YES];
    
    [[GameManager sharedGameManager] setView:self.kkView];
}

-(void) presentFirstScene
{
	NSLog(@"%@", koboldKitCommunityVersion());
	NSLog(@"%@", koboldKitProVersion());
    
	// create and present first scene
//    CGSize size = CGSizeMake(self.view.bounds.size.width * 2, self.view.bounds.size.height * 2);
    IntroScene* scene = [IntroScene sceneWithSize:self.view.bounds.size];
	[self.kkView presentScene:scene];
}

@end
