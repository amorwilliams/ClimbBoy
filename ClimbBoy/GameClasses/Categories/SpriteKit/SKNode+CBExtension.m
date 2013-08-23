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

#pragma mark Node Tree

-(void) didMoveToParent
{
	// to be overridden by subclasses
    
	if ([SKView showsNodeFrames])
	{
		SKShapeNode* shape = [SKShapeNode node];
		CGPathRef path = CGPathCreateWithRect(self.frame, nil);
		shape.path = path;
		CGPathRelease(path);
		shape.antialiased = NO;
		shape.lineWidth = 1.0;
		shape.strokeColor = [SKColor orangeColor];
		[self addChild:shape];
	}
	if ([SKView showsNodeAnchorPoints])
	{
		SKShapeNode* shape = [SKShapeNode node];
		CGRect center = CGRectMake(-1, -1, 2, 2);
		CGPathRef path = CGPathCreateWithRect(center, nil);
		shape.path = path;
		CGPathRelease(path);
		/*
         CGMutablePathRef path = CGPathCreateMutable();
         CGPathMoveToPoint(path, nil, self.position.x, self.position.y);
         CGPathAddLineToPoint(path, nil, self.position.x, self.position.y+1);
         shape.path = path;
		 */
		shape.antialiased = NO;
		shape.lineWidth = 1.0;
		[self addChild:shape];
		
		id sequence = [SKAction sequence:@[[SKAction runBlock:^{
			shape.strokeColor = [SKColor colorWithRed:CBRANDOM_0_1() green:CBRANDOM_0_1() blue:CBRANDOM_0_1() alpha:1.0];
		}], [SKAction waitForDuration:0.2]]];
		[shape runAction:[SKAction repeatActionForever:sequence]];
	}
}

- (void)willMoveFromParent {
    
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
    physicsBody.dynamic = NO;
    self.physicsBody = physicsBody;
	[self addPhysicsBodyDrawNodeWithPath:path];
	CGPathRelease(path);
	return physicsBody;
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

@end








