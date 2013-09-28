//
//  CBControl.m
//  ClimbBoy
//
//  Created by Robin on 13-9-26.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CBControl.h"

@implementation CBControl

#pragma mark Initializers

- (id)init
{
    self = [super init];
    if (self) {
        _executesWhenPressed = NO;
    }
    return self;
}

- (void)didMoveToParent {
    [super didMoveToParent];
    [self observeInputEvents];
}

- (void)willMoveFromParent {
    [super willMoveFromParent];
    [self disregardInputEvents];
    [self disregardSceneEvents];
}

-(void) update:(NSTimeInterval)currentTime
{
	if (self.selected && self.continuous)
	{
		[self triggerAction];
	}
}

#pragma mark Action handling
- (void) setTarget:(id)target selector:(SEL)selector
{
    __unsafe_unretained id weakTarget = target; // avoid retain cycle
    [self setBlock:^(id sender) {
        objc_msgSend(weakTarget, selector, sender);
	}];
}

- (void) triggerAction
{
    if (self.enabled && _block)
    {
        _block(self);
    }
}

#pragma mark Touch handling

#if TARGET_OS_IPHONE

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches)
    {
        if ([self containsPoint:[touch locationInNode:self.parent]])
        {
            _tracking = (NSInteger)touch;
            _touchInside = YES;
            
            [self touchEntered:touch withEvent:event];
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_tracking) {
        for (UITouch* touch in touches)
        {
            if (_tracking == (NSInteger)touch)
            {
                if ([self containsPoint:[touch locationInNode:self.parent]])
                {
                    if (!_touchInside)
                    {
                        [self touchEntered:touch withEvent:event];
                        _touchInside = YES;
                    }
                }else
                {
                    if (_touchInside) {
                        [self touchExited:touch withEvent:event];
                        _touchInside = NO;
                    }
                }
            }
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_tracking)
    {
        for (UITouch* touch in touches)
        {
            if (_tracking == (NSInteger)touch)
            {
                if (_touchInside)
                {
                    [self touchUpInside:touch withEvent:event];
                }
                else
                {
                    [self touchUpOutside:touch withEvent:event];
                }
                
                _touchInside = NO;
                _tracking = 0;
            }
        }
    }
    
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_tracking)
    {
        for (UITouch* touch in touches)
        {
            if (_tracking == (NSInteger)touch)
            {
                if (_touchInside)
                {
                    [self touchExited:touch withEvent:event];
                }
                _touchInside = NO;
                _tracking = 0;
            }
        }
        
    }
}

- (void) touchEntered:(UITouch*) touch withEvent:(UIEvent*)event
{}

- (void) touchExited:(UITouch*) touch withEvent:(UIEvent*) event
{}

- (void) touchUpInside:(UITouch*) touch withEvent:(UIEvent*) event
{}

- (void) touchUpOutside:(UITouch*) touch withEvent:(UIEvent*) event
{}

#else // OS X
- (void) mouseDown:(NSEvent *)event
{
    _tracking = YES;
    _touchInside = YES;
    
    [self mouseDownEntered:event];
}

- (void) mouseDragged:(NSEvent *)event
{
    if ([self containsPoint:[event locationInNode:self.scnene]])
    {
        if (!_touchInside)
        {
            [self mouseDownEntered:event];
            _touchInside = YES;
        }
    }
    else
    {
        if (_touchInside)
        {
            [self mouseDownExited:event];
            _touchInside = NO;
        }
    }
}

- (void) mouseUp:(NSEvent *)event
{
    if (_touchInside)
    {
        [self mouseUpInside:event];
    }
    else
    {
        [self mouseUpOutside:event];
    }
    
    _touchInside = NO;
    _tracking = NO;
}

- (void) mouseDownEntered:(NSEvent*) event
{}

- (void) mouseDownExited:(NSEvent*) event
{}

- (void) mouseUpInside:(NSEvent*) event
{}

- (void) mouseUpOutside:(NSEvent*) event
{}
#endif

#pragma mark State properties
-(void) setContinuous:(BOOL)continuous
{
	if (_continuous != continuous)
	{
		_continuous = continuous;
		if (_continuous)
		{
			[self observeSceneEvents];
		}
		else
		{
			[self disregardSceneEvents];
		}
	}
}

- (BOOL) enabled
{
    if (!(_state & CBControlStateDisabled)) return YES;
    else return NO;
}

- (void) setEnabled:(BOOL)enabled
{
    if (self.enabled == enabled) return;
    
    BOOL disabled = !enabled;
    
    if (disabled)
    {
        _state |= CBControlStateDisabled;
    }
    else
    {
        _state &= ~CBControlStateDisabled;
    }
    
    [self stateChanged];
}

- (BOOL) selected
{
    if (_state & CBControlStateSelected) return YES;
    else return NO;
}

- (void) setSelected:(BOOL)selected
{
    if (self.selected == selected) return;
    
    if (selected)
    {
        _state |= CBControlStateSelected;
    }
    else
    {
        _state &= ~CBControlStateSelected;
    }
    
    [self stateChanged];
}

- (BOOL) highlighted
{
    if (_state & CBControlStateHighlighted) return YES;
    else return NO;
}

- (void) setHighlighted:(BOOL)highlighted
{
    if (self.highlighted == highlighted) return;
    
    if (highlighted)
    {
        _state |= CBControlStateHighlighted;
    }
    else
    {
        _state &= ~CBControlStateHighlighted;
    }
    
    [self stateChanged];
}

- (void)stateChanged {
    
}

#pragma mark Setting properties for control states by name

- (CBControlState) controlStateFromString:(NSString*)stateName
{
    CBControlState state = 0;
    if ([stateName isEqualToString:@"Normal"]) state = CBControlStateNormal;
    else if ([stateName isEqualToString:@"Highlighted"]) state = CBControlStateHighlighted;
    else if ([stateName isEqualToString:@"Disabled"]) state = CBControlStateDisabled;
    else if ([stateName isEqualToString:@"Selected"]) state = CBControlStateSelected;
    
    return state;
}

- (void) setValue:(id)value forKey:(NSString *)key state:(CBControlState) state
{
    NSString* methodName = [NSString stringWithFormat:@"set%@:forState:", [key capitalizedString]];
    
    SEL sel = NSSelectorFromString(methodName);
    
    objc_msgSend(self, sel, value, state);
}

- (id) valueForKey:(NSString *)key state:(CBControlState)state
{
    NSString* methodName = [NSString stringWithFormat:@"%@ForState:", key];
    
    SEL sel = NSSelectorFromString(methodName);
    
    return objc_msgSend(self, sel, state);
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    NSRange separatorRange = [key rangeOfString:@"|"];
    NSUInteger separatorLoc = separatorRange.location;
    
    if (separatorLoc == NSNotFound)
    {
        [super setValue:value forKey:key];
        return;
    }
    
    NSString* propName = [key substringToIndex:separatorLoc];
    NSString* stateName = [key substringFromIndex:separatorLoc+1];
    
    CBControlState state = [self controlStateFromString:stateName];
    
    [self setValue:value forKey:propName state:state];
}

- (id) valueForKey:(NSString *)key
{
    NSRange separatorRange = [key rangeOfString:@"|"];
    NSUInteger separatorLoc = separatorRange.location;
    
    if (separatorLoc == NSNotFound)
    {
        return [super valueForKey:key];
    }
    
    NSString* propName = [key substringToIndex:separatorLoc];
    NSString* stateName = [key substringFromIndex:separatorLoc+1];
    
    CBControlState state = [self controlStateFromString:stateName];
    
    return [self valueForKey:propName state:state];
}

@end
