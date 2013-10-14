//
//  CameraFollowBehavior.m
//  ClimbBoy
//
//  Created by Robin on 13-10-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CameraFollowBehavior.h"
#import "GameplayScene.h"

@implementation CameraFollowBehavior

-(void) didJoinController
{
	[self.node.kkScene addSceneEventsObserver:self];
    
	// defaults to parent's parent (in a tilemap hierarchy this is the tile layer of the object)
	if (_scrollingNode == nil)
	{
		_scrollingNode = self.node.parent.parent;
	}
    
	// update once immediately
	[self didSimulatePhysics];
}

-(void) didLeaveController
{
	[self.node.kkScene removeSceneEventsObserver:self];
}

-(void) didSimulatePhysics
{
	if (_scrollingNode)
	{
		SKNode* node = self.node;
//        GameplayScene* map = (GameplayScene *)node.scene;
		CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:_scrollingNode];
		CGPoint pos = CGPointMake(_scrollingNode.position.x - cameraPositionInScene.x,
								  _scrollingNode.position.y - cameraPositionInScene.y);
		_scrollingNode.position = pos;
	}
}

@end
