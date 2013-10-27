//
//  AppDelegate.h
//  ClimbBoy-Editor
//
//  Created by Robin on 13-10-25.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SpriteKitScene;
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet KKView *spriteKitView;
@property (nonatomic) KKViewController *kkViewController;
@property (nonatomic) SpriteKitScene *spriteKitScene;

@end
