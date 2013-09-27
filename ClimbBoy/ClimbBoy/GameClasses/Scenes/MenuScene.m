//
//  MainMenu.m
//  ClimbBoy
//
//  Created by Robin on 13-9-2.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "MenuScene.h"
#import "MapScene.h"
#import "CBMacros.h"
#import "spine-spirte-kit.h"

static const NSInteger BUTTON_SPACING_VERTICAL = 40;
static const NSInteger BUTTON_FLY_HORIZONTAL_POSITION = 100;

@implementation MenuScene

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        KKSpriteNode *backgroundImage = [KKSpriteNode spriteNodeWithImageNamed:@"MainMenu_Bg.png"];
        backgroundImage.position = ccp(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [backgroundImage setScale:0.5];
        [self addChild:backgroundImage];
        
        _menuAnimationSprite = [CBSpineSprite skeletonWithFile:@"MainMenu.json" atlasFile:@"MainMenu.atlas" scale:1];
        _menuAnimationSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _menuAnimationSprite.name = @"menuAnimation";
        [_menuAnimationSprite setScale:0.5];
        [_menuAnimationSprite setAlpha:0];
        [self addChild:_menuAnimationSprite];
        
        [_menuAnimationSprite playAnimation:@"start" loop:NO];
        [self runAction:[SKAction waitForDuration:0.1] completion:^{
            [_menuAnimationSprite setAlpha:1];
            [self addMenuButtons];
        }];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
//    [[OALSimpleAudio sharedInstance] playBg:@"Water Temple.mp3" loop:YES];
    
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
}

- (void)addMenuButtons {
    //-------------------------Start Game Button--------------------------------
    _startGameButton = [CBButton buttonWithTitle:nil spriteFrame:[SKSpriteNode spriteNodeWithImageNamed:@"Button_Play_Normal.png"] selectedSpriteFrame:[SKSpriteNode spriteNodeWithImageNamed:@"Button_Play_Clicked.png"] disabledSpriteFrame:[SKSpriteNode spriteNodeWithImageNamed:@"Button_Play_Disable.png"]];
    _startGameButton.zPosition = 1;
    _startGameButton.alpha = 0;
    _startGameButton.enabled = NO;
    _startGameButton.position = CGPointMake(CGRectGetMidX(self.frame) - 80,
                                            CGRectGetMidY(self.frame) - 85);
    [self addChild:_startGameButton];
	
    
    //--------------------------Options Button-------------------------------
    _optionsButton = [CBButton buttonWithTitle:nil spriteFrame:[SKSpriteNode spriteNodeWithImageNamed:@"Button_Options_Normal.png"] selectedSpriteFrame:[SKSpriteNode spriteNodeWithImageNamed:@"Button_Options_Clicked.png"] disabledSpriteFrame:[SKSpriteNode spriteNodeWithImageNamed:@"Button_Options_Disable.png"]];
    _optionsButton.zPosition = 1;
    _optionsButton.alpha = 0;
    _optionsButton.enabled = NO;
    _optionsButton.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame) - 85);
    [self addChild:_optionsButton];
    
	
    
    //---------------------------Credits Button------------------------------
    _creditsButton = [CBButton buttonWithTitle:nil spriteFrame:[SKSpriteNode spriteNodeWithImageNamed:@"Button_Credits_Normal.png"] selectedSpriteFrame:[SKSpriteNode spriteNodeWithImageNamed:@"Button_Credits_Clicked.png"] disabledSpriteFrame:[SKSpriteNode spriteNodeWithImageNamed:@"Button_Credits_Disable.png"]];
    _creditsButton.zPosition = 1;
    _creditsButton.alpha = 0;
    _creditsButton.enabled = NO;
    _creditsButton.position = CGPointMake(CGRectGetMidX(self.frame) + 80,
                                          CGRectGetMidY(self.frame) - 85);
    [self addChild:_creditsButton];
	
    //---------------------------------------------------------
    
    SKAction *moveAction = [SKAction group:@[[SKAction scaleXTo:0.5 y:0.5 duration:0.3],
                                             [SKAction fadeInWithDuration:0.3]]];
    moveAction.timingMode = SKActionTimingEaseInEaseOut;
    [_startGameButton runAction:[SKAction sequence:@[[SKAction waitForDuration:2], moveAction]] completion:^{
        [_startGameButton setScale:0.5];
        _startGameButton.enabled = YES;
        [_startGameButton setTarget:self selector:@selector(startButtonDidExecute:)];
    }];
    [_optionsButton runAction:[SKAction sequence:@[[SKAction waitForDuration:2.2], moveAction]] completion:^{
        [_optionsButton setScale:0.5];
        _optionsButton.enabled = YES;
        [_optionsButton setTarget:self selector:@selector(optionsButtonDidExecute:)];
    }];
    [_creditsButton runAction:[SKAction sequence:@[[SKAction waitForDuration:2.4], moveAction]] completion:^{
        [_creditsButton setScale:0.5];
        _creditsButton.enabled = YES;
        [_creditsButton setTarget:self selector:@selector(creditsButtonDidExecute:)];
    }];
}

- (void)startButtonDidExecute:(id)sender
{
    NSLog(@"Start button");
    MapScene *mapScene = [MapScene sceneWithSize:self.size];
    [self.kkView presentScene:mapScene transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.6]];
}

- (void)optionsButtonDidExecute:(id)sender
{
    [_menuAnimationSprite playAnimation:@"start" loop:NO];

    NSLog(@"Option button");
}

- (void)creditsButtonDidExecute:(id)sender
{
    NSLog(@"Credits button");
}



@end
