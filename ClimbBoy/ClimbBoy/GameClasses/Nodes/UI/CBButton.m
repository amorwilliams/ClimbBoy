//
//  CBButton.m
//  ClimbBoy
//
//  Created by Robin on 13-9-26.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CBButton.h"

static NSString* const ScaleActionKey = @"CBButtonB:ScaleAction";

@implementation CBButton

- (id) init
{
    return [self initWithTitle:@"" spriteFrame:NULL];
}

+ (id) buttonWithTitle:(NSString*) title
{
    return [[self alloc] initWithTitle:title];
}

+ (id) buttonWithTitle:(NSString*) title fontName:(NSString*)fontName fontSize:(float)size
{
    return [[self alloc] initWithTitle:title fontName:fontName fontSize:size];
}

+ (id) buttonWithTitle:(NSString*) title spriteFrame:(SKSpriteNode*) spriteFrame
{
    return [[self alloc] initWithTitle:title spriteFrame:spriteFrame];
}

+ (id) buttonWithTitle:(NSString*) title spriteFrame:(SKSpriteNode*) spriteFrame selectedSpriteFrame:(SKSpriteNode*) selected disabledSpriteFrame:(SKSpriteNode*) disabled
{
    return [[self alloc] initWithTitle:title spriteFrame:spriteFrame selectedSpriteFrame: selected disabledSpriteFrame:disabled];
}

- (id) initWithTitle:(NSString *)title
{
    self = [self initWithTitle:title spriteFrame:NULL selectedSpriteFrame:NULL disabledSpriteFrame:NULL];
    
    // Default properties for labels with only a title
    self.zoomWhenHighlighted = YES;
    
    return self;
}

- (id) initWithTitle:(NSString *)title fontName:(NSString*)fontName fontSize:(float)size
{
    self = [self initWithTitle:title];
    self.label.fontName = fontName;
    self.label.fontSize = size;
    
    return self;
}

- (id) initWithTitle:(NSString*) title spriteFrame:(SKSpriteNode*) spriteFrame
{
    self = [self initWithTitle:title spriteFrame:spriteFrame selectedSpriteFrame:NULL disabledSpriteFrame:NULL];
    
    // Setup default colors for when only one frame is used
    [self setBackgroundColor:[SKColor whiteColor] forState:CBControlStateSelected];
    [self setLabelColor:[SKColor whiteColor] forState:CBControlStateSelected];
    
    [self setBackgroundOpacity:127 forState:CBControlStateDisabled];
    [self setLabelOpacity:127 forState:CBControlStateDisabled];
    
    return self;
}

- (id) initWithTitle:(NSString*) title spriteFrame:(SKSpriteNode*) spriteFrame selectedSpriteFrame:(SKSpriteNode*) selected disabledSpriteFrame:(SKSpriteNode*) disabled
{
    self = [super init];
    if (self)
    {
        if (!title)
        {
            title = @"";
        }
        
        // Setup holders for properties
        _backgroundColors = [NSMutableDictionary dictionary];
        _backgroundOpacities = [NSMutableDictionary dictionary];
        _backgroundSpriteFrames = [NSMutableDictionary dictionary];
        
        _labelColors = [NSMutableDictionary dictionary];
        _labelOpacities = [NSMutableDictionary dictionary];
        
        // Setup background image
        if (spriteFrame)
        {
            _background = [SKSpriteNode spriteNodeWithTexture:spriteFrame.texture];
            [self setBackgroundSpriteFrame:spriteFrame forState:CBControlStateNormal];
            self.preferredSize = spriteFrame.size;
        }
        else
        {
            _background = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:1 green:1 blue:1 alpha:0] size:CGSizeMake(32, 32)];
        }
        
        if (selected) {
            [self setBackgroundSpriteFrame:selected forState:CBControlStateSelected];
        }
        
        if (disabled) {
            [self setBackgroundSpriteFrame:disabled forState:CBControlStateDisabled];
        }
        
        [self addChild:_background];
        
        // Setup label
        _label = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        _label.text = title;
        _label.fontSize = 14;
        _label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        
        [self addChild:_label];
        
        // Setup original scale
        _originalScaleX = _originalScaleY = 1;
        _zoomWhenHighlighted = YES;
        
        [self stateChanged];
    }
    
    return self;
}

#if TARGET_OS_IPHONE

- (void) touchEntered:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.selected = YES;
    if (self.executesWhenPressed) {
        [self triggerAction];
    }
}

- (void) touchExited:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.selected = NO;
}

- (void) touchUpInside:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.selected = NO;
    if (!self.executesWhenPressed) {
        [self triggerAction];
    }
}

- (void) touchUpOutside:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.selected = NO;
}

#else //MacOS

- (void) mouseDownEntered:(NSEvent *)event
{
    self.selected = YES;
    if (self.executesWhenPressed) {
        [self triggerAction];
    }
}

- (void) mouseDownExited:(NSEvent *)event
{
    self.selected = NO;
}

- (void) mouseUpInside:(NSEvent *)event
{
    self.selected = NO;
    if (!self.executesWhenPressed) {
        [self triggerAction];
    }
}

- (void) mouseUpOutside:(NSEvent *)event
{
    self.selected = NO;
}

#endif

