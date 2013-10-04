//
//  CBAnalogueStick.m
//  ClimbBoy
//
//  Created by Robin on 13-10-4.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CBAnalogueStick.h"
#import "CBGraphicsUtilities.h"

@implementation CBAnalogueStick

+ (id)StickWithHandle:(SKSpriteNode *)handleSprite background:(SKSpriteNode *)backgroundSprite
{
    return [[[self class] alloc] initWithHandle:handleSprite background:backgroundSprite];
}

- (id)initWithHandle:(SKSpriteNode *)handleSprite background:(SKSpriteNode *)backgroundSprite
{
    self = [super init];
    if (self) {
        _backgroundSprite = backgroundSprite;
        _backgroundSprite.anchorPoint = CGPointMake(0.5, 0.5);
        [self addChild:_backgroundSprite];
        
        _handleSprite = handleSprite;
        _handleSprite.anchorPoint = CGPointMake(0.5, 0.5);
        [self addChild:_handleSprite];
        
        _radius = _backgroundSprite.size.width;
        
        _xValue = 0;
        _yValue = 0;
    }
    return self;
}

- (void) updateStick:(CGPoint)location
{
    CGPoint normalised = ccp(location.x/_radius, location.y/_radius);
    normalised = ccpClampMagnitude(normalised, 1);
	
	if (self.invertedYAxis)
	{
		normalised.y *= -1;
	}
    
    if(ccpLength(normalised) < _deadZone)
    {
        normalised = CGPointZero;
    }
    else
    {
        normalised = ccpMult(normalised, (ccpLength(normalised) - _deadZone) / (1 - _deadZone));
    }
    
	_xValue = normalised.x;
	_yValue = normalised.y;
    
    _handleSprite.position = ccpClampMagnitude(location, _radius);
	
	if ([self.delegate respondsToSelector:@selector(analogueStickDidChangeValue:)])
	{
		[self.delegate analogueStickDidChangeValue:self];
	}
}

#if TARGET_OS_IPHONE
- (void) touchEntered:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.selected = YES;
    CGPoint location = [touch locationInNode:self];
    [self updateStick:location];
}

- (void) touchExited:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.selected = NO;
//    [self updateStick:CGPointZero];
}

- (void) touchUpInside:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.selected = NO;
    [self updateStick:CGPointZero];
}

- (void) touchUpOutside:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.selected = NO;
    [self updateStick:CGPointZero];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInNode:self];
    [self updateStick:location];
}

#else // OS X
#endif


@end
