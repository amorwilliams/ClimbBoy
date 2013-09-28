//
//  CBHeroCharacter.m
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "HeroCharacter.h"

@interface HeroCharacter ()
@property (nonatomic) CGPoint moveToPoint;
@property (nonatomic) CBMoveDirection heroMoveDirection;

@end

@implementation HeroCharacter

#pragma mark - Initialization
- (id)initWithSpineSprite:(CBSpineSprite *)spineSprite atPosition:(CGPoint)position
{
    self = [super initWithSpineSprite:spineSprite atPosition:position];
    if (self) {
        
        _fsm = [[CBHeroCharacterContext alloc]initWithOwner:self];
        [_fsm setDebugFlag:NO];
        [_fsm enterStartState];
    }
    return self;
}

- (void)didMoveToParent {
    [super didMoveToParent];
//    [self observeInputEvents];
    self.moveToPoint = self.position;
    self.heroMoveDirection = kCBMoveDirectionRight;
}

#pragma mark - Overridden Methods
/*
- (void)configurePhysicsBody {
//    self.physicsBody = [self physicsBodyWithCircleOfRadius:self.collisionRadius];
    self.physicsBody = [self physicsBodyWithRectangleOfSize:CGSizeMake(40, 60)];
//    self.physicsBody = [self physicsBodyWithCapsule:self.collisionCapsule];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.restitution = 0;
    self.physicsBody.mass = 0.05;
//    self.physicsBody.usesPreciseCollisionDetection = YES;
//    self.physicsBody.friction = 1;

    // Our object type for collisions.
    self.physicsBody.categoryBitMask = CBColliderTypeHero;
    
    // Collides with these objects.
    self.physicsBody.collisionBitMask = CBColliderTypeGoblinOrBoss | CBColliderTypeHero | CBColliderTypeWall | CBColliderTypeCave;
    
    // We want notifications for colliding with these objects.
    self.physicsBody.contactTestBitMask = CBColliderTypeGoblinOrBoss | CBColliderTypeWall;
}
*/


#pragma mark - FSM Action Methods
- (void)doStand {
    [_fsm toStand];
}

- (void)doRun {
    [_fsm toRun];
}

- (void)doJump{
    [_fsm toJump];
}

- (void)doFall {
    [_fsm toFall];
}

- (void)doClimb {
    [_fsm toClimb];
}

- (void)doDie {
    [_fsm toDie];
    
    /*
    self.health = 0.0f;
    self.dying = YES;
    _animatorBehavior.requestedAnimation = CBAnimationStateDeath;
     */
}

- (void)updateRunning:(NSTimeInterval)delta {
    
}

- (void)startJumping {
//    CGVector directioin = ccv(0, 1);
//    if ([_fsm.previousState isEqual:[HeroMap Climbing]]) {
//        directioin = ccvNormalize(ccv(1, -self.touchingSideDirection));
//    }
    CGVector vel = self.physicsBody.velocity;
    _jumpSpeed = self.jumpSpeedInitial;
    vel.dy = _jumpSpeed;
    self.physicsBody.velocity = vel;
}

- (void)updateJumping:(NSTimeInterval)delta {
    CGVector vel = self.physicsBody.velocity;
    _jumpSpeed = IncrementTowards(_jumpSpeed, -self.fallSpeedLimit, self.jumpSpeedDeceleration, delta);
    vel.dy = _jumpSpeed;
    self.physicsBody.velocity = vel;
}

- (void)updateFalling:(NSTimeInterval)delta {
    CGVector velocity = self.physicsBody.velocity;
    
//    if (self.fallSpeedAcceleration == 0.0 || self.fallSpeedAcceleration >= self.fallSpeedLimit){
//        velocity.dy = -self.fallSpeedLimit;
//    }
//    else{
//        velocity.dy -= self.fallSpeedAcceleration;
//    }
    
    velocity.dy = IncrementTowards(velocity.dy, -self.fallSpeedLimit, self.fallSpeedAcceleration, delta);
    
    velocity.dy = MAX(self.physicsBody.velocity.dy, velocity.dy);
    self.physicsBody.velocity = velocity;
}

