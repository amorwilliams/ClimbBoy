//
//  PlaceItemBehavior.h
//  ClimbBoy
//
//  Created by Robin on 13-10-2.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKBehavior.h"

static const float PlaceRange = 200;

static inline CGPoint ccpClampMagnitude(CGPoint v, float lenght)
{
    if (ccpLengthSQ(v) > lenght * lenght) {
        return ccpMult(ccpNormalize(v), lenght);
    }
    return v;
}

@interface PlaceItemBehavior : KKBehavior
{
    BOOL _isPlacing;
    int _trackedTouch;
    CGPoint _touchLocation;
}

@property (nonatomic, weak) SKNode *item;
@property (nonatomic, readonly) CGPoint placePoint;
@property (nonatomic, readonly) CGVector placePointNormal;

@end
