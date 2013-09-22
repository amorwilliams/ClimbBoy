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

- (void)didMoveToParent {
        self.zPosition = 100;
        _enable = YES;
        [self observeSceneEvents];
    }

- (void)willMoveFromParent {
        _enable = NO;
        [self disregardSceneEvents];
    }

- (void)update:(NSTimeInterval)currentTime {
        if (![self isEnable]) {
                return;
            }
    
        for (int i = 0; i < _debugNodes.count; i++) {
                SKNode *node = [_debugNodes objectAtIndex:i];
                [node removeFromParent];
            }
    
        [_debugNodes removeAllObjects];
    }


+ (void) drawLineStart:(CGPoint)start end:(CGPoint)end {
        [[Debug sharedDebug] drawLineStart:start end:end];
    }


+ (void) drawLineStart:(CGPoint)start end:(CGPoint)end color:(SKColor *)color {
        [[Debug sharedDebug] drawLineStart:start end:end color:color];
    }

+ (void) drawRayStart:(CGPoint)start dirction:(CGVector)dir {
    
    }

+ (void) drawRayStart:(CGPoint)start dirction:(CGVector)dir color:(SKColor *)color {
    
    }

- (void) drawLineStart:(CGPoint)start end:(CGPoint)end {
        [self drawLineStart:start end:end color:[SKColor blueColor]];
    }


- (void) drawLineStart:(CGPoint)start end:(CGPoint)end color:(SKColor *)color {
        if (![self isEnable]) {
                return;
            }
    
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



@end