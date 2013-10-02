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

@implementation BaseCharacter
//@synthesize node;
#pragma mark - Initialization
- (id)initWithSpineSprite:(CBSpineSprite *)spineSprite
{
    if (self = [super init]) {
        self.characterSprite = spineSprite;

        _health = 100.0f;
        _attackColdDownTime = 1.0;
        
        [self configurePhysicsBody];//        _enableGroundTest = YES;
        [self reset];
    }
    return self;
}

- (void)reset {
    _attackColdDown = YES;
    self.health = 100.0f;
}

- (void)didMoveToParent {
    [self observeSceneEvents];
    [self.kkScene addPhysicsContactEventsObserver:self];
    
    FlipBySpeedBehavior *flipBehavior = [FlipBySpeedBehavior behavior];
    flipBehavior.targetSpriteNode = self.characterSprite;
    [self addBehavior:flipBehavior withKey:@"flip"];
    
    [self addChild:self.characterSprite];
    
    [self runAnimation:CBAnimationStateIdle];
}

- (void)willMoveFromParent
{
    [super willMoveFromParent];
    [self disregardSceneEvents];
    [self.kkScene removePhysicsContactEventsObserver:self];
}

#pragma mark - Properties
/*
- (BOOL)isGrounded
{
    CharacterPhysicsBehavior *physics = (CharacterPhysicsBehavior *)[self behaviorKindOfClass:[CharacterPhysicsBehavior class]];
    if (physics) {
        return physics.isGrounded;
    }
    return NO;
}

- (BOOL)isTouchTop
{
    CharacterPhysicsBehavior *physics = (CharacterPhysicsBehavior *)[self behaviorKindOfClass:[CharacterPhysicsBehavior class]];
    if (physics) {
        return physics.isTouchTop;
    }
    return NO;
}

- (BOOL)isTouchSide
{
    CharacterPhysicsBehavior *physics = (CharacterPhysicsBehavior *)[self behaviorKindOfClass:[CharacterPhysicsBehavior class]];
    if (physics) {
        return physics.isTouchSide;
    }
    return NO;
}

- (int)touchingSideDirection
{
    CharacterPhysicsBehavior *physics = (CharacterPhysicsBehavior *)[self behaviorKindOfClass:[CharacterPhysicsBehavior class]];
    if (physics) {
        return physics.touchSideDirection;
    }
    return 0;
}
 */


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

- (void)doAttack {
    [self runAnimation:CBAnimationStateAttack];
}


#pragma mark - Character Events
- (void)onArrived{
    //Called when moveTowards has arrived point (usually overidden)
}

- (void)onGrounded
{
    //Called when character is landing (usually overidden)
}

- (void)onTouchTop
{
    //Called when character is touch top of head (usually overidden)
}

- (void)onTouchSide
{
    //Called when chararcter is touch (usually overidden)
}

#pragma mark - Loop Update
- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - _lastUpdateTimeInterval;
    _lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1/60.0;
        _lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithDeltaTime:timeSinceLast];
}

- (void)updateWithDeltaTime:(CFTimeInterval)delta {
    
}

-(void) didEvaluateActions {
    if (_platformNode) {
        self.position = ccp(_platformNode.position.x + _platformOffsetX, self.position.y) ;
    }
}

- (void) didSimulatePhysics {
    
}

#pragma mark - Physics Delegate
//- (SKNode *)node {
//    return self;
//}

- (void)didBeginContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody {
    [super didBeginContact:contact otherBody:otherBody];
}

- (void)didEndContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody {
    [super didEndContact:contact otherBody:otherBody];
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
            [self.characterSprite setAnimationForTrack:0 name:@"stand" loop:YES];
            break;
            
        case CBAnimationStateWalk:
            animationKey = @"anim_walk";
            [self.characterSprite setAnimationForTrack:0 name:@"walk" loop:YES];
            break;
            
        case CBAnimationStateRun:
            animationKey = @"anim_run";
            [self.characterSprite setAnimationForTrack:0 name:@"run" loop:YES];
            break;
            
        case CBAnimationStateJump:
            animationKey = @"anim_jumpLoop";
            [self.characterSprite setAnimationForTrack:0 name:@"jump-loop" loop:YES];
//            [self.characterSprite queueAnimation:@"jump-loop" loop:YES afterDelay:0.5];
            break;
            
        case CBAnimationStateFall:
            animationKey = @"anim_fall";
            [self.characterSprite setAnimationForTrack:0 name:@"jump-loop" loop:YES];
            break;
            
        case CBAnimationStateClimb:
            animationKey = @"anim_climb";
            [self.characterSprite setAnimationForTrack:0 name:@"jump-loop" loop:YES];
            break;
            
        case CBAnimationStateAttack:
        {
            animationKey = @"anim_attack";
            [self.characterSprite setAnimationForTrack:0 name:@"stand-attack" loop:NO];
//            [self.characterSprite queueAnimation:@"stand" loop:YES afterDelay:0.6];
//            [self runAction:[SKAction waitForDuration:0.6] completion:^{
//                self.attacking = NO;
//            }];
            break;
        }
            
        case CBAnimationStateGetHit:
            animationKey = @"anim_hit";
            [self.characterSprite setAnimationForTrack:0 name:@"hit" loop:NO];
            [self.characterSprite addAnimationForTrack:0 name:@"stand" loop:YES afterDelay:0.6];
            break;
            
        case CBAnimationStateDeath:
            animationKey = @"anim_death";
            [self.characterSprite setAnimationForTrack:0 name:@"die" loop:NO];
            break;
    }
    
    if (animationKey) {
//        [self fireAnimationForState:animationState usingTextures:animationFrames withKey:animationKey];
        self.activeAnimationKey = animationKey;
    }
}

