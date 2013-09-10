//
//  LevelsMenu.m
//  ClimbBoy
//
//  Created by Robin on 13-9-2.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "LevelsMenu.h"
#import "CBMyScene.h"
#import "LevelTest.h"

static const NSInteger LEVEL_BOX_SIZE = 48;
static NSInteger NUMBER_OF_LEVELS = 15;
static const NSInteger COLUMN_NUMBER = 6;
static const NSInteger MARGIN_BORDER_HORIZONTAL = 100;
static const NSInteger MARGIN_BORDER_TOP = 100;

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
    backToMainButton.position = CGPointMake(CGRectGetMaxX(self.frame) - 50, CGRectGetMaxY(self.frame) - 40);
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
    float boxSpacing = ((self.frame.size.width - MARGIN_BORDER_HORIZONTAL*2) - (COLUMN_NUMBER * LEVEL_BOX_SIZE)) / (COLUMN_NUMBER - 2);
    boxSpacing += LEVEL_BOX_SIZE;
    float startPosY = self.frame.size.height - MARGIN_BORDER_TOP;

    for (int i = 0; i < NUMBER_OF_LEVELS; i++) {
        int col = i % COLUMN_NUMBER;
        int row = i / COLUMN_NUMBER + 1;
        
        CGPoint boxPos = CGPointMake(MARGIN_BORDER_HORIZONTAL + col * boxSpacing, startPosY - (row - 1) * boxSpacing);

        [self createLevelBoxByIndex:i+1 Postion:boxPos];
    }
}

- (void)createLevelBoxByIndex:(int)index Postion:(CGPoint)postion {
    KKSpriteNode *levelBox = [KKSpriteNode spriteNodeWithImageNamed:@"obj_box001.png"];
    levelBox.name = [NSString stringWithFormat:@"Level%02d", index];
    levelBox.anchorPoint = CGPointMake(0.5, 0.5);
    levelBox.size = CGSizeMake(LEVEL_BOX_SIZE, LEVEL_BOX_SIZE);
    levelBox.position = postion;
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
    boxLabel.text = [NSString stringWithFormat:@"%02d", index];
    boxLabel.fontSize = 10;
    boxLabel.fontColor = [SKColor blackColor];
    [levelBox addChild:boxLabel];
}

- (void)backToMainButtonDidExecute:(NSNotification *)notification {
    [self.kkView popSceneWithTransition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
}

- (void)didSelectLevel:(NSNotification *)notification {
    KKSpriteNode *levelBox = (KKSpriteNode *)notification.object;
    NSLog(@"%@", levelBox.name);
    
    if ([levelBox.name isEqualToString:@"Level01"]) {
        LevelTest *levels = [LevelTest sceneWithSize:self.size];
        levels.tmxFile = @"LevelTest01.tmx";
        [self.kkView pushScene:levels transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
    }
    
    if ([levelBox.name isEqualToString:@"Level02"]) {
        LevelTest *levels = [LevelTest sceneWithSize:self.size];
        levels.tmxFile = @"DemoStage001.tmx";
        [self.kkView pushScene:levels transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
    }
    
    
}

@end
