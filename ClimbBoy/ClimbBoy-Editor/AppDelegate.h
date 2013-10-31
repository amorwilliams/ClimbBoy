//
//  AppDelegate.h
//  ClimbBoy-Editor
//
//  Created by Robin on 13-10-25.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindow;
@class SpriteKitScene;
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet MainWindow *window;

//Main Menu
- (IBAction)menuZoomIn:(id)sender;
- (IBAction)menuZoomOut:(id)sender;
- (IBAction)menuResetView:(id)sender;


@property (weak) IBOutlet KKView *spriteKitView;
@property (nonatomic) KKViewController *kkViewController;
@property (nonatomic) SpriteKitScene *spriteKitScene;

+ (AppDelegate*) appDelegate;

- (IBAction) performClose:(id)sender;

@end
