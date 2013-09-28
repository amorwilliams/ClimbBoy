//
//  CharacterPhysicsBehavior.h
//  ClimbBoy
//
//  Created by Robin on 13-9-28.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKBehavior.h"
#import "BaseCharacter.h"

@class BaseCharacter;

@interface CharacterPhysicsBehavior : KKBehavior
{
    __weak BaseCharacter *_character;
}
@property (atomic) CGPoint center;
@property (atomic) CGSize size;

@property (nonatomic, readonly, getter = isTouchSide) BOOL touchSide;
@property (nonatomic, readonly, getter = isGrounded) BOOL grounded;
@property (nonatomic, readonly, getter = isTouchTop) BOOL touchTop;
@property (nonatomic, readonly) int touchSideDirection;

@end
