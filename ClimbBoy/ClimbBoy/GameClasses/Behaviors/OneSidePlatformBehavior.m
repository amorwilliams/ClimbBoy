//
//  OneSidePlatformBehavior.m
//  ClimbBoy
//
//  Created by Robin on 13-10-14.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "OneSidePlatformBehavior.h"
#import "HeroCharacter.h"

@implementation OneSidePlatformBehavior

- (void)didJoinController
{
    [self.node.kkScene addSceneEventsObserver:self];
}

- (void)didLeaveController
{
    [self.node.kkScene removeSceneEventsObserver:self];
}

- (void)didBeginContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody
{
    NSLog(@"Hero touch me");
    if (otherBody.node.position.y > self.node.position.y &&
        otherBody.velocity.dy < -1) {
        otherBody.affectedByGravity = NO;
        _palyer = otherBody.node;
        [self didSimulatePhysics];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody
{
    otherBody.affectedByGravity = YES;
    _palyer = nil;
}

- (void)didSimulatePhysics
{
    if (_palyer) {
        _palyer.position = ccp(_palyer.position.x, self.node.position.y+25);
        _palyer.physicsBody.velocity = ccv(_palyer.physicsBody.velocity.dx, 0);
    }
}

@end
