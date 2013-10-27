//
//  AppDelegate.m
//  ClimbBoy-Editor
//
//  Created by Robin on 13-10-25.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "AppDelegate.h"
#import "SpriteKitScene.h"

@implementation AppDelegate


- (void)setupSKScene {
    _kkViewController = [[KKViewController alloc] initWithNibName:nil bundle:nil];
	NSAssert([_kkViewController isKindOfClass:[KKViewController class]], @"'ViewController' class is not a subclass of KKViewController.");
	
	_kkViewController.view = self.spriteKitView;
	[_kkViewController viewDidLoad];
    
	NSLog(@"%@", koboldKitCommunityVersion());
	NSLog(@"%@", koboldKitProVersion());
    
	// create and present first scene
    _spriteKitScene = [SpriteKitScene sceneWithSize:self.spriteKitView.bounds.size];
    _spriteKitScene.scaleMode = SKSceneScaleModeResizeFill;
	[self.spriteKitView presentScene:_spriteKitScene];

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setupSKScene];
    
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    return YES;
}

- (IBAction) openDocument:(id)sender
{
    // Create the File Open Dialog
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowedFileTypes:[NSArray arrayWithObject:@"tmx"]];
    
    [openDlg beginSheetModalForWindow:_window completionHandler:^(NSInteger result){
        if (result == NSOKButton)
        {
            NSArray* files = [openDlg URLs];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0),
                           dispatch_get_main_queue(), ^{
                               for (int i = 0; i < [files count]; i++)
                               {
                                   NSString* fileName = [[files objectAtIndex:i] path];
                                   [self openFile:fileName];
                               }
                           });
        }
    }];
}

- (void)openFile:(NSString *)fileName
{
    NSLog(@"opned file: %@", fileName);
}

@end
