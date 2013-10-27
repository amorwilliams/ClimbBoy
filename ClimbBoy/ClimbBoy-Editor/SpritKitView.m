//
//  SpritKitView.m
//  ClimbBoy
//
//  Created by Robin on 13-10-27.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "SpritKitView.h"
#import "SpriteKitScene.h"

@implementation SpritKitView

- (BOOL) acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}

- (void)awakeFromNib
{
    [self registerForDraggedTypes:[NSArray arrayWithObjects: @"com.cocosbuilder.texture", @"com.cocosbuilder.template", @"com.cocosbuilder.ccb", NULL]];
}

-(BOOL) acceptsFirstResponder
{
	return NO;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    return NSDragOperationGeneric;
}

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender
{
    NSPoint pt = [self convertPoint:[sender draggingLocation] fromView:NULL];
    pt = NSMakePoint(roundf(pt.x),roundf(pt.y));
    
    NSPasteboard* pb = [sender draggingPasteboard];
    
    NSData* pdData = [pb dataForType:@"com.cocosbuilder.texture"];
    if (pdData)
    {
        NSDictionary* pdDict = [NSKeyedUnarchiver unarchiveObjectWithData:pdData];
//        [appDelegate dropAddSpriteNamed:[pdDict objectForKey:@"spriteFile"] inSpriteSheet:[pdDict objectForKey:@"spriteSheetFile"] at:ccp(pt.x,pt.y)];
    }
    
    pdData = [pb dataForType:@"com.cocosbuilder.ccb"];
    if (pdData)
    {
        NSLog(@"Handling ccb drop!");
        NSDictionary* pdDict = [NSKeyedUnarchiver unarchiveObjectWithData:pdData];
//        [appDelegate dropAddCCBFileNamed:[pdDict objectForKey:@"ccbFile"] at:ccp(pt.x,pt.y) parent:NULL];
    }
    
    return YES;
}

- (void) scrollWheel:(NSEvent *)theEvent
{
    [[SpriteKitScene spriteKitScene] scrollWheel:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [[SpriteKitScene spriteKitScene] mouseDown:theEvent];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    [[SpriteKitScene spriteKitScene] mouseMoved:theEvent];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [[SpriteKitScene spriteKitScene] mouseEntered:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [[SpriteKitScene spriteKitScene] mouseExited:theEvent];
}

- (void)cursorUpdate:(NSEvent *)event
{
    [[SpriteKitScene spriteKitScene] cursorUpdate:event];
}


@end
