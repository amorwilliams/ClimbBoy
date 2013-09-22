//
//  CBCharacterAnimator.h
//  ClimbBoy
//
//  Created by Robin on 13-9-3.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKBehavior.h"
#import "BaseCharacter.h"

@interface CharacterAnimatorBehavior : KKBehavior

@property (atomic, getter = isAnimated) BOOL animated;
@property (atomic) CGFloat animationSpeed;
@property (atomic) NSString *activeAnimationKey;
@property (atomic) CBAnimationState requestedAnimation;

@end
