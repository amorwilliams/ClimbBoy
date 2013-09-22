//
//  MainMenu.m
//  ClimbBoy
//
//  Created by Robin on 13-9-2.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "MainMenu.h"
#import "LevelSelectionScene.h"
#import "CBMacros.h"

static const NSInteger BUTTON_SPACING_VERTICAL = 40;
static const NSInteger BUTTON_FLY_HORIZONTAL_POSITION = 100;

@interface MainMenu ()
@property (atomic) SKLabelNode *startGameButton;
@property (atomic) SKLabelNode *optionButton;
@property (atomic) SKLabelNode *creditsButton;
@end

@implementation MainMenu

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor colorWithRed:0.1 green:0.2 blue:0.4 alpha:1];
        
        SKLabelNode* myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
		myLabel.text = @"Climb Boy";
        myLabel.fontSize = 40;
		myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 75);
		[self addChild:myLabel];
        
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self addMenuButtons];
    
//    [[OALSimpleAudio sharedInstance] playBg:@"Water Temple.mp3" loop:YES];
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
//    [self removeButtons];
    
//    [[OALSimpleAudio sharedInstance] stopBg];
    
}

- (void)addMenuButtons {
    _startGameButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _startGameButton.text = @"START";
    _startGameButton.fontSize = 20;
    _startGameButton.zPosition = 1;
    _startGameButton.position = CGPointMake(CGRectGetMidX(self.frame) + BUTTON_FLY_HORIZONTAL_POSITION,
                                            CGRectGetMidY(self.frame));
    _startGameButton.alpha = 0;
    [self addChild:_startGameButton];
    
    // KKButtonBehavior turns any node into a button
	KKButtonBehavior* buttonBehavior = [KKButtonBehavior behavior];
	buttonBehavior.selectedScale = 1.2;
	[_startGameButton addBehavior:buttonBehavior];
	
	// observe button execute notification
	[self observeNotification:KKButtonDidExecuteNotification
					 selector:@selector(startButtonDidExecute:)
					   object:_startGameButton];
    
    _optionButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _optionButton.text = @"OPTION";
    _optionButton.fontSize = 20;
    _optionButton.zPosition = 1;
    _optionButton.position = CGPointMake(CGRectGetMidX(self.frame) + BUTTON_FLY_HORIZONTAL_POSITION,
                                         CGRectGetMidY(self.frame) - BUTTON_SPACING_VERTICAL);
    _optionButton.alpha = 0;
    [self addChild:_optionButton];
    
    // KKButtonBehavior turns any node into a button
	[_optionButton addBehavior:[buttonBehavior copy]];
	
	// observe button execute notification
	[self observeNotification:KKButtonDidExecuteNotification
					 selector:@selector(optionButtonDidExecute:)
					   object:_optionButton];
    
    _creditsButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _creditsButton.text = @"CREDITS";
    _creditsButton.fontSize = 20;
    _creditsButton.zPosition = 1;
    _creditsButton.position = CGPointMake(CGRectGetMidX(self.frame) + BUTTON_FLY_HORIZONTAL_POSITION,
                                          CGRectGetMidY(self.frame) - BUTTON_SPACING_VERTICAL*2);
    _creditsButton.alpha = 0;
    [self addChild:_creditsButton];
    
    // KKButtonBehavior turns any node into a button
	[_creditsButton addBehavior:[buttonBehavior copy]];
	
	// observe button execute notification
	[self observeNotification:KKButtonDidExecuteNotification
					 selector:@selector(creditsButtonDidExecute:)
					   object:_creditsButton];
    
    SKAction *moveAction = [SKAction group:@[[SKAction moveToX:CGRectGetMidX(self.frame) duration:0.4],
                                             [SKAction fadeInWithDuration:0.4]]];
    moveAction.timingMode = SKActionTimingEaseInEaseOut;
    [_startGameButton runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1], moveAction]]];
    [_optionButton runAction:[SKAction sequence:@[[SKAction waitForDuration:0.2], moveAction]]];
    [_creditsButton runAction:[SKAction sequence:@[[SKAction waitForDuration:0.3], moveAction]]];
}

- (void)removeButtons {
    SKAction *moveAction = [SKAction group:@[[SKAction moveToX:(CGRectGetMidX(self.frame) - BUTTON_FLY_HORIZONTAL_POSITION) duration:0.4],
                                             [SKAction fadeOutWithDuration:0.4]]];
    [_startGameButton runAction:[SKAction sequence:@[[SKAction waitForDuration:0.2],
                                                     moveAction,
                                                     [SKAction removeFromParent]]]];
    [_optionButton runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1],
                                                  moveAction,
                                                  [SKAction removeFromParent]]]];
    [_creditsButton runAction:[SKAction sequence:@[moveAction,
                                                   [SKAction removeFromParent]]]];
}

- (void)startButtonDidExecute:(NSNotification *)notification {
    NSLog(@"Start button");
    [self removeButtons];
    [self runAction:[SKAction waitForDuration:0.7] completion:^{
        LevelSelectionScene *levels = [LevelSelectionScene sceneWithSize:self.size];
        [self.kkView pushScene:levels transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
    }];
}

- (void)optionButtonDidExecute:(NSNotification *)notification {
    NSLog(@"Option button");
}

- (void)creditsButtonDidExecute:(NSNotification *)notification {
    NSLog(@"Credits button");
}



@end
