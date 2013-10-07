//
//  Map.h
//  ClimbBoy
//
//  Created by Robin on 13-10-6.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
////*************************** CGPoint  *********************************
//struct CGPoint {
//    int x;
//    int y;
//};
//typedef struct CGPoint CGPoint;
//
//static inline CGPoint
//CGPointMake(int x, int y)
//{
//    CGPoint p; p.x = x; p.y = y; return p;
//}
//
//static inline bool
//CGPointEqualToPoint(CGPoint point1, CGPoint point2)
//{
//    return point1.x == point2.x && point1.y == point2.y;
//}

//************************************************************


typedef enum : uint8_t{
    kGDirctionNorth = 0,
    kGDirctionSouth,
    kGDirctionWest,
    kGDirctionEast,
}GDirctionType;

@interface Map : NSObject
{
    @protected
    bool **_grid;
    CGRect _bounds;
}

@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;
@property (nonatomic, readonly) CGRect bounds;

- (id) initWithWidth:(int)width height:(int)height;

- (BOOL) cellWithPoint:(CGPoint)point;
- (BOOL) hasAdjacentCell:(CGPoint)point inDirection:(GDirctionType)direction;
- (BOOL) pointIsOutsideBounds:(CGPoint)point;
- (BOOL) rectIsOutsideBounds:(CGRect)rect;
@end
