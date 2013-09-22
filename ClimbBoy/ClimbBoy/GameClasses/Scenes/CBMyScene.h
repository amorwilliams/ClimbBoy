//
//  CBMyScene.h
//  ClimbBoy
//

//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define kMinTimeInterval (1.0f / 60.0f)

@class HeroCharacter;

@interface CBMyScene : KKScene

@property(nonatomic)HeroCharacter *hero;

@end
