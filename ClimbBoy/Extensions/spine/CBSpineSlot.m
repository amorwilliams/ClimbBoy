//
//  CBSpineSlot.m
//  ClimbBoy
//
//  Created by Robin on 13-9-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CBSpineSlot.h"

@implementation CBSpineSlot

+ (id)slotNodeWithSlot:(Slot *)slot {
    return [[[self class] alloc] initWithSlot:slot];
}

- (id)initWithSlot:(Slot *)slot
{
    self = [super init];
    if (self) {
        self.name = @(slot->data->name);
        [self updateSlot:slot];
         _debugNode = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:1 green:0 blue:0 alpha:0.5] size:CGSizeMake(3, 3)];
        [self addChild:_debugNode];
        _debugNode.zPosition = 10;
    }
    return self;
}

- (void) initialize:(Slot *)slot {
    [self updateSlot:slot];
}

- (void) updateSlot:(Slot *)slot {
    _slot = slot;
    
    self.position = ccp(_slot->bone->worldX, _slot->bone->worldY);
    
    // slot data has an attachment
    if (_slot->attachment) {
        // we already have an attachment, make sure it's visible and update with new slot data.
        if (_attachmentNode) {
            _attachmentNode.alpha = 1;
            
        // else we do not have an attachment already set
        }else{
            RegionAttachment *attachment = (RegionAttachment *)slot->attachment;
            SKTexture *texture = [self createAttahcmentTexture:attachment];
            _attachmentNode = [CBSpineAttachment attachmentWithTexture:texture slot:slot];
            _attachmentNode.size = CGSizeMake(attachment->width, attachment->height);
            self.xScale = attachment->scaleX;
            self.yScale = attachment->scaleY;
//            self.zRotation = attachment->rotation;
            [self addChild:_attachmentNode];
        }
        
        [_attachmentNode updataAttachment:slot];

    // slot is empty
    }else{
        
        // we currently have an attachment, so hide it
        if(_attachmentNode){
            _attachmentNode.alpha = 0;
        }
    }
}

- (SKTexture *)createAttahcmentTexture:(RegionAttachment *)attachment {
    _regionTextureAtlas = [self getTextureAtlas:attachment];
    AtlasRegion *regionTexture = ((AtlasRegion *)attachment->rendererObject);
    float w = regionTexture->width / _regionTextureAtlas.size.width;
    float h = regionTexture->height / _regionTextureAtlas.size.height;
    float x = regionTexture->x  / _regionTextureAtlas.size.width;
    float y = (_regionTextureAtlas.size.height - regionTexture->y - regionTexture->height) / _regionTextureAtlas.size.height;
    
    return [SKTexture textureWithRect:CGRectMake(x, y, w, h) inTexture:_regionTextureAtlas];
}

- (SKTexture*) getTextureAtlas:(RegionAttachment*)regionAttachment {
	SKTexture *rt = (__bridge SKTexture*)((AtlasRegion*)regionAttachment->rendererObject)->page->rendererObject;
    return rt;
}

- (void)removeAttachment {
    if (_attachmentNode) {
        [_attachmentNode removeFromParent];
        _attachmentNode = nil;
    }
}

- (NSString *)name{
    if (_slot) {
        return @(_slot->data->name);
    }
    
    return nil;
}

#if TARGET_OS_IPHONE
- (void)setColor:(UIColor *)color {
    _color = color;
    if (_attachmentNode) {
        _attachmentNode.color = color;
    }
}
#else
- (NSColor *)color {
    
}
#endif

@end
