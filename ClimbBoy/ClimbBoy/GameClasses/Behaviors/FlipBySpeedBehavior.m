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

+ (id) flipWithTarget:(KKNode *)target {
    return [[self alloc] initWithTarget:target];
}

- (id)initWithTarget:(KKNode *)target {
    self = [super init];
	if (self)
	{
		_targetNode = target;
	}
	return self;
}

- (void)didJoinController {
    [self.node.kkScene addSceneEventsObserver:self];
    
}

- (void)didLeaveController {
    [self.node.kkScene removeSceneEventsObserver:self];

}

- (void) didSimulatePhysics {
    float currentSpeedX = self.node.physicsBody.velocity.dx;
    if (currentSpeedX > 100) {
        _targetNode.flipX = NO;
    }else if (currentSpeedX < -100){
        _targetNode.flipX = YES;
    }
}


@end
