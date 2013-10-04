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
#import "CBGraphicsUtilities.h"

#define DEFAULT_PLACE_RANGE 200;

@implementation PlaceItemBehavior

- (void)didInitialize
{
    _placeRange = DEFAULT_PLACE_RANGE;
}

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

- (void) update:(NSTimeInterval)currentTime
{
    if (_item) {
        [self updatePlaceFromLocation:(CGPoint)_touchLocation];
    }
}

- (void)updatePlaceFromLocation:(CGPoint)location
{
    _isPlacing = NO;
    _placePointNormal = CGVectorZero;
    SKPhysicsWorld *physicsWorld = self.node.kkScene.physicsWorld;
    
    CGPoint nodePos = [self.node convertPoint:CGPointZero toNode:self.node.kkScene];
    CGPoint rayStart = [self.node convertPoint:location toNode:self.node.kkScene];
    rayStart = ccpClampMagnitude(ccpSub(rayStart, nodePos), _placeRange);
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
        
        _startPoint = nodePos;
        _endPoint = _placePoint;
        _controlPoint1 = _startPoint;
        _controlPoint2 = ccp(_startPoint.x+(_endPoint.x-_startPoint.x)*0.5, _startPoint.y+(_endPoint.y-_startPoint.y)*0.5 + (location.y - _placePoint.y));
        
        float dot = ccvDot(_placePointNormal, ccv(0, 1));
        if (dot < -0.5 )
        {
            _controlPoint2.y = _endPoint.y + dot * 50;
        }
        else if (dot > 0.5)
        {
            _controlPoint2.y = _controlPoint2.y * dot;
        }
        else
        {
            _controlPoint2.y = MAX(_controlPoint2.y, _startPoint.y);
        }
        
        [Debug drawParabolaStart:_startPoint end:_endPoint controlPoint1:_controlPoint1 controlPoint2:_controlPoint2 color:[SKColor colorWithRed:0.8 green:0.2 blue:0.4 alpha:0.8]];
        
        if ([_item isKindOfClass:[SKSpriteNode class]]) {
            SKSpriteNode *placedNode = (SKSpriteNode *)_item;
            _placePoint = ccpAdd(_placePoint, ccpCompMult(ccp(_placePointNormal.dx, _placePointNormal.dy),
                                                          ccp(placedNode.size.width * placedNode.anchorPoint.x,
                                                              placedNode.size.height * placedNode.anchorPoint.y)));
        }
    }
    else
    {
        _placePoint = [self.node convertPoint:location toNode:self.node.kkScene];
    }
    
    _placePoint = [_item.parent convertPoint:_placePoint fromNode:self.node.kkScene];
    _item.position = _placePoint;
}

- (void)setItem:(SKNode *)item
{
    if (!_item && self.enabled) {
        _item = item;
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
                if (!_isPlacing)
                {
                    [_item removeFromParent];
                }
                else
                {
                    CGPoint s = [_item.parent convertPoint:_startPoint fromNode:self.node.kkScene];
                    CGPoint e = _placePoint;
                    CGPoint c1 = s;
                    CGPoint c2 = [_item.parent convertPoint:_controlPoint2 fromNode:self.node.kkScene];
                    
                    CGMutablePathRef path =CGPathCreateMutable();
                    CGPathMoveToPoint(path, NULL, s.x, s.y);
                    CGPathAddCurveToPoint(path, NULL, c1.x, c1.y, c2.x, c2.y, e.x, e.y);
                    float time = (ccpDistance(s, e) + (c2.y - ccpMidpoint(s, e).y)) * 0.003;
                    [_item runAction:[SKAction sequence:@[[SKAction followPath:path asOffset:NO orientToPath:NO duration:time],
                                                          [SKAction moveTo:_placePoint duration:0.1]]]];
                    
                    /*
                    SKShapeNode *shape = [SKShapeNode node];
                    shape.path = path;
                    shape.antialiased = NO;
                    shape.lineWidth = 1;
                    shape.strokeColor = [SKColor greenColor];
                    [_item.parent addChild:shape];
                     */
                    
                    CGPathRelease(path);
                }
                _item = nil;
                _trackedTouch = 0;
				break;
			}
		}
	}
}

#else // Mac OS X

#endif


#pragma mark !! Update methods below whenever class layout changes !!
#pragma mark NSCoding

/*
 static NSString* const ArchiveKeyForOtherNode = @"otherNode";
 
 -(id) initWithCoder:(NSCoder*)decoder
 {
 self = [super init];
 if (self)
 {
 _target = [decoder decodeObjectForKey:ArchiveKeyForOtherNode];
 _positionOffset = [decoder decodeCGPointForKey:ArchiveKeyForPositionOffset];
 _positionMultiplier = [decoder decodeCGPointForKey:ArchiveKeyForPositionMultiplier];
 }
 return self;
 }
 
 -(void) encodeWithCoder:(NSCoder*)encoder
 {
 [encoder encodeObject:_target forKey:ArchiveKeyForOtherNode];
 [encoder encodeCGPoint:_positionOffset forKey:ArchiveKeyForPositionOffset];
 [encoder encodeCGPoint:_positionMultiplier forKey:ArchiveKeyForPositionMultiplier];
 }
 */
#pragma mark NSCopying

-(id) copyWithZone:(NSZone*)zone
{
    PlaceItemBehavior* copy = [[super copyWithZone:zone] init];
    copy->_isPlacing = _isPlacing;
    copy->_trackedTouch = _trackedTouch;
    copy->_touchLocation = _touchLocation;
    copy->_item = _item;
    copy->_placeRange = _placeRange;
    copy->_placePoint = _placePoint;
    copy->_placePointNormal = _placePointNormal;
    return copy;
}

/*
 #pragma mark Equality
 
 -(BOOL) isEqualToBehavior:(KKBehavior*)behavior
 {
 if ([self isMemberOfClass:[behavior class]] == NO)
 return NO;
 return NO;
 }
*/

@end
