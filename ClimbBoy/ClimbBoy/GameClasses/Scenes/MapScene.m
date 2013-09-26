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
#import "MenuScene.h"

static const NSInteger LEVEL_BOX_SIZE = 48;
static const NSInteger COLUMN_NUMBER = 5;
static const NSInteger BUTTON_OFFSET_X = 88;
static const NSInteger BUTTON_OFFSET_Y = 100;
static const NSInteger BUTTON_LEFT_START = -170;
static const NSInteger BUTTON_TOP_START = 60;

@implementation MapScene

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor colorWithRed:0.4 green:0.1 blue:0.5 alpha:1];
        KKSpriteNode *backgroundImage = [KKSpriteNode spriteNodeWithImageNamed:@"MainMenu_Bg.png"];
        backgroundImage.position = ccp(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [backgroundImage setScale:0.5];
        [self addChild:backgroundImage];
        
        _mapBoard = [KKSpriteNode spriteNodeWithImageNamed:@"Map_Board.png"];
        _mapBoard.position = ccp(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 30);
        [_mapBoard setScale:0.5];
        [self addChild:_mapBoard];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self addButtons];
    [self createLevelButtons];
}

- (void)willMoveFromView:(SKView *)view {
    [self removeAllChildren];
}

- (void)addButtons {
    //------------------------home button---------------------------
    _homeButton = [KKSpriteNode spriteNodeWithImageNamed:@"Button_MainMenu_Normal.png"];
    _homeButton.anchorPoint = CGPointMake(0.5, 0.5);
    [_homeButton setScale:1.2];
    _homeButton.position = CGPointMake(-120, -230);
    [_mapBoard addChild:_homeButton];
    
    // KKButtonBehavior turns any node into a button
	KKButtonBehavior* homeButtonBehavior = [KKButtonBehavior behavior];
    homeButtonBehavior.selectedTexture = [SKTexture textureWithImageNamed:@"Button_MainMenu_Clicked.png"];
//	homeButtonBehavior.selectedScale = 1.2;
	[_homeButton addBehavior:homeButtonBehavior];
	
	// observe button execute notification
	[self observeNotification:KKButtonDidExecuteNotification
					 selector:@selector(homeButtonDidExecute:)
					   object:_homeButton];
    
    //------------------------shop button---------------------------
    _shopButton = [KKSpriteNode spriteNodeWithImageNamed:@"Button_Shop_Normal.png"];
    _shopButton.anchorPoint = CGPointMake(0.5, 0.5);
    [_shopButton setScale:1.2];
    _shopButton.position = CGPointMake(120, -230);
    [_mapBoard addChild:_shopButton];
    
    // KKButtonBehavior turns any node into a button
	KKButtonBehavior* shopButtonBehavior = [KKButtonBehavior behavior];
    shopButtonBehavior.selectedTexture = [SKTexture textureWithImageNamed:@"Button_Shop_Clicked.png"];
    //	homeButtonBehavior.selectedScale = 1.2;
	[_shopButton addBehavior:shopButtonBehavior];
	
	// observe button execute notification
	[self observeNotification:KKButtonDidExecuteNotification
					 selector:@selector(shopButtonDidExecute:)
					   object:_shopButton];
    
    //------------------------previous button---------------------------
    _previousButton = [KKSpriteNode spriteNodeWithImageNamed:@"Button_Previous_Normal.png"];
    _previousButton.anchorPoint = CGPointMake(0.5, 0.5);
    [_previousButton setScale:1.2];
    _previousButton.position = CGPointMake(-270, -40);
    [_mapBoard addChild:_previousButton];
    
    // KKButtonBehavior turns any node into a button
	KKButtonBehavior* previousButtonBehavior = [KKButtonBehavior behavior];
    previousButtonBehavior.selectedTexture = [SKTexture textureWithImageNamed:@"Button_Previous_Clicked.png"];
    //	homeButtonBehavior.selectedScale = 1.2;
	[_previousButton addBehavior:previousButtonBehavior];
	
	// observe button execute notification
	[self observeNotification:KKButtonDidExecuteNotification
					 selector:@selector(previousButtonDidExecute:)
					   object:_previousButton];
    
    //------------------------next button---------------------------
    _nextButton = [KKSpriteNode spriteNodeWithImageNamed:@"Button_Forward_Normal.png"];
    _nextButton.anchorPoint = CGPointMake(0.5, 0.5);
    [_nextButton setScale:1.2];
    _nextButton.position = CGPointMake(270, -40);
    [_mapBoard addChild:_nextButton];
    
    // KKButtonBehavior turns any node into a button
	KKButtonBehavior* nextButtonBehavior = [KKButtonBehavior behavior];
    nextButtonBehavior.selectedTexture = [SKTexture textureWithImageNamed:@"Button_Forward_Clicked.png"];
    //	homeButtonBehavior.selectedScale = 1.2;
	[_nextButton addBehavior:nextButtonBehavior];
	
	// observe button execute notification
	[self observeNotification:KKButtonDidExecuteNotification
					 selector:@selector(nextButtonDidExecute:)
					   object:_nextButton];
}

