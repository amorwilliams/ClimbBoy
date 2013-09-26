//
//  CBButton.h
//  ClimbBoy
//
//  Created by Robin on 13-9-26.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CBControl.h"

@interface CBButton : CBControl
{
    NSMutableDictionary* _backgroundSpriteFrames;
    NSMutableDictionary* _backgroundColors;
    NSMutableDictionary* _backgroundOpacities;
    NSMutableDictionary* _labelColors;
    NSMutableDictionary* _labelOpacities;
    float _originalScaleX;
    float _originalScaleY;
}

@property (nonatomic,readonly) SKSpriteNode* background;
@property (nonatomic,readonly) SKLabelNode* label;
@property (nonatomic,assign) BOOL zoomWhenHighlighted;
//@property (nonatomic,assign) float horizontalPadding;
//@property (nonatomic,assign) float verticalPadding;
@property (nonatomic,strong) NSString* title;

+ (id) buttonWithTitle:(NSString*) title;
+ (id) buttonWithTitle:(NSString*) title fontName:(NSString*)fontName fontSize:(float)size;
+ (id) buttonWithTitle:(NSString*) title spriteFrame:(SKSpriteNode*) spriteFrame;
+ (id) buttonWithTitle:(NSString*) title spriteFrame:(SKSpriteNode*) spriteFrame selectedSpriteFrame:(SKSpriteNode*) selected disabledSpriteFrame:(SKSpriteNode*) disabled;

- (id) initWithTitle:(NSString*) title;
- (id) initWithTitle:(NSString*) title fontName:(NSString*)fontName fontSize:(float)size;
- (id) initWithTitle:(NSString*) title spriteFrame:(SKSpriteNode*) spriteFrame;
- (id) initWithTitle:(NSString*) title spriteFrame:(SKSpriteNode*) spriteFrame selectedSpriteFrame:(SKSpriteNode*) selected disabledSpriteFrame:(SKSpriteNode*) disabled;

- (void) setBackgroundColor:(SKColor *) color forState:(CBControlState) state;
- (void) setBackgroundOpacity:(GLubyte) opacity forState:(CBControlState) state;

- (void) setLabelColor:(SKColor *) color forState:(CBControlState) state;
- (void) setLabelOpacity:(GLubyte) opacity forState:(CBControlState) state;

- (SKColor *) backgroundColorForState:(CBControlState)state;
- (GLubyte) backgroundOpacityForState:(CBControlState)state;

- (SKColor *) labelColorForState:(CBControlState) state;
- (GLubyte) labelOpacityForState:(CBControlState) state;

- (void) setBackgroundSpriteFrame:(SKSpriteNode*)spriteFrame forState:(CBControlState)state;
- (SKSpriteNode*) backgroundSpriteFrameForState:(CBControlState)state;
@end
