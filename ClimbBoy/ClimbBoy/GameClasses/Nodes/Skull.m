//
//  Skull.m
//  ClimbBoy
//
//  Created by Robin on 13-10-21.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Skull.h"

@implementation Skull

- (id)init
{
//    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture: [[[CBAnimationCache sharedCBAnimationCache] animationByName:@"Hero_Idle"] firstObject]];
    self = [super initWithSpineSprite:[SKSpriteNode spriteNodeWithImageNamed:@"hero_idle_0001.png"]];
    if (self) {
        [self.characterSprite setScale:0.6];
        [self loadAnimationFrames:[[CBAnimationCache sharedCBAnimationCache] animationByName:@"Hero_Idle"] state:CBAnimationStateIdle];
        [self loadAnimationFrames:[[CBAnimationCache sharedCBAnimationCache] animationByName:@"Hero_Run"] state:CBAnimationStateRun];
    }
    return self;
}

+ (void)loadSharedAssets {
    [[CBAnimationCache sharedCBAnimationCache] addAnimationsWithAtlas:@"Hero_Idle" fileBaseName:@"hero_idle_"];
    [[CBAnimationCache sharedCBAnimationCache] addAnimationsWithAtlas:@"Hero_Run" fileBaseName:@"hero_run_"];
    [[CBAnimationCache sharedCBAnimationCache] addAnimationsWithAtlas:@"Hero_Jump_Start" fileBaseName:@"hero_jump_start_"];
    [[CBAnimationCache sharedCBAnimationCache] addAnimationsWithAtlas:@"Hero_Jump_Loop" fileBaseName:@"hero_jump_loop_"];
    [[CBAnimationCache sharedCBAnimationCache] addAnimationsWithAtlas:@"Hero_Jump_Land_Long" fileBaseName:@"hero_jump_land_long_"];
    [[CBAnimationCache sharedCBAnimationCache] addAnimationsWithAtlas:@"Hero_Climb_Loop" fileBaseName:@"hero_climb_loop_"];
}

@end