#pragma mark -  Movement
- (void)move:(CBMoveDirection)direction bySpeed:(CGFloat)speed deltaTime:(CFTimeInterval)deltaTime
{
    [self move:direction bySpeed:speed acceleration:self.runSpeedAcceleration deltaTime:deltaTime];
}


- (void)move:(CBMoveDirection)direction bySpeed:(CGFloat)speed acceleration:(CGFloat)acceleration deltaTime:(CFTimeInterval)deltaTime
{
    CGVector vel = self.physicsBody.velocity;
    _targetSpeed = direction * speed;
    vel.dx = IncrementTowards(vel.dx, _targetSpeed, acceleration, deltaTime);
    
    self.physicsBody.velocity = vel;
    [self collisionTest:CGVectorMake(_targetSpeed, vel.dy)];
}

- (void)jump:(CFTimeInterval)deltaTime
{
    [self jumpWithDeceleration:self.jumpSpeedDeceleration deltaTime:deltaTime];
}

- (void)jumpWithDeceleration:(CGFloat)deceleration deltaTime:(CFTimeInterval)deltaTime
{
    CGVector vel = self.physicsBody.velocity;
    vel.dy = IncrementTowards(vel.dy, 0, deceleration, deltaTime);
    self.physicsBody.velocity = vel;
}

/*
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
*/

/*
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
 */

- (void)moveInDirection:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval {

}

- (void)climb:(CBMoveDirection)direction withTimeInterval:(NSTimeInterval)timeInterval {
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, MAX(-100, self.physicsBody.velocity.dy)) ;
}


static const int collisionDivisionsX = 3;
static const int collisionDivisionsY = 3;
static const float skin = 5;

- (void)collisionTest:(CGVector)move
{
    float deltaX = move.dx;
//    float deltaY = move.dy;
    
    _platformNode = nil;
    SKPhysicsWorld* physicsWorld = self.kkScene.physicsWorld;
    const CGSize size = self.boundingBox;
    const CGPoint p = [self convertPoint:CGPointZero toNode:self.kkScene];

    //---------------------------- find body below player -------------------------------------
    __block BOOL rayHitBottom = NO;
	for (int i = 0; i < collisionDivisionsX; i++) {
        CGPoint rayStart = CGPointMake((p.x - size.width/2) + size.width/(collisionDivisionsX-1) * i , p.y);
        CGPoint rayEnd = CGPointMake(rayStart.x, rayStart.y -(size.height/2 + skin));
        
        [Debug drawLineStart:rayStart end:rayEnd];
        
        [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
            if (body.collisionBitMask & kContactCategoryPlayer){
                rayHitBottom = YES;
                *stop = YES;
                
                if (body.contactTestBitMask & kContactCategoryPlayer) {
                    _platformNode = body.node;
                    _platformOffsetX = self.position.x - body.node.position.x;
                }
            }
		}];
    }
    if (rayHitBottom && !self.isGrounded) {
        [self onGrounded];
    }
    _grounded = rayHitBottom;
    
    
    //---------------------------- find body up player -------------------------------------
    __block BOOL rayHitTop = NO;
    for (int i = 0; i < collisionDivisionsX; i++) {
        CGPoint rayStart = CGPointMake((p.x - size.width/2) + size.width/(collisionDivisionsX-1) * i , p.y);
        CGPoint rayEnd = CGPointMake(rayStart.x, rayStart.y + size.height/2 + skin);
        
        [Debug drawLineStart:rayStart end:rayEnd];
        
        [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
            if (body.collisionBitMask & kContactCategoryPlayer){
                rayHitTop = YES;
                *stop = YES;
            }
		}];
    }
    
    if (rayHitTop && !self.isTouchTop) {
        [self onTouchTop];
    }
    _touchTop = rayHitTop;
    
    
    //---------------------------- find body left or right player -------------------------------------
    __block BOOL rayHitSide = NO;
    if (deltaX != 0) {
        int dir = SIGN(deltaX);
        for (int i = 0; i < collisionDivisionsY; i++)
        {
            CGPoint rayStart = CGPointMake(p.x, (p.y - size.height/2) + size.height/(collisionDivisionsY-1) * i);
            CGPoint rayEnd = CGPointMake(rayStart.x + (size.width/2 + skin) * dir, rayStart.y);
            
            [Debug drawLineStart:rayStart end:rayEnd];
            
            [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
                if (body.collisionBitMask & kContactCategoryPlayer){
                    rayHitSide = YES;
                    *stop = YES;
                }
            }];
        }
    }
    
    if (rayHitSide && !self.isTouchSide) {
        [self onTouchSide];
    }
    _touchSide = rayHitSide;
}

#pragma mark - Shared Assets
+ (void)loadSharedAssets {
    // overridden by subclasses
}

- (SKEmitterNode *)damageEmitter {
    return nil;
}

- (SKAction *)damageAction {
    return nil;
}

@end
