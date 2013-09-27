//
//  CBCharacter.m
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "BaseCharacter.h"
#import "CBBehaviors.h"
#import "CBMacros.h"
#import "Debug.h"

@interface BaseCharacter ()
{
}
@property (nonatomic) CFTimeInterval lastUpdateTimeInterval;

@end

@implementation BaseCharacter
@synthesize node;
#pragma mark - Initialization
- (id)initWithSpineSprite:(CBSpineSprite *)spineSprite atPosition:(CGPoint)position {
    if (self = [super init]) {
        self.characterSprite = spineSprite;

        [self sharedInitAtPosition:position];
        _enableGroundTest = YES;
        _enableSideTest = NO;
    }
    
    return self;
}

- (void)sharedInitAtPosition:(CGPoint)position {
    
    self.position = position;
    
    _collisionCapsule = CBCapsuleMake(kCharacterCollisionRadius, kCharacterCollisionHeight);
    _health = 100.0f;
    
    [self configurePhysicsBody];
}

- (void)reset {
    // Reset some base states (used when recycling character instances).
    self.health = 100.0f;
    self.touchSide = NO;
}

- (void)didMoveToParent {
    [self observeSceneEvents];
    [self.kkScene addPhysicsContactEventsObserver:self];
    FlipBySpeedBehavior *flipBehavior = [FlipBySpeedBehavior flipWithTarget:self.characterSprite];
    [self addBehavior:flipBehavior withKey:@"flip"];
    
    [self addChild:self.characterSprite];
}


#pragma mark - Overridden Methods
- (void)configurePhysicsBody {
    // Overridden by subclasses to create a physics body with relevant collision settings for this character.
}

#pragma mark - FSM Action Methods
- (void)doStand {
    [self runAnimation:CBAnimationStateIdle];
}

- (void)doRun {
    [self runAnimation:CBAnimationStateRun];
}

- (void)doJump {
    [self runAnimation:CBAnimationStateJump];
}

- (void)doFall {
    [self runAnimation:CBAnimationStateFall];
}

- (void)doClimb {
    [self runAnimation:CBAnimationStateClimb];
}

- (void)doDie {
    self.health = 0.0f;
    [self runAnimation:CBAnimationStateDeath];
}


#pragma mark - Character Events
- (void)onArrived{
    //Called when moveTowards has arrived point (usually overidden)
}

- (void)onGrounded{
    //Called when character is landing (usually overidden)
}

- (void)onTouchHeadTop{
    //Called when character is touch top of head (usually overidden)
}

- (void)onTouchSide:(CBCharacterTouchSide)side{
    //Called when chararcter is touch (usually overidden)
}

#pragma mark - Loop Update
- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1/60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)delta {
    
}

-(void) didEvaluateActions {
    [self rayTesting];
}

- (void) didSimulatePhysics {
    
}

#pragma mark - Physics Delegate
//- (SKNode *)node {
//    return self;
//}

- (void)didBeginContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody {
//    [self rayTesting];

}

- (void)didEndContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody {
//    [self rayTesting];

}

#pragma mark - Animation
- (void)animationHasCompleted:(CBAnimationState)animationState {
    // Called when a requested animation has completed (usually overriden).
}

- (void)runAnimation:(CBAnimationState)animationState
{
    if (animationState != self.requestedAnimation)
    {
        self.requestedAnimation = animationState;
        [self resolveRequestedAnimation];
    }
}

