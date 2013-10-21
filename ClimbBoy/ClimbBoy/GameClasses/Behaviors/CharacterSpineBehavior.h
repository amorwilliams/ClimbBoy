//
//  CharacterSpineBehavior.h
//  ClimbBoy
//
//  Created by Robin on 13-10-21.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKBehavior.h"
#import "HeroCharacter.h"

@class BaseCharacter;
@interface CharacterSpineBehavior : KKBehavior
{
    __weak BaseCharacter *_character;
    __weak CBSpineSprite *_spine;
}

@property (atomic, getter = isAnimated) BOOL animated;
@property (atomic) CGFloat animationSpeed;
@property (atomic) NSString *activeAnimationKey;
@property (nonatomic) CBAnimationState requestedAnimation;


@end
