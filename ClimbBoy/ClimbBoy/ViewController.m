/*
 * Copyright (c) 2013 Steffen Itterheim.
 * Released under the MIT License:
 * KoboldAid/licenses/KoboldKitFree.License.txt
 */

#import <KoboldKit.h>
#import "ViewController.h"
#import "MyScene.h"
#import "MainMenu.h"
#import "DebugNodeTestScene.h"

@implementation ViewController

-(void) presentFirstScene
{
	NSLog(@"%@", koboldKitCommunityVersion());
	NSLog(@"%@", koboldKitProVersion());
    

	// create and present first scene
//	MyScene* myScene = [MyScene sceneWithSize:self.view.bounds.size];
//	[self.kkView presentScene:myScene];
    
    MainMenu* myScene = [MainMenu sceneWithSize:self.view.bounds.size];
	[self.kkView presentScene:myScene];
    
//    DebugNodeTestScene *debugScene = [DebugNodeTestScene sceneWithSize:self.view.bounds.size];
//    [self.kkView presentScene:debugScene];
}

@end