- (void)updateClimbing:(NSTimeInterval)delta {
    CGVector velocity = self.physicsBody.velocity;
    velocity.dy = clampf(self.physicsBody.velocity.dy, _climbUpSpeedLimit, -_climbDownSpeedLimit);
    self.physicsBody.velocity = velocity;
}


#pragma mark - Physics

- (void)onGrounded
{
    NSLog(@"onGrounded");
    [self doStand];
}

- (void)onTouchTop
{
    NSLog(@"onTouchTop");
    if ([_fsm.state isEqual:[HeroMap Jumping]]) {
        [self endJump];
    }
}

- (void)onTouchSide
{
    NSLog(@"onTouchSide");
}


- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)delta{
    [super updateWithTimeSinceLastUpdate:delta];
    
    [_fsm update:delta];
    
    CBMoveDirection dirction = _currentControlPadDirection.dx > 0 ? kCBMoveDirectionRight : kCBMoveDirectionLeft;
    CGFloat speed = 0;
    
    if (self.isGrounded)
    {
        speed = fabsf(_currentControlPadDirection.dx) * self.runSpeedLimit;
        
        if (fabs(self.physicsBody.velocity.dx) < 1) {
            [self doStand];
        }else {
            [self doRun];
        }
    }
    else
    {
        speed = fabsf(_currentControlPadDirection.dx) * self.runSpeedLimit * 0.75;
        
        if (self.isTouchSide){
            [self doClimb];
        }
        
        if ([_fsm.state isEqual:[HeroMap Climbing]]) {
            if (!self.isTouchSide) {
                [self doFall];
            }
        }else{
            if (self.physicsBody.velocity.dy < 0 && ![_fsm.state isEqual:[HeroMap Falling]]) {
                [self doFall];
            }
            if ([_fsm.state isEqual:[HeroMap Jumping]]) {
                if (_jumpButton && !_jumpButton.selected){
                    [self endJump];
                }
            }
        }
    }
    
    [self move:dirction bySpeed:speed acceleration:self.runSpeedAcceleration deltaTime:delta];
}

- (void)updateMovementOnGround:(CFTimeInterval)delta {
    CBMoveDirection dirction = _currentControlPadDirection.dx > 0 ? kCBMoveDirectionRight : kCBMoveDirectionLeft;
    CGFloat speed = fabsf(_currentControlPadDirection.dx) * self.runSpeedLimit;
    
    [self move:dirction bySpeed:speed acceleration:self.runSpeedAcceleration deltaTime:delta];
}

- (void)updateMovementInAir:(CFTimeInterval)delta {
    CBMoveDirection dirction = _currentControlPadDirection.dx > 0 ? kCBMoveDirectionRight : kCBMoveDirectionLeft;
    CGFloat speed = fabsf(_currentControlPadDirection.dx) * self.runSpeedLimit * 0.75;
    [self move:dirction bySpeed:speed acceleration:self.runSpeedAcceleration deltaTime:delta];
}

#pragma mark - Physics Delegate
- (void)didBeginContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody {
    [super didBeginContact:contact otherBody:otherBody];
    
}

- (void)didEndContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody {
    [super didEndContact:contact otherBody:otherBody];
    
}

#pragma mark - Input Notifications
-(void) controlPadDidChangeDirection:(NSNotification*)note
{
	KKControlPadBehavior* controlPad = [note.userInfo objectForKey:@"behavior"];
	if (controlPad.direction == KKArcadeJoystickNone)
	{
        _currentControlPadDirection = CGVectorZero;
	}
	else
	{
		_currentControlPadDirection = vectorFromJoystickState(controlPad.direction);
	}
}

- (void)jumpButtonExecute:(id)sender
{
    CBButton *button = (CBButton *)sender;
    if (button.selected)
    {
        [self doJump];
        _jumpButton = button;
    }
}

-(void) endJump
{
//    if (self.isGrounded) {
//        [self doStand];
//    }else {
        [self doFall];
//    }
    
    if (_jumpButton) {
        _jumpButton.selected = NO;
        _jumpButton = nil;
    }
}




@end
