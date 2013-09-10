//
//  CBCharacter.m
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "CBCharacter.h"
#import "CBBehaviors.h"
#import "CBMacros.h"

@interface CBCharacter ()
@property (nonatomic) CFTimeInterval lastUpdateTimeInterval;

@end

@implementation CBCharacter
@synthesize node;
#pragma mark - Initialization
- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position {
    if (self = [super init]) {
        [self sharedInitCharaterSprite:texture];
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

- (void)sharedInitCharaterSprite:(SKTexture *)texture {
    self.characterSprite = [SKSpriteNode spriteNodeWithTexture:texture];
    [self addChild:self.characterSprite];
}

- (void)reset {
    // Reset some base states (used when recycling character instances).
    self.health = 100.0f;
    self.touchSide = NO;
}

- (void)didMoveToParent {
    [self observeSceneEvents];
    [self.kkScene addPhysicsContactEventsObserver:self];
    CBSpriteFlipBehavior *flipBehavior = [CBSpriteFlipBehavior SpriteFlipWithTarget:self.characterSprite];
    [self addBehavior:flipBehavior withKey:@"Flip"];
}


#pragma mark - Overridden Methods
- (void)configurePhysicsBody {
    // Overridden by subclasses to create a physics body with relevant collision settings for this character.
}

#pragma mark - FSM Action Methods
- (void)doStand {
//    [self runAnimation:CBAnimationStateIdle];
}

- (void)doRun {
//    [self runAnimation:CBAnimationStateRun];
}

- (void)doJump {
//    [self runAnimation:CBAnimationStateJump];
}

- (void)doFall {
//    [self runAnimation:CBAnimationStateFall];
}

- (void)doClimb {
//    [self runAnimation:CBAnimationStateClimb];
}

- (void)doDie {
    self.health = 0.0f;
//    [self runAnimation:CBAnimationStateDeath];
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
    if (self.enableGroundTest) {
        [self testGrounded];
        [self testTouchHeadTop];
    }
    
    if (self.enableSideTest) {
        [self testTouchSide];
    }
}

- (void) didSimulatePhysics {
    
}

#pragma mark - Physics Delegate
- (SKNode *)node {
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody {
    if (self.enableGroundTest) {
        [self testGrounded];
        [self testTouchHeadTop];
    }
    
    if (self.enableSideTest) {
        [self testTouchSide];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody {
    if (self.enableGroundTest) {
        [self testGrounded];
        [self testTouchHeadTop];
    }
    
    if (self.enableSideTest) {
        [self testTouchSide];
    }
}

#pragma mark - Animator Delegate
- (void)animationHasCompleted:(CBAnimationState)animationState {
    // Called when a requested animation has completed (usually overriden).
}

- (void)runAnimation:(CBAnimationState)animationState {
    if (animationState != _animatorBehavior.requestedAnimation
        && _animatorBehavior) {
        _animatorBehavior.requestedAnimation = animationState;
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
    CGPoint rayStart = self.position;
	CGPoint rayEnd = CGPointMake(rayStart.x, rayStart.y - (_boundingBox.height / 2.0 + 2));

    // find body below player
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
    _grounded = temp;
}

- (void)testTouchHeadTop {
    __block BOOL temp = NO;
    CGPoint rayStart = self.position;
	CGPoint rayEnd = CGPointMake(rayStart.x, rayStart.y + (_boundingBox.height / 2.0 + 2));

    // find body below player
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
    _touchTop = temp;
}


- (void)testTouchSide {
    __block BOOL temp = NO;
    _touchingSide = kCBCharacterTouchSideNil;
    _touchSideNormal = CGVectorZero;
    CGPoint rayStart = self.position;
	CGPoint rayEnd = CGPointMake(self.position.x + (_boundingBox.width / 2.0 + 2), self.position.y);
    
    //test right side
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
    
    rayEnd = CGPointMake(self.position.x - (_boundingBox.width / 2.0 + 2), self.position.y);
    
    //test left side
    [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
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
    
    _touchSide = temp;
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
