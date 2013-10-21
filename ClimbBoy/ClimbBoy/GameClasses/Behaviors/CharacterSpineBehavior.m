//
//  CharacterSpineBehavior.m
//  ClimbBoy
//
//  Created by Robin on 13-10-21.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CharacterSpineBehavior.h"

@implementation CharacterSpineBehavior

- (void)didJoinController {
    _character = (BaseCharacter *)self.node;
    NSAssert([_character isKindOfClass:[BaseCharacter class]], @"Target node (%@) is not of class CBCharacter!", _character);
    
    NSAssert([_character.characterSprite isKindOfClass:[CBSpineSprite class]], @"Target node (%@)'s characterSpine is not of class CBSpineSprite!", _character.characterSprite);
    _spine = (CBSpineSprite *)_character.characterSprite;
    
    _animated = YES;
    _animationSpeed = 1.0f/30.0f;
}

- (void)didLeaveController {
    
}

#pragma mark - Loop Update
- (void)reset {
    _animated = YES;
    self.requestedAnimation = CBAnimationStateIdle;
}

- (void)setRequestedAnimation:(CBAnimationState)requestedAnimation
{
    if (requestedAnimation != _requestedAnimation)
    {
        _requestedAnimation = requestedAnimation;
        [self resolveRequestedAnimation];
    }
}


#pragma mark - Animation
- (void)resolveRequestedAnimation {
    // Determine the animation we want to play.
    NSString *animationKey = nil;
    //    NSArray *animationFrames = nil;
    CBAnimationState animationState = self.requestedAnimation;
    
    switch (animationState) {
            
        default:
        case CBAnimationStateIdle:
            animationKey = @"anim_idle";
            [(CBSpineSprite *)_spine setAnimationForTrack:0 name:@"stand" loop:YES];
            break;
            
        case CBAnimationStateWalk:
            animationKey = @"anim_walk";
            [(CBSpineSprite *)_spine setAnimationForTrack:0 name:@"walk" loop:YES];
            break;
            
        case CBAnimationStateRun:
            animationKey = @"anim_run";
            [(CBSpineSprite *)_spine setAnimationForTrack:0 name:@"run" loop:YES];
            break;
            
        case CBAnimationStateJump:
            animationKey = @"anim_jumpLoop";
            [(CBSpineSprite *)_spine setAnimationForTrack:0 name:@"jump-loop" loop:YES];
            break;
            
        case CBAnimationStateFall:
            animationKey = @"anim_fall";
            [(CBSpineSprite *)_spine setAnimationForTrack:0 name:@"fall-loop" loop:YES];
            break;
            
        case CBAnimationStateClimb:
            animationKey = @"anim_climb";
            [(CBSpineSprite *)_spine setAnimationForTrack:0 name:@"jump-loop" loop:YES];
            break;
            
        case CBAnimationStateAttack:
            animationKey = @"anim_attack";
            [(CBSpineSprite *)_spine setAnimationForTrack:0 name:@"stand-attack" loop:NO];
            break;
            
        case CBAnimationStateGetHit:
            animationKey = @"anim_hit";
            [(CBSpineSprite *)_spine setAnimationForTrack:0 name:@"hit" loop:NO];
            break;
            
        case CBAnimationStateDeath:
            animationKey = @"anim_death";
            [(CBSpineSprite *)_spine setAnimationForTrack:0 name:@"die" loop:NO];
            break;
    }
    
    if (animationKey) {
        //        [self fireAnimationForState:animationState usingTextures:animationFrames withKey:animationKey];
        self.activeAnimationKey = animationKey;
    }
}

@end
