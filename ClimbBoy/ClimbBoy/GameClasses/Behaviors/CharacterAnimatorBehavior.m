//
//  CBCharacterAnimator.m
//  ClimbBoy
//
//  Created by Robin on 13-9-3.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CharacterAnimatorBehavior.h"

@interface CharacterAnimatorBehavior ()
@property (atomic, weak)BaseCharacter *character;

@end

@implementation CharacterAnimatorBehavior

- (void)didJoinController {
    [self.node.kkScene addSceneEventsObserver:self];
    
    _character = (BaseCharacter *)self.node;
    NSAssert1([_character isKindOfClass:[BaseCharacter class]], @"Target node (%@) is not of class CBCharacter!", _character);
    
    _animated = YES;
    _animationSpeed = 1.0f/30.0f;
}

- (void)didLeaveController {
    [self.node.kkScene removeSceneEventsObserver:self];
}

#pragma mark - Loop Update
-(void)update:(NSTimeInterval)currentTime {
    if (self.isAnimated) {
//        [self resolveRequestedAnimation];
    }
}

- (void)reset {
    _animated = YES;
    _requestedAnimation = CBAnimationStateIdle;
}

#pragma mark - Animation
/*
- (void)resolveRequestedAnimation {
    // Determine the animation we want to play.
    NSString *animationKey = nil;
    NSArray *animationFrames = nil;
    CBAnimationState animationState = self.requestedAnimation;
    
    switch (animationState) {
            
        default:
        case CBAnimationStateIdle:
            animationKey = @"anim_idle";
            animationFrames = [_character idleAnimationFrames];
            break;
            
        case CBAnimationStateWalk:
            animationKey = @"anim_walk";
            animationFrames = [_character walkAnimationFrames];
            break;
            
        case CBAnimationStateRun:
            animationKey = @"anim_run";
            animationFrames = [_character runAnimationFrames];
            break;
            
        case CBAnimationStateJump:
            animationKey = @"anim_jumpLoop";
            animationFrames = [_character jumpStartAnimationFrames];
            break;
            
        case CBAnimationStateFall:
            animationKey = @"anim_fall";
            animationFrames = [_character jumpLoopAnimationFrames];
            break;
            
        case CBAnimationStateClimb:
            animationKey = @"anim_climb";
            animationFrames = [_character climbAnimationFrames];
            break;
            
        case CBAnimationStateAttack:
            animationKey = @"anim_attack";
            animationFrames = [_character attackAnimationFrames];
            break;
            
        case CBAnimationStateGetHit:
            animationKey = @"anim_gethit";
            animationFrames = [_character getHitAnimationFrames];
            break;
            
        case CBAnimationStateDeath:
            animationKey = @"anim_death";
            animationFrames = [_character deathAnimationFrames];
            break;
    }
    
    if (animationKey) {
        [self fireAnimationForState:animationState usingTextures:animationFrames withKey:animationKey];
    }
    
//    if (_character.isDying) {
//        self.requestedAnimation = CBAnimationStateDeath;
//    }else if (_character.isClimbing) {
//        self.requestedAnimation = CBAnimationStateClimb;
//    }else if (_character.isJumping){
//        self.requestedAnimation = CBAnimationStateJump;
//    }else{
//        if(fabsf(_character.physicsBody.velocity.dx) > 50){
//            self.requestedAnimation = CBAnimationStateRun;
//        }else{
//            self.requestedAnimation = CBAnimationStateIdle;
//        }
//    }
}

- (void)fireAnimationForState:(CBAnimationState)animationState usingTextures:(NSArray *)frames withKey:(NSString *)key {
    SKAction *animAction = [_character.characterSprite actionForKey:key];
    if (animAction || [frames count] < 1) {
        return; // we already have a running animation or there aren't any frames to animate
    }
    
    [_character.characterSprite removeActionForKey:self.activeAnimationKey];
    self.activeAnimationKey = key;
    
    [_character.characterSprite runAction:[SKAction sequence:@[
                                                         [SKAction animateWithTextures:frames timePerFrame:self.animationSpeed resize:YES restore:NO],
                                                         [SKAction runBlock:^{
        [self animationHasCompleted:animationState];
    }]]] withKey:key];
}

- (void)animationHasCompleted:(CBAnimationState)animationState {
    [(id<CharacterAnimatorDelegate>)_character animationHasCompleted:animationState];
    
    self.activeAnimationKey = nil;
}
*/

@end
