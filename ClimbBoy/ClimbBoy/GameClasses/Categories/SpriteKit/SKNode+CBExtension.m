//
//  SKNode(ClimbBoy).m
//  ClimbBoy
//
//  Created by Robin on 13-8-21.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "SKNode+CBExtension.h"

@implementation SKNode (CBExtension)
@dynamic tag;


#pragma mark Tag

-(void)addChild:(SKNode *)node tag:(NSInteger)tag
{
    self.tag = tag;
    [self addChild:node];
}

-(void)insertChild:(SKNode *)node atIndex:(NSInteger)index tag:(NSInteger)tag
{
    self.tag = tag;
    [self insertChild:node atIndex:index];
}

-(void)removeChildByTag:(NSInteger)tag
{
    NSMutableArray *removeNodes = [NSMutableArray array];
    for (SKNode *node in self.children) {
        if (node.tag == tag) {
            [removeNodes addObject:node];
        }
    }
    
    if (removeNodes.count > 0) {
        [self removeChildrenInArray:removeNodes];
    }
}

-(NSArray *)getChildByTag:(NSInteger)tag
{
    NSMutableArray *nodes = [NSMutableArray array];
    for (SKNode *node in self.children) {
        if (node.tag == tag) {
            [nodes addObject:node];
        }
    }
    
    if (nodes.count > 0) {
        return nodes;
    }
    
    return nil;
}

-(void)removeActionByTag:(NSInteger)tag
{
    
}

#pragma mark Physics
-(void) addPhysicsBodyDrawNodeWithPath:(CGPathRef)path
{
	if ([KKView showsPhysicsShapes])
	{
		SKShapeNode* shape = [SKShapeNode node];
		shape.path = path;
		shape.antialiased = NO;
		if (self.physicsBody.dynamic)
		{
			shape.lineWidth = 1.0;
			shape.fillColor = [SKColor colorWithRed:1 green:0 blue:0.2 alpha:0.2];
		}
		else
		{
			shape.lineWidth = 2.0;
			shape.glowWidth = 4.0;
			shape.strokeColor = [SKColor magentaColor];
		}
		[self addChild:shape];
	}
}


-(SKPhysicsBody *)physicsBodyWithCircleOfRadius:(CGFloat)radius
{
    SKPhysicsBody* physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
	self.physicsBody = physicsBody;
	CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, 0, 0, radius, 0, M_PI * 2, NO);
    physicsBody.dynamic = YES;
    self.physicsBody = physicsBody;
	[self addPhysicsBodyDrawNodeWithPath:path];
	CGPathRelease(path);
	return physicsBody;
}

-(SKPhysicsBody *)physicsBodyWithCapsule:(CBCapsule)capsule
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, 0, capsule.height/2-capsule.radius, capsule.radius, 0, M_PI, NO);
    CGPathAddLineToPoint(path, NULL, -capsule.radius, -capsule.height + capsule.radius*3);
    CGPathAddArc(path, NULL, 0, -capsule.height/2 + capsule.radius, capsule.radius, -M_PI, 0, NO);
    CGPathCloseSubpath(path);
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    physicsBody.dynamic = YES;
    self.physicsBody = physicsBody;
    [self addPhysicsBodyDrawNodeWithPath:path];
    CGPathRelease(path);
    return physicsBody;
}

@dynamic flipX;
-(BOOL)flipX
{
    return self.xScale < 0 ? YES : NO;
}
- (void)setFlipX:(BOOL)b
{
    if (self.flipX == b) {
        return;
    }
    
    if (b) {
        self.xScale = -ABS(self.xScale);
    }else{
        self.xScale = ABS(self.xScale);
    }
}

@dynamic flipY;
-(BOOL)flipY
{
    return self.yScale < 0 ? YES : NO;
}
-(void)setFlipY:(BOOL)b
{
    if (self.flipY == b) {
        return;
    }
    
    if (b) {
        self.yScale = -ABS(self.yScale);
    }else{
        self.yScale = ABS(self.yScale);
    }
}

@end








