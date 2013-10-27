//
//  CBAnimationCache.h
//  ClimbBoy
//
//  Created by Robin on 13-10-21.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBMacros.h"

@interface CBAnimationCache : NSObject
{
    NSMutableDictionary *_animations;
}

DEFINE_SINGLETON_FOR_HEADER(CBAnimationCache)

/** Purges the cache. It releases all the CCAnimation objects and the shared instance.
 */
-(void)purgeSharedAnimationCache;

/** Adds a CCAnimation with a name.
 */
-(void) addAnimation:(NSArray*)animation name:(NSString*)name;

/** Deletes a CCAnimation from the cache.
 */
-(void) removeAnimationByName:(NSString*)name;

/** Returns a CCAnimation that was previously added.
 If the name is not found it will return nil.
 You should retain the returned copy if you are going to use it.
 */
-(NSArray*) animationByName:(NSString*)name;

/** Adds an animation from atlas by animation file name
 */
-(NSArray*)addAnimationsWithAtlas:(NSString*)atlasName fileBaseName:(NSString *)baseName;

/** Adds an animation from a plist file.
 Make sure that the frames were previously loaded in the CCSpriteFrameCache.
 @since v1.1
 */
//-(void)addAnimationsWithFile:(NSString *)plist;


@end