- (void) updatePropertiesForState:(CBControlState)state
{
    // Update background
    _background.color = [self backgroundColorForState:state];
    _background.alpha = [self backgroundOpacityForState:state];
    
    SKSpriteNode* spriteFrame = [self backgroundSpriteFrameForState:state];
    if (!spriteFrame) spriteFrame = [self backgroundSpriteFrameForState:CBControlStateNormal];
    [_background setTexture:spriteFrame.texture];
    
    // Update label
    _label.color = [self labelColorForState:state];
    _label.alpha = [self labelOpacityForState:state];
    
}

- (void) stateChanged
{
    if (self.enabled)
    {
        // Button is enabled
        if (self.selected)
        {
            [self updatePropertiesForState:CBControlStateSelected];
            
            if (_zoomWhenHighlighted)
            {
                SKAction *zoom = [SKAction scaleXTo:_originalScaleX*1.2 y:_originalScaleY*1.2 duration:0.1];
//                [_label runAction:zoom];
//                [_background runAction:zoom];
                [self runAction:zoom withKey:ScaleActionKey];
            }
        }
        else
        {
            [self updatePropertiesForState:CBControlStateNormal];
            
//            [_label removeAllActions];
//            [_background removeAllActions];
            [self removeActionForKey:ScaleActionKey];
            if (_zoomWhenHighlighted)
            {
//                _label.xScale = _originalScaleX;
//                _label.yScale = _originalScaleY;
                
//                _background.xScale = _originalScaleX;
//                _background.yScale = _originalScaleY;
                self.xScale = _originalScaleX;
                self.yScale = _originalScaleY;
            }
        }
    }
    else
    {
        // Button is disabled
        [self updatePropertiesForState:CBControlStateDisabled];
    }
}

#pragma mark Properties

- (void) setScale:(CGFloat)scale
{
    _originalScaleX = _originalScaleY = scale;
    [super setScale:scale];
}

- (void)setXScale:(CGFloat)xScale
{
    _originalScaleX = xScale;
    [super setXScale:xScale];
}

- (void)setYScale:(CGFloat)yScale
{
    _originalScaleY = yScale;
    [super setYScale:yScale];
}

- (void) setLabelColor:(SKColor *)color forState:(CBControlState)state
{
    [_labelColors setObject:[NSValue value:&color withObjCType:@encode(SKColor)] forKey:[NSNumber numberWithInt:state]];
    [self stateChanged];
}

- (SKColor *) labelColorForState:(CBControlState)state
{
    NSValue* val = [_labelColors objectForKey:[NSNumber numberWithInt:state]];
    if (!val) return [SKColor whiteColor];
    SKColor *color;
    [val getValue:&color];
    return color;
}

- (void) setLabelOpacity:(GLubyte)opacity forState:(CBControlState)state
{
    [_labelOpacities setObject:[NSNumber numberWithInt:opacity] forKey:[NSNumber numberWithInt:state]];
    [self stateChanged];
}

- (GLubyte) labelOpacityForState:(CBControlState)state
{
    NSNumber* val = [_labelOpacities objectForKey:[NSNumber numberWithInt:state]];
    if (!val) return 1;
    return [val intValue];
}

- (void) setBackgroundColor:(SKColor *)color forState:(CBControlState)state
{
    [_backgroundColors setObject:[NSValue value:&color withObjCType:@encode(SKColor)] forKey:[NSNumber numberWithInt:state]];
    [self stateChanged];
}

- (SKColor *) backgroundColorForState:(CBControlState)state
{
    NSValue* val = [_backgroundColors objectForKey:[NSNumber numberWithInt:state]];
    if (!val) return [SKColor whiteColor];
    SKColor *color;
    [val getValue:&color];
    return color;
}

- (void) setBackgroundOpacity:(GLubyte)opacity forState:(CBControlState)state
{
    [_backgroundOpacities setObject:[NSNumber numberWithInt:opacity] forKey:[NSNumber numberWithInt:state]];
    [self stateChanged];
}

- (GLubyte) backgroundOpacityForState:(CBControlState)state
{
    NSNumber* val = [_backgroundOpacities objectForKey:[NSNumber numberWithInt:state]];
    if (!val) return 1;
    return [val intValue];
}

- (void) setBackgroundSpriteFrame:(SKSpriteNode*)spriteFrame forState:(CBControlState)state
{
    if (spriteFrame)
    {
        [_backgroundSpriteFrames setObject:spriteFrame forKey:[NSNumber numberWithInt:state]];
    }
    else
    {
        [_backgroundSpriteFrames removeObjectForKey:[NSNumber numberWithInt:state]];
    }
    [self stateChanged];
}

- (SKSpriteNode*) backgroundSpriteFrameForState:(CBControlState)state
{
    return [_backgroundSpriteFrames objectForKey:[NSNumber numberWithInt:state]];
}

- (void) setTitle:(NSString *)title
{
    _label.text = title;
}

- (NSString*) title
{
    return _label.text;
}

- (NSArray*) keysForwardedToLabel
{
    return @[@"fontName",
             @"fontSize",
             @"alpha",
             @"color",
             @"fontColor"];
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    if ([[self keysForwardedToLabel] containsObject:key])
    {
        [_label setValue:value forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}

- (id) valueForKey:(NSString *)key
{
    if ([[self keysForwardedToLabel] containsObject:key])
    {
        return [_label valueForKey:key];
    }
    return [super valueForKey:key];
}

@end
