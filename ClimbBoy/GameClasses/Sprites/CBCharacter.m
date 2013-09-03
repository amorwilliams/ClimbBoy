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
    self.dying = NO;
    self.jumping = NO;
    self.climbing = NO;
    self.wallJumping = NO;
    self.touchSide = NO;
    
    self.startJump = NO;
    self.startLand = NO;
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

- (void)animationDidComplete:(CBAnimationState)animation {
    // Called when a requested animation has completed (usually overriden).

}

- (void)performJump {
    self.jumping = YES;
    self.startJump = YES;
    self.startLand = NO;
    _animatorBehavior.requestedAnimation = CBAnimationStateJump;
}

- (void)performDeath {
    self.health = 0.0f;
    self.dying = YES;
    _animatorBehavior.requestedAnimation = CBAnimationStateDeath;
}

- (void)onArrived{
    //Called when moveTowards has arrived point (usually overidden)
}

- (void)onGrounded{
    if (self.isJumping || self.isClimbing) {
        self.jumping = NO;
        self.climbing = NO;
        self.wallJumping = NO;
        self.startLand = YES;
        _animatorBehavior.requestedAnimation = CBAnimationStateIdle;
    }
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

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    
}

-(void) didEvaluateActions {
	[self testIsGrounded];
    [self testTouchSide];
    
//    NSLog(@"climbing : %@", self.isClimbing ? @"YES" : @"NO");
//    NSLog(@"%f, %f", self.physicsBody.velocity.dx, self.physicsBody.velocity.dy);
}

- (void) didSimulatePhysics {
    
}


#pragma mark - Physics Delegate
- (SKNode *)node {
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody {
    [self testTouchSide];
    if (self.isTouchSide && !self.isGrounded) {
        self.climbing = YES;
    }
    
    NSLog(@"touchSide : %@", self.isTouchSide ? @"YES" : @"NO");
}

- (void)didEndContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody {
    
}

#pragma mark - Animator Delegate
- (void)animationHasCompleted:(CBAnimationState)animationState {
    if (self.dying) {
        _animatorBehavior.animated = NO;
    }

    if (self.startJump) {
        self.startJump = NO;
    }
    
    if (self.startLand) {
        self.startLand = NO;
    }
    
    [self animationDidComplete:animationState];
}

#pragma mark -  Movement
- (void)move:(CBMoveDirection)direction withTimeInterval:(NSTimeInterval)timeInterval {
    [self move:direction bySpeed:kMovementSpeed withTimeInterval:timeInterval];
}

- (void)move:(CBMoveDirection)direction bySpeed:(CGFloat)speed withTimeInterval:(NSTimeInterval)timeInterval {
    if (!self.isGrounded) {
        return;
    }
    
    if (self.startLand) {
        self.physicsBody.velocity = ccvMult(self.physicsBody.velocity, 1);
        return;
    }
    
    CGVector force = CGVectorZero;
    float currentSpeedX = self.physicsBody.velocity.dx;
    switch (direction) {
        case CBMoveDirectionRight:
            force = CGVectorMake(self.physicsBody.mass * (speed - currentSpeedX) / timeInterval, 0);
            break;
            
        case CBMoveDirectionLeft:
            force = CGVectorMake(self.physicsBody.mass * (-speed - currentSpeedX) / timeInterval, 0);
            break;
    }
    
    [self.physicsBody applyForce:force];
//    NSLog(@"%f, %f", force.dx, force.dy);

}

- (void)moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval {
    if (!self.isGrounded) {
        return;
    }
    
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
            [self move:CBMoveDirectionRight bySpeed:clippedSpeed withTimeInterval:timeInterval];
        }
        else if (dx < 0){
            [self move:CBMoveDirectionLeft bySpeed:clippedSpeed withTimeInterval:timeInterval];
        }
    }
}

- (void)moveInDirection:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval {
    
}

- (void)climb:(CBMoveDirection)direction withTimeInterval:(NSTimeInterval)timeInterval {
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, MAX(-100, self.physicsBody.velocity.dy)) ;
}

#pragma mark - Physics Test
- (void)testIsGrounded {
    __block BOOL temp = NO;
    CGPoint rayStart = [self.kkScene convertPoint:self.position toNode:self.kkScene];
	CGPoint rayEnd = CGPointMake(rayStart.x, rayStart.y - (self.collisionCapsule.height/2 + 2));

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
    self.grounded = temp;
}

- (void)testTouchSide {
    __block BOOL temp = NO;
    self.touchSideNormal = CGVectorZero;
    CGPoint rayStart = self.position;
	CGPoint rayEnd = CGPointMake(self.position.x + self.collisionCapsule.radius + 15, self.position.y);
    
    // find body below player
	SKPhysicsWorld* physicsWorld = self.scene.physicsWorld;
	[physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
		if (body.contactTestBitMask <= 1){
//            if (!self.isTouchSide) {
//                [self onBeginClimb];
//            }
            temp = YES;
            *stop = YES;
            self.touchSideNormal = normal;
		}
	}];
    
    rayEnd = CGPointMake(self.position.x - self.collisionCapsule.radius - 15, self.position.y);
    [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
		if (body.contactTestBitMask <= 1){
            //            if (!self.isTouchSide) {
            //                [self onBeginClimb];
            //            }
            temp = YES;
            *stop = YES;
            self.touchSideNormal = normal;
		}
	}];
    
    self.touchSide = temp;
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

#pragma mark - Getter and Setter
- (void)setJumping:(BOOL)b {
    _jumping = b;
    if (!b) {
        self.startJump = NO;
        self.wallJumping = NO;
    }
}

- (void)setClimbing:(BOOL)b {
    _climbing = b;
    if (b) {
        self.jumping = NO;
    }
}

@end
