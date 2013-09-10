//
//  SKSpriteNode+CBExtension.m
//  ClimbBoy
//
//  Created by Robin on 13-8-21.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "SKSpriteNode+CBExtension.h"

@implementation SKSpriteNode (CBExtension)

@dynamic flipX;
-(BOOL)flipX
{
    return self.xScale < 0 ? YES : NO;
}
- (void)setFlipX:(BOOL)b
{
    if (self.flipX == b) {
        return;
    }
    
    if (b) {
        [self runAction:[SKAction scaleXTo:-ABS(self.xScale) duration:0]];
    }else{
        [self runAction:[SKAction scaleXTo:ABS(self.xScale) duration:0]];
    }
}

@dynamic flipY;
-(BOOL)flipY
{
    return self.yScale < 0 ? YES : NO;
}
-(void)setFlipY:(BOOL)b
{
    if (self.flipY == b) {
        return;
    }
    
    if (b) {
        [self runAction:[SKAction scaleYTo:-ABS(self.yScale) duration:0]];
    }else{
        [self runAction:[SKAction scaleXTo:ABS(self.yScale) duration:0]];
    }
}

@end
