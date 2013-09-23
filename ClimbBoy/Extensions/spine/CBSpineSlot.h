//
//  CBSpineSlot.h
//  ClimbBoy
//
//  Created by Robin on 13-9-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <spine/spine.h>
#import "CBSpineAttachment.h"

@interface CBSpineSlot : SKNode
{
    Slot *_slot;
    CBSpineAttachment *_attachmentNode;
    SKSpriteNode *_debugNode;
    
    SKTexture *_regionTextureAtlas;
}

@property (nonatomic)SKColor *color;

+ (id)slotNodeWithSlot:(Slot *)slot;

- (id)initWithSlot:(Slot *)slot;

- (void)updateSlot:(Slot *)slot;
- (void)removeAttachment;

@end
