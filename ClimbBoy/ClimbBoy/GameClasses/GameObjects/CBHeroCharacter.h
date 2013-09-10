//
//  CBHeroCharacter.h
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "CBCharacter.h"
#import "CBHeroCharacter_sm.h"

@interface CBHeroCharacter : CBCharacter
{
    CGVector _currentControlPadDirection;
    __weak KKButtonBehavior* _jumpButton;
    CGFloat _jumpingTimer;
}
@property (nonatomic) CGFloat jumpSpeedInitial;
@property (nonatomic) CGFloat jumpSpeedDeceleration;
@property (nonatomic) CGFloat jumpAbortVelocity;
@property (nonatomic) CGFloat fallSpeedAcceleration;
@property (nonatomic) CGFloat fallSpeedLimit;
@property (nonatomic) CGFloat runSpeedAcceleration;
@property (nonatomic) CGFloat runSpeedDeceleration;
@property (nonatomic) CGFloat runSpeedLimit;
@property (nonatomic) CGFloat climbUpSpeedLimit;
@property (nonatomic) CGFloat climbDownSpeedLimit;

@property (nonatomic, readonly)CBHeroCharacterContext *fsm;

/* Designated Initializer. */
- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position;
- (id)initAtPosition:(CGPoint)position;


- (void)updateRunning:(NSTimeInterval)delta;
- (void)startJumping;
- (void)updateJumping:(NSTimeInterval)delta;
- (void)updateFalling:(NSTimeInterval)delta;
- (void)updateClimbing:(NSTimeInterval)delta;

-(void) controlPadDidChangeDirection:(NSNotification*)note;
-(void) jumpButtonPressed:(NSNotification*)note;
-(void) jumpButtonReleased:(NSNotification*)note;

@end
