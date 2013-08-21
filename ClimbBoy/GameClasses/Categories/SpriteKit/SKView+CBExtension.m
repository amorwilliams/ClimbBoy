//
//  SKView.m
//  ClimbBoy
//
//  Created by Robin on 13-8-21.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "SKView+CBExtension.h"

@implementation SKView (CBExtension)

#pragma mark Debug
static BOOL _showsPhysicsShapes = NO;
static BOOL _showsNodeFrames = NO;
static BOOL _showsNodeAnchorPoints = NO;

@dynamic showsPhysicsShapes;
+(BOOL) showsPhysicsShapes
{
	return _showsPhysicsShapes;
}
-(BOOL) showsPhysicsShapes
{
	return _showsPhysicsShapes;
}
-(void) setShowsPhysicsShapes:(BOOL)showsPhysicsShapes
{
	_showsPhysicsShapes = showsPhysicsShapes;
}

@dynamic showsNodeFrames;
+(BOOL) showsNodeFrames
{
	return _showsNodeFrames;
}
-(BOOL) showsNodeFrames
{
	return _showsNodeFrames;
}
-(void) setShowsNodeFrames:(BOOL)showsNodeFrames
{
	_showsNodeFrames = showsNodeFrames;
}

@dynamic showsNodeAnchorPoints;
+(BOOL) showsNodeAnchorPoints
{
	return _showsNodeAnchorPoints;
}
-(BOOL) showsNodeAnchorPoints
{
	return _showsNodeAnchorPoints;
}
-(void) setShowsNodeAnchorPoints:(BOOL)showsNodeAnchorPoints
{
	_showsNodeAnchorPoints = showsNodeAnchorPoints;
}


@end
