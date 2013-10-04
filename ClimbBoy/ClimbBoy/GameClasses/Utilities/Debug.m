//
//  CBDebug.m
//  ClimbBoy
//
//  Created by Robin on 13-9-19.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//
#import "Debug.h"

@implementation Debug

DEFINE_SINGLETON_FOR_CLASS(Debug)

- (id)init
{
    self = [super init];
    if (self) {
            _debugNodes = [NSMutableArray arrayWithCapacity:2];
        }
    return self;
}

- (void)didMoveToParent
{
    self.zPosition = 100;
    _enable = YES;
    [self observeSceneEvents];
}

- (void)willMoveFromParent
{
    _enable = NO;
    [self disregardSceneEvents];
}

- (void)update:(NSTimeInterval)currentTime
{
    if (!self.isEnable) return;

    for (int i = 0; i < _debugNodes.count; i++) {
            SKNode *node = [_debugNodes objectAtIndex:i];
            [node removeFromParent];
        }

    [_debugNodes removeAllObjects];
}


+ (void) drawLineStart:(CGPoint)start end:(CGPoint)end
{
    [[Debug sharedDebug] drawLineStart:start end:end color:[SKColor blueColor]];
}


+ (void) drawLineStart:(CGPoint)start end:(CGPoint)end color:(SKColor *)color
{
    [[Debug sharedDebug] drawLineStart:start end:end color:color];
}

- (void) drawLineStart:(CGPoint)start end:(CGPoint)end color:(SKColor *)color
{
    if (!self.isEnable) return;

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddLineToPoint(path, NULL, end.x, end.y);

    SKShapeNode *shape = [SKShapeNode node];
    shape.path = path;
    shape.antialiased = NO;
    shape.lineWidth = 1;
    shape.strokeColor = color;
    
    CGPathRelease(path);
    
    [self addChild:shape];
    [_debugNodes addObject:shape];
}

+ (void) drawRayStart:(CGPoint)start dirction:(CGVector)dir
{
    [[Debug sharedDebug] drawRayStart:start dirction:dir color:[SKColor blueColor]];
}

+ (void) drawRayStart:(CGPoint)start dirction:(CGVector)dir color:(SKColor *)color
{
    [[Debug sharedDebug] drawRayStart:start dirction:dir color:color];
}

- (void)drawRayStart:(CGPoint)start dirction:(CGVector)dir color:(SKColor *)color
{
    CGPoint end = ccp(start.x + dir.dx, start.y + dir.dy);
    [self drawLineStart:start end:end color:color];
}

+ (void)drawParabolaStart:(CGPoint)start end:(CGPoint)end controlPoint1:(CGPoint)cp1 controlPoint2:(CGPoint)cp2
{
    [[Debug sharedDebug] drawParabolaStart:start end:end controlPoint1:(CGPoint)cp1 controlPoint2:(CGPoint)cp2 color:[SKColor blueColor]];
}

+ (void)drawParabolaStart:(CGPoint)start end:(CGPoint)end controlPoint1:(CGPoint)cp1 controlPoint2:(CGPoint)cp2 color:(UIColor *)color
{
    [[Debug sharedDebug] drawParabolaStart:start end:end controlPoint1:(CGPoint)cp1 controlPoint2:(CGPoint)cp2 color:color];
}

- (void) drawParabolaStart:(CGPoint)start end:(CGPoint)end controlPoint1:(CGPoint)cp1 controlPoint2:(CGPoint)cp2 color:(SKColor *)color
{
    if (!self.isEnable) return;
    
    CGMutablePathRef path =CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddCurveToPoint(path, NULL, cp1.x, cp1.y, cp2.x, cp2.y, end.x, end.y);
    
    SKShapeNode *shape = [SKShapeNode node];
    shape.path = path;
    shape.antialiased = NO;
    shape.lineWidth = 1;
    shape.strokeColor = color;
    
    CGPathRelease(path);
    
    [self addChild:shape];
    [_debugNodes addObject:shape];
}



@end