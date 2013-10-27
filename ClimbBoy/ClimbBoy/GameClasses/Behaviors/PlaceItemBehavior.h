//
//  PlaceItemBehavior.h
//  ClimbBoy
//
//  Created by Robin on 13-10-2.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKBehavior.h"

@interface PlaceItemBehavior : KKBehavior
{
    BOOL _isPlacing;
//    int _trackedTouch;
    CGPoint _touchLocation;
    
    CGPoint _startPoint;
    CGPoint _endPoint;
    CGPoint _controlPoint1;
    CGPoint _controlPoint2;
}

@property (nonatomic, weak) SKNode *item;
@property (nonatomic) NSUInteger trackedTouch;
@property (nonatomic) CGFloat placeRange;
@property (nonatomic, readonly) CGPoint placePoint;
@property (nonatomic, readonly) CGVector placePointNormal;

@end
