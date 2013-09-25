//
//  CBSpineAttachment.h
//  ClimbBoy
//
//  Created by Robin on 13-9-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <spine/spine.h>

@interface CBSpineAttachment : SKSpriteNode
{
    RegionAttachment *_attachment;
}

+ (instancetype)attachmentWithTexture:(SKTexture *)texture slot:(Slot *)slot;

- (instancetype)initWithTexture:(SKTexture *)texture slot:(Slot *)slot;

- (void)updataAttachment:(Slot *)slot;

@end
