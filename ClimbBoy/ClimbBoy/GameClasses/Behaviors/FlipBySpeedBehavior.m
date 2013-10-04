//
//  CBSpriteFlipBehavior.m
//  ClimbBoy
//
//  Created by Robin on 13-8-30.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "FlipBySpeedBehavior.h"
#import "SKNode+CBExtension.h"

@implementation FlipBySpeedBehavior

- (void)didJoinController {
    [self.node.kkScene addSceneEventsObserver:self];
}

- (void)didLeaveController {
    [self.node.kkScene removeSceneEventsObserver:self];
}

- (void) didSimulatePhysics {
    if (_targetSpriteNode) {
        float currentSpeedX = self.node.physicsBody.velocity.dx;
        if (currentSpeedX > 10) {
            _targetSpriteNode.flipX = NO;
        }else if (currentSpeedX < -10){
            _targetSpriteNode.flipX = YES;
        }
    }
}


@end
