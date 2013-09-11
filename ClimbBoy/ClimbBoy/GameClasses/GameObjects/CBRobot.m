//
//  CBRobot.m
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "CBRobot.h"
#import "CBGraphicsUtilities.h"

@implementation CBRobot

#pragma mark - Initialization
- (id)init {
    self = [super init];
    if (self) {
        return [self initAtPosition:CGPointZero];
    }
    return self;
}

- (id)initAtPosition:(CGPoint)position {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Hero_Idle"];
    SKTexture *texture = [atlas textureNamed:@"hero_idle_0001.png"];
    
    if(self = [super initWithTexture:texture atPosition:position]){
        self.characterSprite.anchorPoint = CGPointMake(0.5, 0.45);
        [self.characterSprite setScale:0.5];
    }
    
    return self;
}

#pragma mark - Shared Assets
+ (void)loadSharedAssets {
    [super loadSharedAssets];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sSharedIdleAnimationFrames = CBLoadFramesFromAtlas(@"Hero_Idle", @"hero_idle_");
        sSharedRunAnimationFrames = CBLoadFramesFromAtlas(@"Hero_Run", @"hero_run_");
        sSharedJumpStartAnimationFrames = CBLoadFramesFromAtlas(@"Hero_Jump_Start", @"hero_jump_start_");
        sSharedJumpLoopAnimationFrames = CBLoadFramesFromAtlas(@"Hero_Jump_Loop", @"hero_jump_loop_");
        sSharedLandAnimationFrames = CBLoadFramesFromAtlas(@"Hero_Jump_Land_Long", @"hero_jump_land_long_");
        sSharedClimbAnimationFrames = CBLoadFramesFromAtlas(@"Hero_Climb_Loop", @"hero_climb_loop_");

    });
}

static NSArray *sSharedIdleAnimationFrames = nil;
- (NSArray *)idleAnimationFrames {
    return sSharedIdleAnimationFrames;
}

static NSArray *sSharedRunAnimationFrames = nil;
- (NSArray *)runAnimationFrames {
    return sSharedRunAnimationFrames;
}

static NSArray *sSharedJumpStartAnimationFrames = nil;
- (NSArray *)jumpStartAnimationFrames {
    return sSharedJumpStartAnimationFrames;
}

static NSArray *sSharedJumpLoopAnimationFrames = nil;
- (NSArray *)jumpLoopAnimationFrames {
    return sSharedJumpLoopAnimationFrames;
}

static NSArray *sSharedLandAnimationFrames = nil;
- (NSArray *)landAnimationFrames {
    return sSharedLandAnimationFrames;
}

static NSArray *sSharedClimbAnimationFrames = nil;
- (NSArray *)climbAnimationFrames {
    return sSharedClimbAnimationFrames;
}
@end
