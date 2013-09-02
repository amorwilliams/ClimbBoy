//
//  LevelsMenu.m
//  ClimbBoy
//
//  Created by Robin on 13-9-2.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "LevelsMenu.h"
#import "CBMyScene.h"

#define NUMBER_OF_LEVELS 10
#define COLUMN_NUMBER 6

@implementation LevelsMenu

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor colorWithRed:0.4 green:0.1 blue:0.5 alpha:1];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [self addButtons];
    [self addLevelsBox];
}

- (void)addButtons {
    SKLabelNode *backToMainButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backToMainButton.text = @"Back";
    backToMainButton.fontSize = 20;
    backToMainButton.zPosition = 1;
    backToMainButton.position = CGPointMake(CGRectGetMaxX(self.frame) - 50, CGRectGetMaxY(self.frame) - 30);
    [self addChild:backToMainButton];
    
    // KKButtonBehavior turns any node into a button
	KKButtonBehavior* buttonBehavior = [KKButtonBehavior behavior];
	buttonBehavior.selectedScale = 1.2;
	[backToMainButton addBehavior:buttonBehavior];
	
	// observe button execute notification
	[self observeNotification:KKButtonDidExecuteNotification
					 selector:@selector(backToMainButtonDidExecute:)
					   object:backToMainButton];
}

- (void)addLevelsBox {
    for (int i = 0; i < NUMBER_OF_LEVELS; i++) {
        int col = i % COLUMN_NUMBER;
        int row = i / COLUMN_NUMBER + 1;
        
        KKSpriteNode *levelBox = [KKSpriteNode spriteNodeWithImageNamed:@"obj_box001.png"];
        levelBox.name = [NSString stringWithFormat:@"Level%02d", i+1];
        levelBox.anchorPoint = CGPointMake(0.5, 0.5);
        levelBox.size = CGSizeMake(64, 64);
        levelBox.position = CGPointMake(80 + col * 80, 300 - row * 80);
        [self addChild:levelBox];
        
        // KKButtonBehavior turns any node into a button
        KKButtonBehavior* buttonBehavior = [KKButtonBehavior behavior];
        buttonBehavior.selectedScale = 1.2;
        [levelBox addBehavior:buttonBehavior];
        
        // observe button execute notification
        [self observeNotification:KKButtonDidExecuteNotification
                         selector:@selector(didSelectLevel:)
                           object:levelBox];
        
        
        KKLabelNode *boxLabel = [KKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        boxLabel.text = [NSString stringWithFormat:@"%02d", i+1];
        boxLabel.fontSize = 20;
        boxLabel.fontColor = [SKColor blackColor];
        [levelBox addChild:boxLabel];
    }
}

- (void)backToMainButtonDidExecute:(NSNotification *)notification {
    [self.kkView popSceneWithTransition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
}

- (void)didSelectLevel:(NSNotification *)notification {
    KKSpriteNode *levelBox = (KKSpriteNode *)notification.object;
    NSLog(@"%@", levelBox.name);
    
    if ([levelBox.name isEqualToString:@"Level01"]) {
        KKScene *levels = [CBMyScene sceneWithSize:self.size];
        [self.kkView pushScene:levels transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
    }
}

@end
