//
//  MapGenerator.h
//  ClimbBoy
//
//  Created by Robin on 13-10-6.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Map.h"

@interface MapNode : SKNode
{
    Map *_map;
}

- (void) generate;

@end
