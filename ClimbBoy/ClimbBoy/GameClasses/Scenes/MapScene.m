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
        [_mapBoard setScale:0.55];
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
    _homeButton = [CBButton buttonWithTitle:nil
                                spriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_MainMenu_Normal.png"]
                        selectedSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_MainMenu_Clicked.png"]
                        disabledSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_MainMenu_Disable.png"]];
    [_homeButton setScale:1.4];
    _homeButton.position = CGPointMake(-120, -230);
    [_mapBoard addChild:_homeButton];
    
    [_homeButton setTarget:self selector:@selector(homeButtonDidExecute:)];
    
    //------------------------shop button---------------------------
    _shopButton = [CBButton buttonWithTitle:nil
                                spriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Shop_Normal.png"]
                        selectedSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Shop_Clicked.png"]
                        disabledSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Shop_Disable.png"]];
    
    [_shopButton setScale:1.4];
    _shopButton.position = CGPointMake(120, -230);
    [_mapBoard addChild:_shopButton];
    
    [_shopButton setTarget:self selector:@selector(shopButtonDidExecute:)];

    
    //------------------------previous button---------------------------
    _previousButton = [CBButton buttonWithTitle:nil
                                spriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Previous_Normal.png"]
                        selectedSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Previous_Clicked.png"]
                        disabledSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Previous_Disable.png"]];
    
    [_previousButton setScale:1.4];
    _previousButton.position = CGPointMake(-270, -40);
    [_mapBoard addChild:_previousButton];
    
    [_previousButton setTarget:self selector:@selector(previousButtonDidExecute:)];
    
    //------------------------next button---------------------------
    _nextButton = [CBButton buttonWithTitle:nil
                                    spriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Forward_Normal.png"]
                            selectedSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Forward_Clicked.png"]
                            disabledSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Forward_Disable.png"]];
    
    [_nextButton setScale:1.4];
    _nextButton.position = CGPointMake(270, -40);
    [_mapBoard addChild:_nextButton];
    
    [_nextButton setTarget:self selector:@selector(nextButtonDidExecute:)];
}

- (void)createLevelButtons {
//    float boxSpacing = ((self.frame.size.width - MARGIN_BORDER_LEFT*2) - (COLUMN_NUMBER * LEVEL_BOX_SIZE)) / (COLUMN_NUMBER - 2);
//    boxSpacing += LEVEL_BOX_SIZE;
    
//    float startPosX = MARGIN_BORDER_LEFT;
//    float startPosY = MARGIN_BORDER_TOP;
    
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
        
        CBButton *levelButton = [CBButton buttonWithTitle:nil
                                              spriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Bg_Normal.png"]
                                      selectedSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Bg_Disable.png"]
                                      disabledSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Bg_Disable.png"]];
        levelButton.name = [NSString stringWithFormat:@"Level%02d", i+1];
        levelButton.position = position;
        levelButton.userData = [NSMutableDictionary dictionaryWithDictionary:level];
        levelButton.title = [NSString stringWithFormat:@"%02d", i+1];
        levelButton.label.fontName = @"Chalkduster";
        levelButton.label.fontSize = 20;
        levelButton.label.fontColor = [SKColor yellowColor];
        [_mapBoard addChild:levelButton];
        
        [levelButton setTarget:self selector:@selector(didSelectLevel:)];
        
        BOOL locked = [[level valueForKey:@"Locked"] boolValue];
        if (!locked) {
            levelButton.enabled = NO;
        }
    }
}
#pragma mark -- Buttons Notification

- (void)homeButtonDidExecute:(id)sender
{
//    [self.kkView popSceneWithTransition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
    
    MenuScene *menu = [MenuScene sceneWithSize:self.frame.size];
    [self.kkView presentScene:menu];
}

- (void)shopButtonDidExecute:(id)sender
{
    NSLog(@"shop button");
}

- (void)previousButtonDidExecute:(id)sender
{
    NSLog(@"previous button");
}

- (void)nextButtonDidExecute:(id)sender
{
    NSLog(@"next button");
}


- (void)didSelectLevel:(id)sender
{
    CBButton *button = (CBButton *)sender;
    NSDictionary *levelData = button.userData;
    int index = [button.name intValue];
    
    KKScene *level = [LoadingScene sceneWithWithSize:self.size level:levelData index:index];
    [self.kkView presentScene:level transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
}

@end
