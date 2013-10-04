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
- (id)initWithSpineSprite:(CBSpineSprite *)spineSprite
{
    self = [super initWithSpineSprite:spineSprite];
    if (self) {
        
//        _fsm = [[CBHeroCharacterContext alloc]initWithOwner:self];
//        [_fsm setDebugFlag:NO];
//        [_fsm enterStartState];
        _placeItemBehavior = [PlaceItemBehavior behavior];
        [self addBehavior:_placeItemBehavior];
        
        _placeItemContainerBehavior = [PlaceItemContainerBehavior behavior];
        [self addBehavior:_placeItemContainerBehavior];
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
- (void)doStand
{
    self.attacking = NO;
    self.jumping = NO;
    self.falling = NO;
    self.climbing = NO;
    
    [super doStand];
}

- (void)doRun
{
    self.attacking = NO;
    self.jumping = NO;
    self.falling = NO;
    self.climbing = NO;
    
    [super doRun];
}

- (void)doJump
{
    self.falling = NO;
    self.jumping = YES;
    
    [super doJump];

    CGVector velocity = self.physicsBody.velocity;
    _jumpSpeed = self.jumpSpeedInitial;
    
    if (self.isClimbing) {
        velocity.dx = -(_currentControlPadDirection.dx * _jumpSpeed * 0.7);
    }
    
    velocity.dy = _jumpSpeed;
    self.physicsBody.velocity = velocity;
    
    self.climbing = NO;
}

- (void)doFall
{
    self.jumping = NO;
    self.climbing = NO;
    self.falling = YES;
    
    [super doFall];
}

- (void)doClimb
{
    self.jumping = NO;
    self.falling = NO;
    self.climbing = YES;
    
    [super doClimb];
}

- (void)doDie
{
    [super doDie];
    
    /*
    self.health = 0.0f;
    self.dying = YES;
    _animatorBehavior.requestedAnimation = CBAnimationStateDeath;
     */
}

- (void)doAttack
{
    self.attacking = YES;
    self.climbing = NO;
//    self.jumping = NO;
//    self.falling = NO;
    
    [super doAttack];
}

#pragma mark - Physics

- (void)onGrounded
{
    NSLog(@"onGrounded");
//    [self doStand];
}

- (void)onTouchTop
{
    NSLog(@"onTouchTop");
    if (self.isJumping) {
        [self endJump];
    }
}

- (void)onTouchSide
{
    NSLog(@"onTouchSide");
}


- (void)updateWithDeltaTime:(CFTimeInterval)delta {
    [super updateWithDeltaTime:delta];
    
    CBMoveDirection dirction = _currentControlPadDirection.dx > 0 ? kCBMoveDirectionRight : kCBMoveDirectionLeft;
    CGFloat speed = fabsf(_currentControlPadDirection.dx) * self.runSpeedLimit;
    CGVector velocity = self.physicsBody.velocity;
    
//    self.characterSprite.animationTimeScale = 1;
    
    if (self.isAttacking)
    {
        speed = fabsf(_currentControlPadDirection.dx) * self.runSpeedLimit * 0.5;
        //        velocity.dy = 0;
    }
    else if (self.isGrounded)
    {
        if (!self.isJumping)
        {
            if (fabs(self.physicsBody.velocity.dx) < 1)
            {
                [self doStand];
            }else
            {
//                self.characterSprite.animationTimeScale = fabs(velocity.dx) / self.runSpeedLimit;
                [self doRun];
            }
        }
    }
    else
    {
        if (self.isClimbing)
        {
            if (!self.isTouchSide)
            {
                [self doFall];
            }
            
            velocity.dy = clampf(self.physicsBody.velocity.dy, _climbUpSpeedLimit, -_climbDownSpeedLimit);
        }
        else
        {
            if (self.isTouchSide)
            {
                if (!self.isAttacking)
                {
                    [self doClimb];
                }
            }
            else if (self.physicsBody.velocity.dy < 0 && !self.isFalling)
            {
                [self doFall];
            }
            
            if (self.isJumping)
            {
                if (_jumpButton && !_jumpButton.selected)
                {
                    [self endJump];
                }
                
                _jumpSpeed = IncrementTowards(_jumpSpeed, -self.fallSpeedLimit, self.jumpSpeedDeceleration, delta);
                velocity.dy = _jumpSpeed;
                self.physicsBody.velocity = velocity;
            }
            else if (self.isFalling)
            {
                velocity.dy = IncrementTowards(velocity.dy, -self.fallSpeedLimit, self.fallSpeedAcceleration, delta);
                velocity.dy = MAX(self.physicsBody.velocity.dy, velocity.dy);
            }
        }
        
        speed *= 0.75;
    }
    
    self.physicsBody.velocity = velocity;
    [self move:dirction bySpeed:speed acceleration:self.runSpeedAcceleration deltaTime:delta];
}

- (void)updateMovementOnGround:(CFTimeInterval)delta
{
    CBMoveDirection dirction = _currentControlPadDirection.dx > 0 ? kCBMoveDirectionRight : kCBMoveDirectionLeft;
    CGFloat speed = fabsf(_currentControlPadDirection.dx) * self.runSpeedLimit;
    
    [self move:dirction bySpeed:speed acceleration:self.runSpeedAcceleration deltaTime:delta];
}

- (void)updateMovementInAir:(CFTimeInterval)delta
{
    CBMoveDirection dirction = _currentControlPadDirection.dx > 0 ? kCBMoveDirectionRight : kCBMoveDirectionLeft;
    CGFloat speed = fabsf(_currentControlPadDirection.dx) * self.runSpeedLimit * 0.75;
    [self move:dirction bySpeed:speed acceleration:self.runSpeedAcceleration deltaTime:delta];
}

#pragma mark - Physics Delegate
- (void)didBeginContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody
{
    [super didBeginContact:contact otherBody:otherBody];
    
}

- (void)didEndContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody
{
    [super didEndContact:contact otherBody:otherBody];
    
}

#pragma mark - Input Notifications
//-(void) controlPadDidChangeDirection:(NSNotification*)note
//{
//	KKControlPadBehavior* controlPad = [note.userInfo objectForKey:@"behavior"];
//	if (controlPad.direction == KKArcadeJoystickNone)
//	{
//        _currentControlPadDirection = CGVectorZero;
//	}
//	else
//	{
//		_currentControlPadDirection = vectorFromJoystickState(controlPad.direction);
//	}
//}

- (void) analogueStickDidChangeValue:(CBAnalogueStick *)analogueStick
{
    _currentControlPadDirection = ccv(analogueStick.xValue, analogueStick.yValue);
}

- (void) attackButtonExecute:(id)sender
{
    CBButton *button = (CBButton *)sender;
    if (button.selected)
    {
        if (!self.isAttacking && self.isAttackColdDown && ![self.activeAnimationKey isEqualToString:@"anim_attack"]) {
            [self doAttack];
        }
    }
}

- (void) jumpButtonExecute:(id)sender
{
    CBButton *button = (CBButton *)sender;
    if (button.selected)
    {
        if ((self.isGrounded || self.isClimbing) && !self.isAttacking) {
            [self doJump];
            _jumpButton = button;
        }
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
