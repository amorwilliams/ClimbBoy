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
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [_menuAnimationSprite playAnimation:@"start" loop:NO];
    [self runAction:[SKAction waitForDuration:0.1] completion:^{
        [_menuAnimationSprite setAlpha:1];
        [self addMenuButtons];
    }];

//    [[OALSimpleAudio sharedInstance] playBg:@"Water Temple.mp3" loop:YES];
    
}

- (void)willMoveFromView:(SKView *)view {
    [_menuAnimationSprite setAlpha:0];
    [super willMoveFromView:view];
}

- (void)addMenuButtons {
    //-------------------------Start Game Button--------------------------------
    _startGameButton = [KKSpriteNode spriteNodeWithImageNamed:@"Button_Play_Normal.png"];
    _startGameButton.zPosition = 1;
    _startGameButton.position = CGPointMake(CGRectGetMidX(self.frame) - 80,
                                            CGRectGetMidY(self.frame) - 85);
    _startGameButton.alpha = 0;
    [_startGameButton setScale:0.5];
    [self addChild:_startGameButton];
    
    // KKButtonBehavior turns any node into a button
	KKButtonBehavior* startButtonBehavior = [KKButtonBehavior behavior];
    startButtonBehavior.selectedTexture = [SKTexture textureWithImageNamed:@"Button_Play_Clicked.png"];
	startButtonBehavior.selectedScale = 1.2;
	[_startGameButton addBehavior:startButtonBehavior withKey:@"button"];
	
	
    
    //--------------------------Options Button-------------------------------
    _optionsButton = [KKSpriteNode spriteNodeWithImageNamed:@"Button_Options_Normal.png"];
    _optionsButton.zPosition = 1;
    _optionsButton.position = CGPointMake(CGRectGetMidX(self.frame),
                                         CGRectGetMidY(self.frame) - 85);
    _optionsButton.alpha = 0;
    [_optionsButton setScale:0.5];
    [self addChild:_optionsButton];
    
    // KKButtonBehavior turns any node into a button
    KKButtonBehavior* optionButtonBehavior = [KKButtonBehavior behavior];
    optionButtonBehavior.selectedTexture = [SKTexture textureWithImageNamed:@"Button_Options_Clicked.png"];
    optionButtonBehavior.selectedScale = 1.2;
	[_optionsButton addBehavior:optionButtonBehavior withKey:@"button"];
    
	
    
    //---------------------------Credits Button------------------------------
    _creditsButton = [KKSpriteNode spriteNodeWithImageNamed:@"Button_Credits_Normal.png"];
    _creditsButton.zPosition = 1;
    _creditsButton.position = CGPointMake(CGRectGetMidX(self.frame) + 80,
                                          CGRectGetMidY(self.frame) - 85);
    _creditsButton.alpha = 0;
    [_creditsButton setScale:0.5];
    [self addChild:_creditsButton];
    
    // KKButtonBehavior turns any node into a button
    KKButtonBehavior* creditsButtonBehavior = [KKButtonBehavior behavior];
    creditsButtonBehavior.selectedTexture = [SKTexture textureWithImageNamed:@"Button_Credits_Clicked.png"];
    creditsButtonBehavior.selectedScale = 1.2;
	[_creditsButton addBehavior:creditsButtonBehavior withKey:@"button"];
	
    //---------------------------------------------------------
    
    SKAction *moveAction = [SKAction group:@[[SKAction scaleXTo:0.5 y:0.5 duration:0.3],
                                             [SKAction fadeInWithDuration:0.3]]];
    moveAction.timingMode = SKActionTimingEaseInEaseOut;
    [_startGameButton runAction:[SKAction sequence:@[[SKAction waitForDuration:2], moveAction]] completion:^{
        // observe button execute notification
        [self observeNotification:KKButtonDidExecuteNotification
                         selector:@selector(startButtonDidExecute:)
                           object:_startGameButton];
    }];
    [_optionsButton runAction:[SKAction sequence:@[[SKAction waitForDuration:2.2], moveAction]] completion:^{
        // observe button execute notification
        [self observeNotification:KKButtonDidExecuteNotification
                         selector:@selector(optionButtonDidExecute:)
                           object:_optionsButton];
    }];
    [_creditsButton runAction:[SKAction sequence:@[[SKAction waitForDuration:2.4], moveAction]] completion:^{
        // observe button execute notification
        [self observeNotification:KKButtonDidExecuteNotification
                         selector:@selector(creditsButtonDidExecute:)
                           object:_creditsButton];
    }];
}

- (void)removeButtonsAnimation {
    SKAction *moveAction = [SKAction group:@[[SKAction moveToX:(CGRectGetMidX(self.frame) - BUTTON_FLY_HORIZONTAL_POSITION) duration:0.4],
                                             [SKAction fadeOutWithDuration:0.4]]];
    [_startGameButton runAction:[SKAction sequence:@[[SKAction waitForDuration:0.2],
                                                     moveAction,
                                                     [SKAction removeFromParent]]]];
    [_optionsButton runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1],
                                                  moveAction,
                                                  [SKAction removeFromParent]]]];
    [_creditsButton runAction:[SKAction sequence:@[moveAction,
                                                   [SKAction removeFromParent]]]];
}

- (void)startButtonDidExecute:(NSNotification *)notification {
    NSLog(@"Start button");
    [self removeButtonsAnimation];
    MapScene *mapScene = [MapScene sceneWithSize:self.size];
    [self runAction:[SKAction waitForDuration:1] completion:^{
        [self.kkView presentScene:mapScene transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.3]];
    }];
}

- (void)optionButtonDidExecute:(NSNotification *)notification {
    [_menuAnimationSprite playAnimation:@"start" loop:NO];

    NSLog(@"Option button");
}

- (void)creditsButtonDidExecute:(NSNotification *)notification {
    NSLog(@"Credits button");
}



@end
