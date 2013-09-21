//
//  CBSpineManager.m
//  ClimbBoy
//
//  Created by Robin on 13-9-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CBSpineManager.h"

@implementation CBSpineManager

static CBSpineManager *sharedSpineManager = nil;
+ (CBSpineManager *)sharedManager
{
    @synchronized(self) {
        if (sharedSpineManager == nil) {
            sharedSpineManager = [[self alloc] init]; // assignment not done here
        }
    }
    return sharedSpineManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _skeletons = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    for (NSValue *value in _skeletons) {
        Skeleton_dispose([value pointerValue]);
    }
}


- (SkeletonData *) LoadSpineFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale {
    NSString *name = [skeletonDataFile stringByDeletingPathExtension];
    if (![_skeletons objectForKey:name]) {
        SkeletonJson* json = SkeletonJson_create(atlas);
        json->scale = scale;
        SkeletonData* skeletonData = SkeletonJson_readSkeletonDataFile(json, [skeletonDataFile UTF8String]);
        NSAssert(skeletonData, ([NSString stringWithFormat:@"Error reading skeleton data file: %@\nError: %s", skeletonDataFile, json->error]));
        SkeletonJson_dispose(json);
        
        [_skeletons setValue:[NSValue valueWithPointer:skeletonData] forKey:name];
        return skeletonData;
    }else{
        NSLog(@"Skeleton already exists for name %@", name);
    }
    return nil;
}

- (SkeletonData *) LoadSpineFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale {
    NSString *name = [skeletonDataFile stringByDeletingPathExtension];
    if (![_skeletons objectForKey:name]) {
        Atlas *atlas = Atlas_readAtlasFile([atlasFile UTF8String]);
        NSAssert(atlas, ([NSString stringWithFormat:@"Error reading atlas file: %@", atlasFile]));
        
        SkeletonJson* json = SkeletonJson_create(atlas);
        json->scale = scale;
        SkeletonData* skeletonData = SkeletonJson_readSkeletonDataFile(json, [skeletonDataFile UTF8String]);
        NSAssert(skeletonData, ([NSString stringWithFormat:@"Error reading skeleton data file: %@\nError: %s", skeletonDataFile, json->error]));
        SkeletonJson_dispose(json);
        
        [_skeletons setValue:[NSValue valueWithPointer:skeletonData] forKey:name];
        return skeletonData;
    }else{
        NSLog(@"Skeleton already exists for name %@", name);
    }
    return nil;
}

- (SkeletonData *)getSkeletonDataByName:(NSString *)name {
    return (__bridge SkeletonData *)([_skeletons objectForKey:name]);
}

@end