- (void)createLevelButtons {
//    float boxSpacing = ((self.frame.size.width - MARGIN_BORDER_LEFT*2) - (COLUMN_NUMBER * LEVEL_BOX_SIZE)) / (COLUMN_NUMBER - 2);
//    boxSpacing += LEVEL_BOX_SIZE;
    
//    float startPosX = MARGIN_BORDER_LEFT;
//    float startPosY = MARGIN_BORDER_TOP;
    
    [SKTexture preloadTextures:@[[SKTexture textureWithImageNamed:@"Button_Bg_Normal.png"],
                                 [SKTexture textureWithImageNamed:@"Button_Bg_Disable.png"]]
         withCompletionHandler:^{
        NSArray *levels = [GameManager sharedGameManager].levels;
        for (int i = 0; i < levels.count; i++)
        {
            //get level data
            NSDictionary *level = [levels objectAtIndex:i];
            
            //caculate position
            int col = i % COLUMN_NUMBER;
            int row = i / COLUMN_NUMBER + 1;
            //        CGPoint postion = CGPointMake(MARGIN_BORDER_LEFT + col * boxSpacing, startPosY - (row - 1) * boxSpacing);
            CGPoint position = CGPointMake(BUTTON_LEFT_START + col * BUTTON_OFFSET_X, BUTTON_TOP_START - (row -1) * BUTTON_OFFSET_Y);
            
            KKSpriteNode *levelButton = [KKSpriteNode spriteNodeWithImageNamed:@"Button_Bg_Normal.png"];
            levelButton.name = [NSString stringWithFormat:@"Level%02d", i+1];
            levelButton.anchorPoint = CGPointMake(0.5, 0.5);
            //        levelBox.size = CGSizeMake(LEVEL_BOX_SIZE, LEVEL_BOX_SIZE);
            //        [levelButton setScale:0.5];
            levelButton.position = position;
            levelButton.userData = [NSMutableDictionary dictionaryWithDictionary:level];
            [_mapBoard addChild:levelButton];
            
            // KKButtonBehavior turns any node into a button
            KKButtonBehavior* buttonBehavior = [KKButtonBehavior behavior];
            buttonBehavior.selectedTexture = [SKTexture textureWithImageNamed:@"Button_Bg_Disable.png"];
            buttonBehavior.selectedScale = 1.2;
            [levelButton addBehavior:buttonBehavior];
            
            // observe button execute notification
            [self observeNotification:KKButtonDidExecuteNotification
                             selector:@selector(didSelectLevel:)
                               object:levelButton];
            
            
            KKLabelNode *boxLabel = [KKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            boxLabel.text = [NSString stringWithFormat:@"%02d", i+1];
            boxLabel.fontSize = 20;
            boxLabel.fontColor = [SKColor yellowColor];
            [levelButton addChild:boxLabel];
        }
    }];
}
#pragma mark -- Buttons Notification

- (void)homeButtonDidExecute:(NSNotification *)notification
{
//    [self.kkView popSceneWithTransition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
    
    MenuScene *menu = [MenuScene sceneWithSize:self.frame.size];
    [self.kkView presentScene:menu transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
}

- (void)shopButtonDidExecute:(NSNotification *)notification
{
    
}

- (void)previousButtonDidExecute:(NSNotification *)notification
{
    
}

- (void)nextButtonDidExecute:(NSNotification *)notification
{
    
}


- (void)didSelectLevel:(NSNotification *)notification
{
    KKSpriteNode *levelBox = (KKSpriteNode *)notification.object;
    NSDictionary *levelData = levelBox.userData;
    int index = [levelBox.name intValue];
    
    KKScene *level = [LoadingScene sceneWithWithSize:self.size level:levelData index:index];
    [self.kkView presentScene:level transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
}

@end
