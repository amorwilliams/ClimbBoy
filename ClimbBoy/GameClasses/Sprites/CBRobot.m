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
- (id)initAtPosition:(CGPoint)position {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Hero_Idle"];
    SKTexture *texture = [atlas textureNamed:@"hero_idle_0001.png"];
    
    return [super initWithTexture:texture atPosition:position];
}

#pragma mark - Shared Assets
+ (void)loadSharedAssets {
    [super loadSharedAssets];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sSharedIdleAnimationFrames = CBLoadFramesFromAtlas(@"Hero_Idle", @"hero_idle_");
        sSharedRunAnimationFrames = CBLoadFramesFromAtlas(@"Hero_Run", @"hero_run_");
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

@end
