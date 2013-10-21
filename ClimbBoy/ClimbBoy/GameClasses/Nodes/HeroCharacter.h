//
//  CBHeroCharacter.h
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "BaseCharacter.h"
#import "ClimbBoy-ui.h"

@interface HeroCharacter : BaseCharacter
{
    CGVector _currentControlPadDirection;
    __weak CBButton* _jumpButton;
    
}
@property (nonatomic) CGFloat climbUpSpeedLimit;
@property (nonatomic) CGFloat climbDownSpeedLimit;

//@property (nonatomic, readonly)CBHeroCharacterContext *fsm;

/* Designated Initializer. */
//- (id)initWithSpineSprite:(CBSpineSprite *)spineSprite atPosition:(CGPoint)position;
//- (id)initAtPosition:(CGPoint)position;


//- (void)updateRunning:(NSTimeInterval)delta;
//- (void)startJumping;
//- (void)updateJumping:(NSTimeInterval)delta;
//- (void)updateFalling:(NSTimeInterval)delta;
//- (void)updateClimbing:(NSTimeInterval)delta;

//- (void) controlPadDidChangeDirection:(NSNotification*)note;
- (void) attackButtonExecute:(id)sender;
- (void) jumpButtonExecute:(id)sender;
- (void) analogueStickDidChangeValue:(CBAnalogueStick *)analogueStick;


@end
