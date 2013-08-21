//
//  SKNode(ClimbBoy).m
//  ClimbBoy
//
//  Created by Robin on 13-8-21.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "SKNode+CBExtension.h"
#import "SKView+CBExtension.h"

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
	if ([SKView showsPhysicsShapes])
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
			shape.lineWidth = 1.0;
			shape.glowWidth = 4.0;
			shape.strokeColor = [SKColor magentaColor];
		}
		[self addChild:shape];
	}
}

-(SKPhysicsBody*) physicsBodyWithEdgeLoopFromPath:(CGPathRef)path
{
	SKPhysicsBody* physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
	physicsBody.dynamic = NO;
	self.physicsBody = physicsBody;
	[self addPhysicsBodyDrawNodeWithPath:path];
	return physicsBody;
}

-(SKPhysicsBody*) physicsBodyWithEdgeChainFromPath:(CGPathRef)path
{
	SKPhysicsBody* physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
	physicsBody.dynamic = NO;
	self.physicsBody = physicsBody;
	[self addPhysicsBodyDrawNodeWithPath:path];
	return physicsBody;
}

-(SKPhysicsBody*) physicsBodyWithRectangleOfSize:(CGSize)size
{
	SKPhysicsBody* physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
	self.physicsBody = physicsBody;
	CGPathRef path = CGPathCreateWithRect(CGRectMake(-(size.width * 0.5), -(size.height * 0.5), size.width, size.height), nil);
	[self addPhysicsBodyDrawNodeWithPath:path];
	CGPathRelease(path);
	return physicsBody;
}

-(SKPhysicsBody *)physicsBodyWithCircleOfRadius:(CGFloat)radius
{
    SKPhysicsBody* physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
	self.physicsBody = physicsBody;
	CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, 0, 0, radius, 0, M_PI * 360, NO);
	[self addPhysicsBodyDrawNodeWithPath:path];
	CGPathRelease(path);
	return physicsBody;
}

@end