- (void)resolveRequestedAnimation {
    // Determine the animation we want to play.
    NSString *animationKey = nil;
//    NSArray *animationFrames = nil;
    CBAnimationState animationState = self.requestedAnimation;
    
    switch (animationState) {
            
        default:
        case CBAnimationStateIdle:
            animationKey = @"anim_idle";
            [self.characterSprite playAnimation:@"stand" loop:YES];
            break;
            
        case CBAnimationStateWalk:
            animationKey = @"anim_walk";
            [self.characterSprite playAnimation:@"walk" loop:YES];
            break;
            
        case CBAnimationStateRun:
            animationKey = @"anim_run";
            [self.characterSprite playAnimation:@"run" loop:YES];
            break;
            
        case CBAnimationStateJump:
            animationKey = @"anim_jumpLoop";
            [self.characterSprite playAnimation:@"jump-loop" loop:YES];
//            [self.characterSprite queueAnimation:@"jump-loop" loop:YES afterDelay:0.5];
            break;
            
        case CBAnimationStateFall:
            animationKey = @"anim_fall";
            [self.characterSprite playAnimation:@"jump-loop" loop:YES];
            break;
            
        case CBAnimationStateClimb:
            animationKey = @"anim_climb";
            [self.characterSprite playAnimation:@"jump-loop" loop:YES];
            break;
            
        case CBAnimationStateAttack:
            animationKey = @"anim_attack";
            [self.characterSprite playAnimation:@"stand-attack" loop:NO];
            [self.characterSprite queueAnimation:@"stand" loop:YES afterDelay:0.6];
            break;
            
        case CBAnimationStateGetHit:
            animationKey = @"anim_hit";
            [self.characterSprite playAnimation:@"hit" loop:NO];
            [self.characterSprite queueAnimation:@"stand" loop:YES afterDelay:0.6];
            break;
            
        case CBAnimationStateDeath:
            animationKey = @"anim_death";
            [self.characterSprite playAnimation:@"die" loop:NO];
            break;
    }
    
    if (animationKey) {
//        [self fireAnimationForState:animationState usingTextures:animationFrames withKey:animationKey];
        self.activeAnimationKey = animationKey;
    }
}

#pragma mark -  Movement
- (void)move:(CBMoveDirection)direction withTimeInterval:(NSTimeInterval)timeInterval {
    [self move:direction bySpeed:kMovementSpeed withTimeInterval:timeInterval];
}

- (void)move:(CBMoveDirection)direction bySpeed:(CGFloat)speed withTimeInterval:(NSTimeInterval)timeInterval {
    CGVector force = [self calculateForceWithSpeed:(direction * speed) byAxis:kCBAxisTypeX withTimeInterval:timeInterval];
    [self.physicsBody applyForce:force];
//    NSLog(@"%f, %f", force.dx, force.dy);

}

- (CGVector)calculateForceWithSpeed:(CGFloat)speed byAxis:(CBAxisType)axis withTimeInterval:(NSTimeInterval)timeInterval {
    CGVector velocity = self.physicsBody.velocity;
    CGVector force = CGVectorZero;
    switch (axis) {
        case kCBAxisTypeX:
            force = ccv(self.physicsBody.mass * (speed - velocity.dx) / timeInterval, 0);
            break;
        
        case kCBAxisTypeY:
            force = ccv(0, self.physicsBody.mass * (speed - velocity.dy) / timeInterval);
            break;
            
        case kCBAxisTypeXY:
            force = ccv(self.physicsBody.mass * (speed - velocity.dx) / timeInterval
                        , self.physicsBody.mass * (speed - velocity.dy) / timeInterval);
            break;
    }

    return force;
}

- (void)moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval {
    CGPoint curPosition = self.position;
    CGFloat dx = position.x - curPosition.x;
    
    const float arrivalDistance = 10.0;
    const float slowingDistance = 20.0;
    CGFloat distX = fabsf(dx);
    if (distX <= arrivalDistance) {
        if (self.isGrounded) {
            self.physicsBody.velocity = CGVectorMake(0, self.physicsBody.velocity.dy);
        }
    }else{
        CGFloat rampedSpeed = kMovementSpeed * (distX / slowingDistance);
        CGFloat minSpeed = kMovementSpeed / 4.0;
        CGFloat clippedSpeed = CLAMP(rampedSpeed, minSpeed, kMovementSpeed);
        if (dx > 0) {
            [self move:kCBMoveDirectionRight bySpeed:clippedSpeed withTimeInterval:timeInterval];
        }
        else if (dx < 0){
            [self move:kCBMoveDirectionLeft bySpeed:clippedSpeed withTimeInterval:timeInterval];
        }
    }
}

- (void)moveInDirection:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval {
    
}

- (void)climb:(CBMoveDirection)direction withTimeInterval:(NSTimeInterval)timeInterval {
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, MAX(-100, self.physicsBody.velocity.dy)) ;
}

#pragma mark - Physics Test
- (void)testGrounded {
    __block BOOL temp = NO;
    CGPoint rayStart = [self convertPoint:CGPointZero toNode:self.kkScene];
	CGPoint rayEnd = CGPointMake(rayStart.x, rayStart.y - (_boundingBox.height / 2.0 + 5));
    
    CGFloat offsetX =  _boundingBox.width/2;
    rayStart.x = rayStart.x - offsetX * 2;
    rayEnd.x = rayEnd.x - offsetX * 2;
    
    // find body below player
	for (int i = 0; i < 3; i++) {
        rayStart.x = rayStart.x + offsetX;
        rayEnd.x = rayEnd.x + offsetX;
        
        [Debug drawLineStart:rayStart end:rayEnd];
        
        SKPhysicsWorld* physicsWorld = self.kkScene.physicsWorld;
        [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
            if (body.contactTestBitMask < 1){
                if (!self.isGrounded) {
                    [self onGrounded];
                }
                temp = YES;
                *stop = YES;
            }
		}];
    }
    _grounded = temp;
}

