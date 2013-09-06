//
//  CBCharacter.h
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

/* Used by the move: method to move a character in a given direction. */
typedef enum : int8_t {
    kCBMoveDirectionRight = 1,
    kCBMoveDirectionLeft = -1,
} CBMoveDirection;

typedef enum : int8_t {
    kCBCharacterTouchSideNil = 0,
    kCBCharacterTouchSideRight = 1,
    kCBCharacterTouchSideLeft = -1,
} CBCharacterTouchSide;

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

/* Bitmask for the different entities with physics bodies. */
typedef enum : uint8_t {
    CBColliderTypeHero             = 1,
    CBColliderTypeGoblinOrBoss     = 2,
    CBColliderTypeProjectile       = 4,
    CBColliderTypeWall             = 8,
    CBColliderTypeCave             = 16
} CBColliderType;

typedef enum : uint8_t {
    kCBAxisTypeX = 0,
    kCBAxisTypeY,
    kCBAxisTypeXY,
} CBAxisType;

#define kMovementSpeed 300.0

#define kCharacterCollisionRadius   15
#define kCharacterCollisionHeight   80
#define kProjectileCollisionRadius  15

#define kDefaultNumberOfWalkFrames 28
#define kDefaultNumberOfIdleFrames 28

#import <SpriteKit/SpriteKit.h>
#import "CBCategories.h"
#import "CBBehaviors.h"
#import "CBCharacterAnimatorDelegate.h"

@class CBCharacterAnimator;

@interface CBCharacter : KKNode <KKPhysicsContactEventDelegate, CBCharacterAnimatorDelegate>
/* 保存角色的贴图 */
@property (nonatomic, retain) SKSpriteNode *characterSprite;
/* 角色碰撞的半径 */
@property (nonatomic) CBCapsule collisionCapsule;
@property (nonatomic) CGSize boundingBox;

@property (nonatomic) CBCharacterAnimator *animatorBehavior;

@property (nonatomic, getter = isDying) BOOL dying;
//@property (nonatomic, getter = isStartJump) BOOL startJump;
//@property (nonatomic, getter = isJumping) BOOL jumping;
//@property (nonatomic, getter = isClimbing) BOOL climbing;
//@property (nonatomic, getter = isWallJumping) BOOL wallJumping;
@property (nonatomic, getter = isTouchSide) BOOL touchSide;
@property (nonatomic, readonly) CBCharacterTouchSide touchingSide;
@property (nonatomic) CGVector touchSideNormal;
@property (nonatomic) CGFloat health;
//@property (nonatomic, getter = isStartLand) BOOL startLand;
@property (nonatomic, getter = isGrounded) BOOL grounded;
@property (nonatomic, getter = isTouchTop) BOOL touchTop;

/* 如果为YES，将会开启地面接触检测，并会收到onGrounded的回调 */
@property (nonatomic) BOOL enableGroundTest;
/* 如果为YES，将会开启角色两侧接触检测，并会收到onTouchSide的回调 */
@property (nonatomic) BOOL enableSideTest;

/* Preload shared animation frames, emitters, etc. */
+ (void)loadSharedAssets;

/* Initialize a standard sprite. */
- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position;

/* Reset a character for reuse. */
- (void)reset;

/* Overridden Methods. */
//- (void)animationDidComplete:(CBAnimationState)animation;
- (void)didBeginContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody;
- (void)didEndContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody;
- (void)configurePhysicsBody;
- (void)onArrived;
- (void)onGrounded;
- (void)onTouchHeadTop;
- (void)onTouchSide:(CBCharacterTouchSide)side;

- (void)doStand;
- (void)doRun;
- (void)doJump;
- (void)doFall;
- (void)doClimb;
- (void)doDie;

/* Assets - should be overridden for animated characters. */
- (NSArray *)idleAnimationFrames;
- (NSArray *)walkAnimationFrames;
- (NSArray *)runAnimationFrames;
- (NSArray *)jumpStartAnimationFrames;
- (NSArray *)jumpLoopAnimationFrames;
- (NSArray *)landAnimationFrames;
- (NSArray *)climbAnimationFrames;
- (NSArray *)attackAnimationFrames;
- (NSArray *)getHitAnimationFrames;
- (NSArray *)deathAnimationFrames;
- (SKEmitterNode *)damageEmitter;   // provide an emitter to show damage applied to character
- (SKAction *)damageAction;         // action to run when damage is applied

- (void)runAnimation:(CBAnimationState)animationState;

/* Loop Update - called once per frame. */
- (void) updateWithTimeSinceLastUpdate:(CFTimeInterval)delta;
- (void) didEvaluateActions;
- (void) didSimulatePhysics;

/* Orientation, Movement, and Attacking. */
- (void)move:(CBMoveDirection)direction withTimeInterval:(NSTimeInterval)timeInterval;
- (void)move:(CBMoveDirection)direction bySpeed:(CGFloat)speed withTimeInterval:(NSTimeInterval)timeInterval;
- (CGVector)calculateForceWithSpeed:(CGFloat)speed byAxis:(CBAxisType)axis withTimeInterval:(NSTimeInterval)timeInterval;
//- (CGFloat)faceTo:(CGPoint)position;
- (void)moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval;
- (void)moveInDirection:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval;
- (void)climb:(CBMoveDirection)direction withTimeInterval:(NSTimeInterval)timeInterval;

@end
