//
//  CBCharacterAnimatorDelegate.h
//  ClimbBoy
//
//  Created by Robin on 13-9-4.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

@class CBCharacter;

@protocol CBCharacterAnimatorDelegate <NSObject>
@required
- (void)animationHasCompleted:(CBAnimationState)animationState;

@end
