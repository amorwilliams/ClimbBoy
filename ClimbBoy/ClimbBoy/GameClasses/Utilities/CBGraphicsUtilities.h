//
//  CBGraphicsUtilities.h
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Load the named frames in a texture atlas into an array of frames. */
NSArray *CBLoadFramesFromAtlas(NSString *atlasName, NSString *baseFileName);


static inline CGPoint ccpClampMagnitude(CGPoint v, float lenght)
{
    if (ccpLengthSQ(v) > lenght * lenght) {
        return ccpMult(ccpNormalize(v), lenght);
    }
    return v;
}