//
//  CBSpriteFlipBehavior.m
//  ClimbBoy
//
//  Created by Robin on 13-8-30.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CharacterSpriteFlipBehavior.h"
#import "SKSpriteNode+CBExtension.h"

@interface CharacterSpriteFlipBehavior ()
@property (atomic, weak) SKSpriteNode *spriteNode;

@end

@implementation CharacterSpriteFlipBehavior

+ (id) SpriteFlipWithTarget:(SKSpriteNode *)target {
    return [[self alloc] initWithTarget:target];
}

- (id)initWithTarget:(SKSpriteNode *)target {
    self = [super init];
	if (self)
	{
		_spriteNode = target;
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
        _spriteNode.flipX = NO;
    }else if (currentSpeedX < -100){
        _spriteNode.flipX = YES;
    }
}


@end
