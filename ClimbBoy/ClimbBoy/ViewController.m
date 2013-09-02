/*
 * Copyright (c) 2013 Steffen Itterheim.
 * Released under the MIT License:
 * KoboldAid/licenses/KoboldKitFree.License.txt
 */

#import <KoboldKit.h>
#import "ViewController.h"
#import "CBMyScene.h"
#import "LevelTest.h"
#import "MainMenu.h"

@implementation ViewController

-(void) presentFirstScene
{
	NSLog(@"%@", koboldKitCommunityVersion());
	NSLog(@"%@", koboldKitProVersion());

	// create and present first scene
//	CBMyScene* myScene = [CBMyScene sceneWithSize:self.view.bounds.size];
//	[self.kkView presentScene:myScene];
    
    MainMenu *mainScene = [MainMenu sceneWithSize:self.view.bounds.size];
    [self.kkView presentScene:mainScene];
    
//    LevelTest *level = [LevelTest sceneWithSize:self.view.bounds.size];
//    [level setScale:0.5];
//    [self.kkView presentScene:level];
    
}

@end
