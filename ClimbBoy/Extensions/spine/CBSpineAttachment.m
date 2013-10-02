//
//  CBSpineAttachment.m
//  ClimbBoy
//
//  Created by Robin on 13-9-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CBSpineAttachment.h"

@implementation CBSpineAttachment

+ (instancetype)attachmentWithTexture:(SKTexture *)texture slot:(Slot *)slot {
    return [[[self class] alloc]initWithTexture:texture slot:slot];
}

- (id)initWithTexture:(SKTexture *)texture slot:(Slot *)slot
{
    self = [super initWithTexture:texture];
    if (self) {
        _attachment = (RegionAttachment *)slot->attachment;
        [self initialize:slot];
    }
    return self;
}

- (void) initialize:(Slot *)slot{
    self.colorBlendFactor = 1;
    [self updataAttachment:slot];
}

- (void)updataAttachment:(Slot *)slot{
    _attachment = (RegionAttachment *)slot->attachment;
    
    //set position
    float vertices[8];
    RegionAttachment_computeWorldVertices(_attachment, slot->skeleton->x, slot->skeleton->y, slot->bone, vertices);
    CGPoint pos = [self centerPointFromQuad:vertices];
    self.position = ccpSub(pos, self.parent.position);
    
    //set rotation
    float amount = 0;
    Bone *bone = slot->bone;
    while (bone) {
        amount += bone->rotation;
        bone = bone->parent;
    }
    self.zRotation = KK_DEG2RAD(amount +  _attachment->rotation);
    
    //set scale
    self.xScale = slot->bone->scaleX * _attachment->scaleX;
    self.yScale = slot->bone->scaleY * _attachment->scaleY;
    
    //set color
    float r = slot->skeleton->r * slot->r;
    float g = slot->skeleton->g * slot->g;
    float b = slot->skeleton->b * slot->b;
    float normalizedAlpha = slot->skeleton->a * slot->a;
    self.alpha = normalizedAlpha;
    self.color = [SKColor colorWithRed:r green:g blue:b alpha:1];
}

- (CGPoint)centerPointFromQuad:(float *)vertices {
    CGPoint p1 = ccp(vertices[VERTEX_X1], vertices[VERTEX_Y1]);
    CGPoint p2 = ccp(vertices[VERTEX_X2], vertices[VERTEX_Y2]);
    CGPoint p3 = ccp(vertices[VERTEX_X3], vertices[VERTEX_Y3]);
    CGPoint p4 = ccp(vertices[VERTEX_X4], vertices[VERTEX_Y4]);
    
    CGPoint ret = CGPointZero;
    ret.x = (p1.x + p2.x + p3.x + p4.x)/4;
    ret.y = (p1.y + p2.y + p3.y + p4.y)/4;
    
    return ret;
}

- (NSString *)name {
    if (_attachment) {
        return @(_attachment->super.name);
    }else{
        return nil;
    }
}

@end
