//
//  CBRobot.h
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "HeroCharacter.h"

@interface HeroRobot : HeroCharacter

- (id)initAtPosition:(CGPoint)position;

- (NSArray *)idleAnimationFrames;
- (NSArray *)runAnimationFrames;
- (NSArray *)jumpStartAnimationFrames;
- (NSArray *)jumpLoopAnimationFrames;
- (NSArray *)landAnimationFrames;
- (NSArray *)climbAnimationFrames;
@end
