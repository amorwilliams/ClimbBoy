//
//  IntroScene.m
//  ClimbBoy
//
//  Created by Robin on 13-9-21.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "IntroScene.h"
#import "MenuScene.h"

@implementation IntroScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor blackColor];
        SKLabelNode* myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
		myLabel.text = @"Game Intro!";
		myLabel.fontSize = 60;
		myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
		[self addChild:myLabel];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    MenuScene *menu = [MenuScene sceneWithSize:self.frame.size];
    [self runAction:[SKAction waitForDuration:2] completion:^{
        [self.kkView presentScene:menu];
    }];
}

@end
