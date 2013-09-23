//
//  LevelsMenu.m
//  ClimbBoy
//
//  Created by Robin on 13-9-2.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "MapScene.h"
#import "CBMyScene.h"
#import "GameplayScene.h"
#import "MyScene.h"
#import "GameManager.h"
#import "LoadingScene.h"

static const NSInteger LEVEL_BOX_SIZE = 48;
static const NSInteger COLUMN_NUMBER = 6;
static const NSInteger MARGIN_BORDER_HORIZONTAL = 100;
static const NSInteger MARGIN_BORDER_TOP = 100;

@implementation MapScene

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

- (void)willMoveFromView:(SKView *)view {
    [self removeAllChildren];
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
    
    NSArray *levels = [GameManager sharedGameManager].levels;

    for (int i = 0; i < levels.count; i++)
    {
        //get level data
        NSDictionary *level = [levels objectAtIndex:i];
        
        //caculate position
        int col = i % COLUMN_NUMBER;
        int row = i / COLUMN_NUMBER + 1;
        CGPoint postion = CGPointMake(MARGIN_BORDER_HORIZONTAL + col * boxSpacing, startPosY - (row - 1) * boxSpacing);
        
        KKSpriteNode *levelBox = [KKSpriteNode spriteNodeWithImageNamed:@"obj_box001.png"];
        levelBox.name = [NSString stringWithFormat:@"Level%02d", i];
        levelBox.anchorPoint = CGPointMake(0.5, 0.5);
        levelBox.size = CGSizeMake(LEVEL_BOX_SIZE, LEVEL_BOX_SIZE);
        levelBox.position = postion;
        levelBox.userData = [NSMutableDictionary dictionaryWithDictionary:level];
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
        boxLabel.text = [NSString stringWithFormat:@"%02d", i];
        boxLabel.fontSize = 10;
        boxLabel.fontColor = [SKColor blackColor];
        [levelBox addChild:boxLabel];
    }
}

- (void)backToMainButtonDidExecute:(NSNotification *)notification
{
    [self.kkView popSceneWithTransition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
}

- (void)didSelectLevel:(NSNotification *)notification
{
    KKSpriteNode *levelBox = (KKSpriteNode *)notification.object;
    NSDictionary *levelData = levelBox.userData;
    int index = [levelBox.name intValue];
    
    KKScene *level = [LoadingScene sceneWithWithSize:self.size level:levelData index:index];
    [self.kkView pushScene:level transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
}

@end
