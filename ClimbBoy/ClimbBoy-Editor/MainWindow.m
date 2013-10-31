//
//  MainWindow.m
//  ClimbBoy
//
//  Created by Robin on 13-10-31.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "MainWindow.h"
#import "AppDelegate.h"

@implementation MainWindow

-(void)disableUpdatesUntilFlush
{
    if(!needsEnableUpdate)
        NSDisableScreenUpdates();
    needsEnableUpdate = YES;
}

-(void)flushWindow
{
    [super flushWindow];
    if(needsEnableUpdate)
    {
        needsEnableUpdate = NO;
        NSEnableScreenUpdates();
    }
}

-(IBAction)performClose:(id)sender
{
    [[AppDelegate appDelegate] performClose:sender];
}

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem
{
    if ([menuItem.title isEqualToString:@"Close"])
    {
//        return [[AppDelegate appDelegate] hasOpenedDocument];
    }
    return [super validateMenuItem:menuItem];
}

@end
