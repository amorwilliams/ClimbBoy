//
//  CBCharacter.h
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

/* Used by the move: method to move a character in a given direction. */
typedef enum : uint8_t {
    CBMoveDirectionRight = 0,
    CBMoveDirectionLeft,
} CBMoveDirection;

/* The different animation states of an animated character. */
typedef enum : uint8_t {
    CBAnimationStateIdle = 0,
    CBAnimationStateWalk,
    CBAnimationStateRun,
    CBAnimationStateJump,
    CBAnimationStateClimb,
    CBAnimationStateAttack,
    CBAnimationStateGetHit,
    CBAnimationStateDeath,
    kAnimationStateCount
} CBAnimationState;

#define kMovementSpeed 200.0

#define kCharacterCollisionRadius   26
#define kProjectileCollisionRadius  15

#define kDefaultNumberOfWalkFrames 28
#define kDefaultNumberOfIdleFrames 28

#import <SpriteKit/SpriteKit.h>

@interface CBCharacter : SKSpriteNode

@property (nonatomic) CGFloat collisionRadius;

@property (nonatomic, getter = isDying) BOOL dying;
@property (nonatomic, getter = isJumping) BOOL jumping;
@property (nonatomic, getter = isClimbing) BOOL climbing;
@property (nonatomic) CGFloat health;
@property (nonatomic, getter = isAnimated) BOOL animated;
@property (nonatomic) CGFloat animationSpeed;
@property (nonatomic, getter = isGrounded) BOOL grounded;

@property (nonatomic) NSString *activeAnimationKey;
@property (nonatomic) CBAnimationState requestedAnimation;

/* Preload shared animation frames, emitters, etc. */
+ (void)loadSharedAssets;

/* Initialize a standard sprite. */
- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position;

/* Reset a character for reuse. */
- (void)reset;

/* Overridden Methods. */
//- (void)animationDidComplete:(CBAnimationState)animation;
- (void)collidedWith:(SKPhysicsBody *)other;
- (void)performJump;
- (void)performDeath;
- (void)configurePhysicsBody;
- (void)animationDidComplete:(CBAnimationState)animation;
- (void)onArrived;
- (void)onGrounded;

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

/* Loop Update - called once per frame. */
- (void) updateWithTimeSinceLastUpdate:(CFTimeInterval)interval;
- (void) didEvaluateActions;

/* Orientation, Movement, and Attacking. */
- (void)move:(CBMoveDirection)direction withTimeInterval:(NSTimeInterval)timeInterval;
- (void)move:(CBMoveDirection)direction bySpeed:(CGFloat)speed withTimeInterval:(NSTimeInterval)timeInterval;
//- (CGFloat)faceTo:(CGPoint)position;
- (void)moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval;
- (void)moveInDirection:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval;

@end
