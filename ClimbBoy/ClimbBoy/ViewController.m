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

    CGSize viewSize = self.view.bounds.size;

    // On iPhone/iPod touch we want to see a similar amount of the scene as on iPad.
    // So, we set the size of the scene to be double the size of the view, which is
    // the whole screen, 3.5- or 4- inch. This effectively scales the scene to 50%.
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        viewSize.height *= 2;
//        viewSize.width *= 2;
//    }
    
    // create and present first scene
    MainMenu *mainScene = [MainMenu sceneWithSize:viewSize];
    [self.kkView presentScene:mainScene];
}

@end
