//
//  CBDebug.h
//  ClimbBoy
//
//  Created by Robin on 13-9-19.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CBMacros.h"

@interface Debug : SKNode
{
    NSMutableArray *_debugNodes;
}

DEFINE_SINGLETON_FOR_HEADER(Debug)

@property (nonatomic, getter = isEnable) BOOL enable;

//must add into didEvaluateActions or didSimulatePhysics
+ (void) drawLineStart:(CGPoint)start end:(CGPoint)end;
+ (void) drawLineStart:(CGPoint)start end:(CGPoint)end color:(SKColor *)color;

+ (void) drawRayStart:(CGPoint)start dirction:(CGVector)dir;
+ (void) drawRayStart:(CGPoint)start dirction:(CGVector)dir color:(SKColor *)color;

+ (void) drawParabolaStart:(CGPoint)start end:(CGPoint)end controlPoint1:(CGPoint)cp1 controlPoint2:(CGPoint)cp2;
+ (void) drawParabolaStart:(CGPoint)start end:(CGPoint)end controlPoint1:(CGPoint)cp1 controlPoint2:(CGPoint)cp2 color:(SKColor *)color;


@end