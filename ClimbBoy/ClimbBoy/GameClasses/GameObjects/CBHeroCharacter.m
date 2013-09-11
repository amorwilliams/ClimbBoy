//
//  CBHeroCharacter.m
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "CBHeroCharacter.h"

@interface CBHeroCharacter ()
@property (nonatomic) CGPoint moveToPoint;
@property (nonatomic) CBMoveDirection heroMoveDirection;

@end

@implementation CBHeroCharacter

#pragma mark - Initialization
- (id)initAtPosition:(CGPoint)position {
    return [self initWithTexture:nil atPosition:position];
}

- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position {
    self = [super initWithTexture:texture atPosition:position];
    if (self) {
        self.enableGroundTest = YES;
        self.enableSideTest = YES;
        
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
    _jumpingTimer = 0.3;
    
    CGVector directioin = ccv(0, 1);
    if ([_fsm.previousState isEqual:[HeroMap Climbing]]) {
        directioin = ccvNormalize(ccv(1, -self.touchingSide));
    }
    CGVector force = ccvMult(directioin, self.physicsBody.mass * _jumpSpeedInitial / (1 / 60.0));
    [self.physicsBody applyImpulse:force];

}

- (void)updateJumping:(NSTimeInterval)delta {
    if (_jumpButton) {
        CGVector force = [self calculateForceWithSpeed:_jumpAbortVelocity byAxis:kCBAxisTypeY withTimeInterval:delta];
        [self.physicsBody applyForce:force];
        _jumpingTimer -= delta;
    }
}

- (void)updateFalling:(NSTimeInterval)delta {
    CGVector velocity = self.physicsBody.velocity;
    
    if (_fallSpeedAcceleration == 0.0 || _fallSpeedAcceleration >= _fallSpeedLimit){
        velocity.dy = -_fallSpeedLimit;
    }
    else{
        velocity.dy -= _fallSpeedAcceleration;
    }
    
    velocity.dy = MAX(self.physicsBody.velocity.dy, velocity.dy);
    self.physicsBody.velocity = velocity;
}

- (void)updateClimbing:(NSTimeInterval)delta {
    CGVector velocity = self.physicsBody.velocity;
    velocity.dy = clampf(self.physicsBody.velocity.dy, _climbUpSpeedLimit, -_climbDownSpeedLimit);
    self.physicsBody.velocity = velocity;
}


- (void)onGrounded {
    [self doStand];
}

- (void)onTouchHeadTop {
    if ([_fsm.state isEqual:[HeroMap Jumping]]) {
        [self doFall];
    }
}

- (void)onTouchSide:(CBCharacterTouchSide)side {

}


- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)delta{
    [super updateWithTimeSinceLastUpdate:delta];
    
    [_fsm update:delta];
    
    if ([_fsm.state isEqual:[HeroMap Jumping]]) {
        if (self.physicsBody.velocity.dy < 0 || _jumpingTimer <= 0) {
            [self endJump];
        }
    }
    
    if (self.isGrounded) {
        [self updateMovementOnGround:delta];
        
        if (fabs(self.physicsBody.velocity.dx) < 1) {
            [self doStand];
        }else {
            [self doRun];
        }
    }else {
        [self updateMovementInAir:delta];
        
        BOOL sameSide = ((_currentControlPadDirection.dx > 0 ) && (self.touchingSide == kCBCharacterTouchSideRight))
        || ((_currentControlPadDirection.dx < 0) && (self.touchingSide == kCBCharacterTouchSideLeft));
        if (!self.isGrounded && self.isTouchSide) {
            if (sameSide) {
                [self doClimb];
            }
        }
        
        if ([_fsm.state isEqual:[HeroMap Climbing]] && !self.isTouchSide) {
            [self doFall];
        }
        
        if (self.physicsBody.velocity.dy < 0 && ![_fsm.state isEqual:[HeroMap Climbing]]) {
            [self doFall];
        }
    }
}

- (void)updateMovementOnGround:(CFTimeInterval)delta {
    CBMoveDirection dirction = _currentControlPadDirection.dx > 0 ? kCBMoveDirectionRight : kCBMoveDirectionLeft;
    float speed = fabsf(_currentControlPadDirection.dx);
    [self move:dirction bySpeed:speed withTimeInterval:delta];
}

- (void)updateMovementInAir:(CFTimeInterval)delta {
    CGFloat speed = _currentControlPadDirection.dx  * 0.5;
    CGVector force = [self calculateForceWithSpeed:speed byAxis:kCBAxisTypeX withTimeInterval:delta];
    [self.physicsBody applyForce:force];
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
//    NSLog(@"eeeeeeeee");
	KKControlPadBehavior* controlPad = [note.userInfo objectForKey:@"behavior"];
	if (controlPad.direction == KKArcadeJoystickNone)
	{
        _currentControlPadDirection = CGVectorZero;
        
        if ([_fsm.state isEqual:[HeroMap Climbing]]) {
            [self doFall];
        }
	}
	else
	{
		CGFloat speed = _runSpeedAcceleration;
		if (speed == 0.0 || speed > _runSpeedLimit)
		{
			speed = _runSpeedLimit;
		}
		_currentControlPadDirection = ccvMult(vectorFromJoystickState(controlPad.direction), speed);
	}
}

-(void) jumpButtonPressed:(NSNotification*)note
{
    [self doJump];
    _jumpButton = [note.userInfo objectForKey:@"behavior"];
//    [[OALSimpleAudio sharedInstance] playEffect:@"jump.wav"];
}

-(void) jumpButtonReleased:(NSNotification *)note
{
    if ([_fsm.state isEqual:[HeroMap Jumping]]) {
        [self endJump];
    }
}

-(void) endJump
{
    if (self.isGrounded) {
        [self doStand];
    }else {
        [self doFall];
    }
    
    [_jumpButton endSelect];
	_jumpButton = nil;
}




@end
