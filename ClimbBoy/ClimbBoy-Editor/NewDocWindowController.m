//
//  NewDocWindowController.m
//  ClimbBoy
//
//  Created by Robin on 13-10-31.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "NewDocWindowController.h"

@interface NewDocWindowController ()

@end

@implementation NewDocWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (!self) return NULL;
    
    _orientationIndex = 0;
    _encodingIndex = 1;
    
    _width = 12;
    _height = 6;
    _tilewidth = 32;
    _tileheight = 32;
    
    return self;
}

- (void) awakeFromNib
{
//    [self addFullScreenResolutions];
    [self updatePixelSizeLabel];

}

- (IBAction)acceptSheet:(id)sender
{
    if ([[self window] makeFirstResponder:[self window]])
    {
        // Verify resolutions
//        BOOL foundEnabledResolution = NO;
//        for (ResolutionSetting* setting in resolutions)
//        {
//            if (setting.enabled) foundEnabledResolution = YES;
//        }
        
        if (YES)
        {
            [NSApp stopModalWithCode:1];
        }
        else
        {
            // Display warning!
            NSAlert* alert = [NSAlert alertWithMessageText:@"Missing Resolution" defaultButton:@"OK" alternateButton:NULL otherButton:NULL informativeTextWithFormat:@"You need to have at least one resolution enabled to create a new document."];
            [alert beginSheetModalForWindow:[self window] modalDelegate:NULL didEndSelector:NULL contextInfo:NULL];
        }
    }
}

- (IBAction)cancelSheet:(id)sender
{
    [NSApp stopModalWithCode:0];
}

- (void)setWidth:(int)width
{
    _width = width;
    [self updatePixelSizeLabel];
}

- (void)setHeight:(int)height
{
    _height = height;
    [self updatePixelSizeLabel];
}

- (void)setTilewidth:(int)tilewidth
{
    _tilewidth = tilewidth;
    [self updatePixelSizeLabel];
}

- (void)setTileheight:(int)tileheight
{
    _tileheight = tileheight;
    [self updatePixelSizeLabel];
}

- (void)updatePixelSizeLabel
{
    [_pixelSizeLabel setStringValue:[NSString stringWithFormat:@"%dx%d pixels", _width*_tilewidth, _height*_tileheight]];
}

@end