- (void)testTouchHeadTop {
    __block BOOL temp = NO;
    CGPoint rayStart = [self convertPoint:CGPointZero toNode:self.kkScene];
	CGPoint rayEnd = CGPointMake(rayStart.x, rayStart.y + (_boundingBox.height / 2.0 + 5));

    CGFloat offsetX =  _boundingBox.width/2;
    rayStart.x = rayStart.x - offsetX * 2;
    rayEnd.x = rayEnd.x - offsetX * 2;
    
    // find body below player
	for (int i = 0; i < 3; i++) {
        rayStart.x = rayStart.x + offsetX;
        rayEnd.x = rayEnd.x + offsetX;
        
        [Debug drawLineStart:rayStart end:rayEnd];
        
        SKPhysicsWorld* physicsWorld = self.kkScene.physicsWorld;
        [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
            if (body.contactTestBitMask < 1){
                if (!self.isTouchTop) {
                    [self onTouchHeadTop];
                }
                temp = YES;
                *stop = YES;
            }
		}];
    }
         
    _touchTop = temp;
}


- (void)testTouchSide {
    __block BOOL temp = NO;
    _touchingSide = kCBCharacterTouchSideNil;
    _touchSideNormal = CGVectorZero;
    CGPoint rayStart = [self convertPoint:CGPointZero toNode:self.kkScene];
	CGPoint rayEnd = CGPointMake(rayStart.x + (_boundingBox.width / 2.0 + 5), rayStart.y);
    
    CGFloat offsetY =  _boundingBox.height/2;
    rayStart.y = rayStart.y - offsetY * 2;
    rayEnd.y = rayEnd.y - offsetY * 2;
    
    // find body below player
	for (int i = 0; i < 3; i++) {
        //test right side
        rayStart.y = rayStart.y + offsetY;
        rayEnd.y = rayEnd.y + offsetY;
        [Debug drawLineStart:rayStart end:rayEnd];
        SKPhysicsWorld* physicsWorld = self.scene.physicsWorld;
        [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
            if (body.contactTestBitMask <= 1){
                if (!self.isTouchSide) {
                    [self onTouchSide:kCBCharacterTouchSideRight];
                }
                temp = YES;
                *stop = YES;
                _touchSideNormal = normal;
                _touchingSide = kCBCharacterTouchSideRight;
            }
        }];
        
        //test left side
        CGPoint rayEndLeft = CGPointMake(rayStart.x - (_boundingBox.width / 2.0 + 5), rayStart.y);
        [Debug drawLineStart:rayStart end:rayEndLeft];
        [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEndLeft usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
            if (body.contactTestBitMask <= 1){
                if (!self.isTouchSide) {
                    [self onTouchSide:kCBCharacterTouchSideLeft];
                }
                temp = YES;
                *stop = YES;
                _touchSideNormal = normal;
                _touchingSide = kCBCharacterTouchSideLeft;
            }
        }];

    }
    
    
    _touchSide = temp;
}

- (void)rayTesting {
    if (self.enableGroundTest) {
        [self testGrounded];
        [self testTouchHeadTop];
    }
    
    if (self.enableSideTest) {
        [self testTouchSide];
    }
}


#pragma mark - Shared Assets
+ (void)loadSharedAssets {
    // overridden by subclasses
}

- (NSArray *)idleAnimationFrames {
    return nil;
}

- (NSArray *)walkAnimationFrames {
    return nil;
}

- (NSArray *)runAnimationFrames {
    return nil;
}

- (NSArray *)jumpStartAnimationFrames {
    return nil;
}

- (NSArray *)jumpLoopAnimationFrames {
    return nil;
}

- (NSArray *)landAnimationFrames {
    return nil;
}

- (NSArray *)climbAnimationFrames {
    return nil;
}

- (NSArray *)attackAnimationFrames {
    return nil;
}

- (NSArray *)getHitAnimationFrames {
    return nil;
}

- (NSArray *)deathAnimationFrames {
    return nil;
}

- (SKEmitterNode *)damageEmitter {
    return nil;
}

- (SKAction *)damageAction {
    return nil;
}

@end
