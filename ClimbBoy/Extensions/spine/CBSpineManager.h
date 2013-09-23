//
//  CBSpineManager.h
//  ClimbBoy
//
//  Created by Robin on 13-9-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <spine/spine.h>

@interface CBSpineManager : NSObject
{
    NSMutableDictionary *_skeletons;
}
+ (CBSpineManager *)sharedManager;
- (SkeletonData *) LoadSpineFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale;
- (SkeletonData *) LoadSpineFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale;

- (SkeletonData *)getSkeletonDataByName:(NSString *)name;
@end
