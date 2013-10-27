//
//  CBCharacter.h
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "CBCategories.h"
#import "spine-spirte-kit.h"
#import "CBMacros.h"
#import "Entity.h"

/* Used by the move: method to move a character in a given direction. */
typedef enum : int8_t {
    kCBMoveDirectionRight = 1,
    kCBMoveDirectionLeft = -1,
} CBMoveDirection;

/* The different animation states of an animated character. */
typedef enum : uint8_t {
    CBAnimationStateIdle = 0,
    CBAnimationStateWalk,
    CBAnimationStateRun,
    CBAnimationStateJump,
    CBAnimationStateFall,
    CBAnimationStateClimb,
    CBAnimationStateAttack,
    CBAnimationStateGetHit,
    CBAnimationStateDeath,
    kAnimationStateCount
} CBAnimationState;

//#define kMovementSpeed 300.0
//
//#define kCharacterCollisionRadius   15
//#define kCharacterCollisionHeight   80
//#define kProjectileCollisionRadius  15
//
//#define kDefaultNumberOfWalkFrames 28
//#define kDefaultNumberOfIdleFrames 28

// Increase n towards target by speed
static inline float IncrementTowards(float n, float target, float a, NSTimeInterval deltaTime) {
    if (n == target) {
        return n;
    }
    else {
        float dir = SIGN(target - n); // must n be increased or decreased to get closer to target
        n += a * deltaTime * dir;
        return (dir == SIGN(target-n))? n: target; // if n has now passed target then return target, otherwise return n
    }
}

@class CharacterAnimatorBehavior, CharacterPhysicsBehavior;

@interface BaseCharacter : Entity 
{
    CFTimeInterval _lastUpdateTimeInterval;
    CGFloat _targetSpeed;
    CGFloat _currentSpeed;
    CGFloat _jumpSpeed;
    
    __weak SKNode *_platformNode;
    CGFloat _platformOffsetX;
    
    KKBehavior *_animatorBehavior;
}
/* 保存角色的贴图 */
@property (atomic) SKNode *characterSprite;
/* 角色碰撞的半径 */
//@property (nonatomic) CBCapsule collisionCapsule;
@property (nonatomic) CGSize boundingBox;

/* Movement */
@property (nonatomic) CGFloat jumpSpeedInitial;
@property (nonatomic) CGFloat jumpSpeedDeceleration;
@property (nonatomic) CGFloat jumpAbortVelocity;
@property (nonatomic) CGFloat fallSpeedAcceleration;
@property (nonatomic) CGFloat fallSpeedLimit;
@property (nonatomic) CGFloat runSpeedAcceleration;
@property (nonatomic) CGFloat runSpeedDeceleration;
@property (nonatomic) CGFloat runSpeedLimit;

/* Animation */
//@property (nonatomic) CharacterAnimatorBehavior *animatorBehavior;
//@property (atomic, getter = isAnimated) BOOL animated;
//@property (atomic) CGFloat animationSpeed;
@property (nonatomic) NSString *activeAnimationKey;
//@property (atomic) CBAnimationState requestedAnimation;

/* States */
@property (nonatomic, getter = isDying) BOOL dying;
//@property (nonatomic, getter = isStartJump) BOOL startJump;
@property (nonatomic, getter = isJumping) BOOL jumping;
@property (nonatomic, getter = isFalling) BOOL falling;
@property (nonatomic, getter = isClimbing) BOOL climbing;
//@property (nonatomic, getter = isWallJumping) BOOL wallJumping;
@property (nonatomic, getter = isAttacking) BOOL attacking;
@property (nonatomic, getter = isAttackColdDown) BOOL attackColdDown;
@property (nonatomic) CGFloat attackColdDownTime;
@property (nonatomic) CGFloat health;
//@property (nonatomic, getter = isStartLand) BOOL startLand;

/* Physics */
@property (nonatomic, getter = isGrounded) BOOL grounded;
@property (nonatomic, getter = isTouchTop) BOOL touchTop;
@property (nonatomic, getter = isTouchSide) BOOL touchSide;
@property (nonatomic) int touchingSideDirection;
//@property (nonatomic) CGVector touchSideNormal;

/* 如果为YES，将会开启地面接触检测，并会收到onGrounded的回调 */
//@property (nonatomic) BOOL enableGroundTest;
/* 如果为YES，将会开启角色两侧接触检测，并会收到onTouchSide的回调 */
//@property (nonatomic) BOOL enableSideTest;

/* Preload shared animation frames, emitters, etc. */
+ (void) loadSharedAssets;

/* Initialize a standard sprite. */
- (id) initWithSpineSprite:(SKNode *)sprite;

/* Reset a character for reuse. */
- (void) reset;

/* Overridden Methods. */
//- (void)animationDidComplete:(CBAnimationState)animation;
- (void) configurePhysicsBody;
- (void) onArrived;

- (void) onGrounded;
- (void) onTouchTop;
- (void) onTouchSide;

- (void) doStand;
- (void) doRun;
- (void) doJump;
- (void) doFall;
- (void) doClimb;
- (void) doDie;
- (void) doAttack;

/* Assets - should be overridden for animated characters. */
- (SKEmitterNode *) damageEmitter;   // provide an emitter to show damage applied to character
- (SKAction *) damageAction;         // action to run when damage is applied

- (void)runAnimation:(CBAnimationState)animationState;

/* Loop Update - called once per frame. */
- (void) updateWithDeltaTime:(CFTimeInterval)delta;
- (void) didEvaluateActions;
- (void) didSimulatePhysics;

/* Orientation, Movement, and Attacking. */
- (void) move:(CBMoveDirection)direction bySpeed:(CGFloat)speed deltaTime:(CFTimeInterval)deltaTime;
- (void) move:(CBMoveDirection)direction bySpeed:(CGFloat)speed acceleration:(CGFloat)acceleration deltaTime:(CFTimeInterval)deltaTime;
- (void) jump:(CFTimeInterval)deltaTime;
- (void) jumpWithDeceleration:(CGFloat)deceleration deltaTime:(CFTimeInterval)deltaTime;
//- (CGVector)calculateForceWithSpeed:(CGFloat)speed byAxis:(CBAxisType)axis withTimeInterval:(NSTimeInterval)timeInterval;
//- (CGFloat)faceTo:(CGPoint)position;
- (void) moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval;
- (void) moveInDirection:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval;
- (void) climb:(CBMoveDirection)direction withTimeInterval:(NSTimeInterval)timeInterval;

- (NSArray *) animationFramesWithState:(CBAnimationState)state;
- (void) loadAnimationFrames:(NSArray*)animation state:(CBAnimationState)state;

@end
