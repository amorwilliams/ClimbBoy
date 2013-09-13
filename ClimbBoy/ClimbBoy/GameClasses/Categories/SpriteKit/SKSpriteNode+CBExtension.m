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
        self.xScale = -ABS(self.xScale);
    }else{
        self.xScale = ABS(self.xScale);
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
        self.yScale = -ABS(self.yScale);
    }else{
        self.yScale = ABS(self.yScale);
    }
}

@end
