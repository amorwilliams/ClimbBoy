//
//  CBRobot.m
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "HeroRobot.h"
#import "CBGraphicsUtilities.h"

@implementation HeroRobot

#pragma mark - Initialization
- (id)init {
    self = [super init];
    if (self) {
        CBSpineSprite *spineSprite = [CBSpineSprite skeletonWithFile:@"light knight.json" atlasFile:@"light knight.atlas" scale:1];
        [spineSprite setDelegate:self];
        [spineSprite setMixFrom:@"stand" to:@"run" duration:0.2];
        [spineSprite setMixFrom:@"run" to:@"stand" duration:0.2];
        [spineSprite setMixFrom:@"stand" to:@"jump-loop" duration:0.2];
        [spineSprite setMixFrom:@"run" to:@"jump-loop" duration:0.2];
        [spineSprite setMixFrom:@"jump-loop" to:@"fall-loop" duration:0.2];
        [spineSprite setMixFrom:@"fall-loop" to:@"stand" duration:0.1];
        [spineSprite setMixFrom:@"fall-loop" to:@"run" duration:0.1];
        [spineSprite setMixFrom:@"stand" to:@"stand-attack" duration:0.1];
        [spineSprite setMixFrom:@"run" to:@"stand-attack" duration:0.1];
        [spineSprite setMixFrom:@"stand-attack" to:@"stand" duration:0.2];
        [spineSprite setMixFrom:@"stand-attack" to:@"run" duration:0.2];
        
        if(self = [super initWithSpineSprite:spineSprite]){
            //        self.characterSprite.anchorPoint = CGPointMake(0.5, 0.45);
            [self.characterSprite setScale:0.2];
            self.characterSprite.position = ccp(0, -25);
        }
        
        self.attackColdDownTime = 0;
        
//        self.fallSpeedAcceleration = 3000;
//        self.fallSpeedLimit = 800;
//        self.jumpAbortVelocity = 500;
//        self.jumpSpeedInitial = 600;
//        self.jumpSpeedDeceleration = 800;
//        self.runSpeedAcceleration = 1200;
//        self.runSpeedDeceleration = 900;
//        self.runSpeedLimit = 300;
//        self.climbUpSpeedLimit = 300;
//        self.climbDownSpeedLimit = 50;
//        self.boundingBox = CGSizeMake(32, 52);
        
//        [self configurePhysicsBody];
    }
    return self;
}
#pragma mark - Spine Animation Event

- (void)animationDidStart:(CBSpineSprite *)animation track:(int)trackIndex
{
//    TrackEntry *entry = [animation getCurrentForTrack:trackIndex];
//    NSString *animationName = @(entry->animation->name);
//    NSLog(@"animationDidStart track: %@", animationName);
}

- (void)animationWillEnd:(CBSpineSprite *)animation track:(int)trackIndex
{
    TrackEntry *entry = [animation getCurrentForTrack:trackIndex];
    NSString *animationName = @(entry->animation->name);
//    NSLog(@"animationWillEnd track: %@", animationName);
    if ([animationName isEqualToString:@"stand-attack"]) {
        self.attacking = NO;
    }
}

- (void)animationDidComplete:(CBSpineSprite *)animation track:(int)trackIndex loopCount:(int)loopCount
{
//    TrackEntry *entry = [animation getCurrentForTrack:trackIndex];
//    NSString *animationName = @(entry->animation->name);
//    NSLog(@"animationDidComplete loopcount: %@", animationName);
}

- (void)animationDidTriggerEvent:(CBSpineSprite *)animation track:(int)trackIndex event:(Event *)event
{
    NSLog(@"animationDidTriggerEvent event: %@ , %@", @(event->data->name), @(event->stringValue));
}

#pragma mark - Shared Assets
/*
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
*/
@end
