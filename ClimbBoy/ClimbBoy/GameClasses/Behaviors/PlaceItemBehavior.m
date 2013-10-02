//
//  PlaceItemBehavior.m
//  ClimbBoy
//
//  Created by Robin on 13-10-2.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "PlaceItemBehavior.h"
#import "Entity.h"
#import "Debug.h"

@implementation PlaceItemBehavior

- (void)didJoinController
{
    [self.node.kkScene addSceneEventsObserver:self];
    [self.node.kkScene addInputEventsObserver:self];
}

- (void)didLeaveController
{
    [self.node.kkScene removeInputEventsObserver:self];
    [self.node.kkScene removeSceneEventsObserver:self];
    _trackedTouch = 0;
}

- (void)updatePlaceFromLocation:(CGPoint)location
{
    _isPlacing = NO;
    _placePointNormal = CGVectorZero;
    SKPhysicsWorld *physicsWorld = self.node.kkScene.physicsWorld;
    
    CGPoint nodePos = [self.node convertPoint:CGPointZero toNode:self.node.kkScene];
    CGPoint rayStart = [self.node convertPoint:location toNode:self.node.kkScene];
    rayStart = ccpClampMagnitude(ccpSub(rayStart, nodePos), PlaceRange);
    rayStart = ccpAdd(nodePos, rayStart);
    CGPoint rayEnd = ccp(rayStart.x, rayStart.y-1000);
    
//    [Debug drawLineStart:rayStart end:nodePos];
    
    [physicsWorld enumerateBodiesAlongRayStart:nodePos end:rayStart usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
        if (body.categoryBitMask & kContactCategoryStaticObject) {
            _isPlacing = YES;
            _placePoint = point;
            _placePointNormal = ccvNormalize(normal);
            *stop = YES;
        }
    }];
    
    if (_isPlacing){
        if (ccvDot(_placePointNormal, ccv(0, 1)) > -0.5 ) {
            location = ccp(_placePoint.x, _placePoint.y + 50) ;
        }
    }
    else{
        rayStart.y = MAX(rayStart.y, nodePos.y);
        [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
            if (body.categoryBitMask & kContactCategoryStaticObject) {
                if (ccvDot(ccvNormalize(normal), ccv(0, 1)) > 0.5) {
                    _isPlacing = YES;
                    _placePoint = point;
                    _placePointNormal = ccvNormalize(normal);
                }
                *stop = YES;
            }
        }];
    }
    
    if (_isPlacing) {
//        [Debug drawLineStart:rayStart end:_placePoint];
        [Debug drawRayStart:_placePoint dirction:ccvMult(_placePointNormal, 30) color:[SKColor yellowColor]];
        
        CGPoint s = nodePos;
        CGPoint e = _placePoint;
        CGPoint c1 = s;
        CGPoint c2 = ccp(s.x+(e.x-s.x)*0.5, s.y+(e.y-s.y)*0.5 + (location.y - _placePoint.y));
        
        float dot = ccvDot(_placePointNormal, ccv(0, 1));
        if (dot < -0.5 )
        {
            c2.y = e.y + dot * 50;
        }
        else if (dot > 0.5)
        {
            c2.y = c2.y * dot;
        }
        else
        {
            c2.y = MAX(c2.y, s.y);
        }
        [Debug drawParabolaStart:s end:e controlPoint1:c1 controlPoint2:c2 color:[SKColor colorWithRed:0.8 green:0.2 blue:0.4 alpha:0.8]];
        
        
        if ([_item isKindOfClass:[SKSpriteNode class]]) {
            SKSpriteNode *placedNode = (SKSpriteNode *)_item;
            _placePoint = ccpAdd(_placePoint, ccp(placedNode.size.width * placedNode.anchorPoint.x, placedNode.size.height * placedNode.anchorPoint.y));
        }
    }
    else
    {
        _placePoint = [self.node convertPoint:location toNode:self.node.kkScene];
    }
    
    _placePoint = [_item.parent convertPoint:_placePoint fromNode:self.node.kkScene];
    _item.position = _placePoint;
}

-(void) update:(NSTimeInterval)currentTime
{
    if (_item) {
        [self updatePlaceFromLocation:(CGPoint)_touchLocation];
    }
}

#pragma mark Input Events

#if TARGET_OS_IPHONE
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.enabled && !_item)
	{
		for (UITouch* touch in touches)
		{
            if (_trackedTouch)
            {
                NSLog(@"ALERT: pad already tracking touch: %x (new touch: %p)", _trackedTouch, touch);
            }
            else
            {
                _trackedTouch = (NSUInteger)touch;
                _touchLocation = [touch locationInNode:self.node];
            }

            break;
		}
	}
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_trackedTouch)
	{
		for (UITouch* touch in touches)
		{
			if ((NSUInteger)touch == _trackedTouch)
			{
//				[self updatePlaceFromLocation:[touch locationInNode:self.node]];
                _touchLocation = [touch locationInNode:self.node];
			}
		}
	}
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"pad touches cancelled");
	[self touchesEnded:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_trackedTouch)
	{
		for (UITouch* touch in touches)
		{
			//NSLog(@"pad trying end touch: %p", touch);
			if ((NSUInteger)touch == _trackedTouch)
			{
				//NSLog(@"pad touches ended: reset...");
                if (_item) {
//                    [_item removeFromParent];
                    _item = nil;
                }
                _trackedTouch = 0;
				break;
			}
		}
	}
}

#else // Mac OS X

#endif



@end
