//
//  NewDocWindowController.h
//  ClimbBoy
//
//  Created by Robin on 13-10-31.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NewDocWindowController : NSWindowController

@property (nonatomic, assign) int orientationIndex;
@property (nonatomic, assign) int encodingIndex;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) int tilewidth;
@property (nonatomic, assign) int tileheight;

@property (weak) IBOutlet NSTextField *pixelSizeLabel;


- (IBAction)acceptSheet:(id)sender;
- (IBAction)cancelSheet:(id)sender;

@end
