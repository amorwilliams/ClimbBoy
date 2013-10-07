//
//  Map.m
//  ClimbBoy
//
//  Created by Robin on 13-10-6.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Map.h"

@implementation Map
@synthesize bounds = _bounds;

- (id)initWithWidth:(int)width height:(int)height
{
    self = [super init];
    if (self) {
        _grid = (bool **)malloc(sizeof(bool*) * width);
        for (int i = 0; i < width; i++) {
            _grid[i] = (bool *)malloc(sizeof(bool) * height);
        }
        
        _width = width;
        _height = height;
        _bounds = CGRectMake(0, 0, width, height);
    }
    return self;
}

//- (void)dealloc
//{
//    for (int x = 0; x < self.width; x++) {
//        for (int y = 0; y < self.height; y++) {
//            free((void *)_grid[x][y]);
//        }
//    }
//    free(_grid);
//}

- (BOOL)cellWithPoint:(CGPoint)point
{
    return _grid[(int)point.x][(int)point.y];

}

- (BOOL) hasAdjacentCell:(CGPoint)point inDirection:(GDirctionType)direction
{
    // Check that the location falls within the bounds of the map
    if ((point.x < 0) || (point.x >= self.width) || (point.y < 0) || (point.y >= self.height)) return false;
    
    // Check if there is an adjacent cell in the direction
    switch(direction)
    {
        case kGDirctionNorth:
            return point.y > 0;
        case kGDirctionSouth:
            return point.y < (self.height - 1);
        case kGDirctionWest:
            return point.x > 0;
        case kGDirctionEast:
            return point.x < (self.width - 1);
        default:
            return false;
    }
}

- (BOOL)pointIsOutsideBounds:(CGPoint)point
{
    return ((point.x < 0) || (point.x >= self.width)
            || (point.y < 0) || (point.y >= self.height));
}

- (BOOL)rectIsOutsideBounds:(CGRect)rect
{
    NSAssert((rect.size.width > 0) && (rect.size.height > 0), @"The Rect width or height can not be negative");
    
    return ((rect.origin.x < 0) || ((rect.origin.x + rect.size.width) >= self.width) ||
            (rect.origin.y < 0) || ((rect.origin.y + rect.size.height) >= self.height));
}

- (NSString *)description
{
    NSString *output = [NSString stringWithFormat:@"\n"];
    
    for (int y = self.height - 1; y >= 0; y--) {
        output = [NSString stringWithFormat:@"%@[", output];
        
        for (int x = 0; x < self.width; x++) {
            if (x < self.width - 1) {
                if (_grid[x][y]) {
                    output = [NSString stringWithFormat:@"%@%@-", output, @"X"];
                }
                else {
                    output = [NSString stringWithFormat:@"%@%@-", output, @"0"];
                }
            }
            else if (x < self.width) {
                if (_grid[x][y]) {
                    output = [NSString stringWithFormat:@"%@%@]\n", output, @"X"];
                }
                else {
                    output = [NSString stringWithFormat:@"%@%@]\n", output, @"0"];
                }
            }
        }
    }
    
    return output;
}




@end
