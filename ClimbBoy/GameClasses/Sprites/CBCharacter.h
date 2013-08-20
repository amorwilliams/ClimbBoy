//
//  CBCharacter.h
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

/* The different animation states of an animated character. */
typedef enum : uint8_t {
    CBAnimationStateIdle = 0,
    CBAnimationStateWalk,
    CBAnimationStateRun,
    CBAnimationStateAttack,
    CBAnimationStateGetHit,
    CBAnimationStateDeath,
    kAnimationStateCount
} CBAnimationState;

#define kMovementSpeed 200.0
#define kRotationSpeed 0.06

#define kCharacterCollisionRadius   40
#define kProjectileCollisionRadius  15

#define kDefaultNumberOfWalkFrames 28
#define kDefaultNumberOfIdleFrames 28

#import <SpriteKit/SpriteKit.h>

@interface CBCharacter : SKSpriteNode

@property (nonatomic, getter=isDying) BOOL dying;
@property (nonatomic, getter=isAttacking) BOOL attacking;
@property (nonatomic) CGFloat health;
@property (nonatomic, getter=isAnimated) BOOL animated;
@property (nonatomic) CGFloat animationSpeed;
@property (nonatomic) CGFloat movementSpeed;

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
- (void)performDeath;
- (void)configurePhysicsBody;

/* Assets - should be overridden for animated characters. */
- (NSArray *)idleAnimationFrames;
- (NSArray *)walkAnimationFrames;
- (NSArray *)runAnimationFrames;
- (NSArray *)attackAnimationFrames;
- (NSArray *)getHitAnimationFrames;
- (NSArray *)deathAnimationFrames;
- (SKEmitterNode *)damageEmitter;   // provide an emitter to show damage applied to character
- (SKAction *)damageAction;         // action to run when damage is applied

/* Loop Update - called once per frame. */
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval;

@end
