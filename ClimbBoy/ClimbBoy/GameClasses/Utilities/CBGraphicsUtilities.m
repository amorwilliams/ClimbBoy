//
//  CBGraphicsUtilities.m
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "CBGraphicsUtilities.h"


#pragma mark - Loading from a Texture Atlas
NSArray *CBLoadFramesFromAtlas(NSString *atlasName, NSString *baseFileName) {
    NSMutableArray *frames = [NSMutableArray array];
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    for (int i = 1; i <= atlas.textureNames.count; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@%04d.png", baseFileName, i];
        SKTexture *texture = [atlas textureNamed:fileName];
        [frames addObject:texture];
    }
    
    NSLog(@"%@ : %d", atlasName, frames.count);
    
    return frames;
}