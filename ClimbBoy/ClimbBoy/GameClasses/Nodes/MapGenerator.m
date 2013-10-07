//
//  MapGenerator.m
//  ClimbBoy
//
//  Created by Robin on 13-10-6.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "MapGenerator.h"

@implementation MapGenerator


- (Dungeon *)generate
{
    Dungeon *map = [Dungeon dungeonWithWidth:10 height:10];
    CGPoint currentLocation = [map pickRandomCellAndMarkItVisited];
    
    NSLog(@"%@", [map description]);
    return map;
}

@end
