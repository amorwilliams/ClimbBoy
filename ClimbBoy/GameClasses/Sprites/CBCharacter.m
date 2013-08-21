//
//  CBCharacter.m
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "CBCharacter.h"
#import "SKSpriteNode+CBExtension.h"

@implementation CBCharacter

#pragma mark - Initialization
- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position {
    self = [super initWithTexture:texture];
    
    if (self) {
        [self sharedInitAtPosition:position];
    }
    
    return self;
}

- (void)sharedInitAtPosition:(CGPoint)position {
    
    self.position = position;
    
    _health = 100.0f;
    _animated = YES;
    _animationSpeed = 1.0f/28.0f;
    
    [self configurePhysicsBody];
}

- (void)reset {
    // Reset some base states (used when recycling character instances).
    self.health = 100.0f;
    self.dying = NO;
    self.attacking = NO;
    self.animated = YES;
    self.requestedAnimation = CBAnimationStateIdle;
//    self.shadowBlob.alpha = 1.0f;
}

#pragma mark - Overridden Methods
- (void)configurePhysicsBody {
    // Overridden by subclasses to create a physics body with relevant collision settings for this character.
}

- (void)animationDidComplete:(CBAnimationState)animation {
    // Called when a requested animation has completed (usually overriden).
}

- (void)performAttackAction {
    if (self.attacking) {
        return;
    }
    
    self.attacking = YES;
    self.requestedAnimation = CBAnimationStateAttack;
}

- (void)collidedWith:(SKPhysicsBody *)other {
    // Handle a collision with another character, projectile, wall, etc (usually overidden).
}

- (void)performDeath {
    self.health = 0.0f;
    self.dying = YES;
    self.requestedAnimation = CBAnimationStateDeath;
}

- (void)onArrived{
    //Called when moveTowards has arrived point (usually overidden)
}

#pragma mark - Loop Update
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    // Shadow always follows our main sprite.
//    self.shadowBlob.position = self.position;
    
    if (self.isAnimated) {
        [self resolveRequestedAnimation];
        
        float currentSpeedX = self.physicsBody.velocity.dx;
        if (currentSpeedX > 0.1) {
            self.flipX = NO;
            self.requestedAnimation = CBAnimationStateRun;
        }else if (currentSpeedX < -0.1){
            self.flipX = YES;
            self.requestedAnimation = CBAnimationStateRun;
        }else{
            self.requestedAnimation = CBAnimationStateIdle;
        }
    }
}

#pragma mark - Animation
- (void)resolveRequestedAnimation {
    // Determine the animation we want to play.
    NSString *animationKey = nil;
    NSArray *animationFrames = nil;
    CBAnimationState animationState = self.requestedAnimation;
    
    switch (animationState) {
            
        default:
        case CBAnimationStateIdle:
            animationKey = @"anim_idle";
            animationFrames = [self idleAnimationFrames];
            break;
            
        case CBAnimationStateWalk:
            animationKey = @"anim_walk";
            animationFrames = [self walkAnimationFrames];
            break;
            
        case CBAnimationStateRun:
            animationKey = @"anim_run";
            animationFrames = [self runAnimationFrames];
            break;
            
        case CBAnimationStateAttack:
            animationKey = @"anim_attack";
            animationFrames = [self attackAnimationFrames];
            break;
            
        case CBAnimationStateGetHit:
            animationKey = @"anim_gethit";
            animationFrames = [self getHitAnimationFrames];
            break;
            
        case CBAnimationStateDeath:
            animationKey = @"anim_death";
            animationFrames = [self deathAnimationFrames];
            break;
    }
    
    if (animationKey) {
        [self fireAnimationForState:animationState usingTextures:animationFrames withKey:animationKey];
    }
    
//    self.requestedAnimation = self.dying ? CBAnimationStateDeath : CBAnimationStateIdle;
}

- (void)fireAnimationForState:(CBAnimationState)animationState usingTextures:(NSArray *)frames withKey:(NSString *)key {
    SKAction *animAction = [self actionForKey:key];
    if (animAction || [frames count] < 1) {
        return; // we already have a running animation or there aren't any frames to animate
    }
    
    [self removeActionForKey:self.activeAnimationKey];
    self.activeAnimationKey = key;
    [self runAction:[SKAction sequence:@[
                                         [SKAction animateWithTextures:frames timePerFrame:self.animationSpeed resize:YES restore:NO],
                                         [SKAction runBlock:^{
        [self animationHasCompleted:animationState];
    }]]] withKey:key];
}

- (void)animationHasCompleted:(CBAnimationState)animationState {
    if (self.dying) {
        self.animated = NO;
//        [self.shadowBlob runAction:[SKAction fadeOutWithDuration:1.5f]];
    }
    
    [self animationDidComplete:animationState];
    
    if (self.attacking) {
        self.attacking = NO;
    }
    
    self.activeAnimationKey = nil;
}

#pragma mark - Orientation and Movement
- (void)move:(CBMoveDirection)direction withTimeInterval:(NSTimeInterval)timeInterval {
    [self move:direction bySpeed:kMovementSpeed withTimeInterval:timeInterval];
}

- (void)move:(CBMoveDirection)direction bySpeed:(CGFloat)speed withTimeInterval:(NSTimeInterval)timeInterval{
    float force = 0;
    
    float currentSpeedX = self.physicsBody.velocity.dx;
    
    switch (direction) {
        case CBMoveDirectionRight:
            force = self.physicsBody.mass * (speed - currentSpeedX) / timeInterval;
            break;
            
        case CBMoveDirectionLeft:
            force = self.physicsBody.mass * (-speed - currentSpeedX) / timeInterval;
            break;
    }
    //    NSLog(@"%f", currentSpeedX);
    
    [self.physicsBody applyForce:CGVectorMake(force, 0)];
}

#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))
-(void)moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval{
    CGPoint curPosition = self.position;
    CGFloat dx = position.x - curPosition.x;
    
    const float arrivalDistance = 10.0;
    const float slowingDistance = 20.0;
    CGFloat distX = fabsf(dx);
    if (distX <= arrivalDistance) {
        self.physicsBody.velocity = CGVectorMake(0, self.physicsBody.velocity.dy);
    }else
    {
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
