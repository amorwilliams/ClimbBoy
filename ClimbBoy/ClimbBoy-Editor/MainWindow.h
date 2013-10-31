//
//  MainWindow.h
//  ClimbBoy
//
//  Created by Robin on 13-10-31.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindow : NSWindow
{
    BOOL needsEnableUpdate;
}

-(void)disableUpdatesUntilFlush;
@end
