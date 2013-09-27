//
//  CBSpriteFlipBehavior.h
//  ClimbBoy
//
//  Created by Robin on 13-8-30.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKBehavior.h"

@interface FlipBySpeedBehavior : KKBehavior
{
    __weak KKNode *_targetNode;
}

+ (id) flipWithTarget:(KKNode *)target;

- (id) initWithTarget:(KKNode *)target;
@end
