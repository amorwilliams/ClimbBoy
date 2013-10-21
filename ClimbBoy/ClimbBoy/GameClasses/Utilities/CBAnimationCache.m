//
//  CBAnimationCache.m
//  ClimbBoy
//
//  Created by Robin on 13-10-21.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CBAnimationCache.h"
#import "CBGraphicsUtilities.h"

@implementation CBAnimationCache

#pragma mark CCAnimationCache - Alloc, Init & Dealloc

static NSMutableDictionary *_animations;

DEFINE_SINGLETON_FOR_CLASS(CBAnimationCache)

+ (void)purgeSharedAnimationCache
{
    [_animations removeAllObjects];
}

-(id) init
{
	if( (self=[super init]) ) {
		_animations = [[NSMutableDictionary alloc] initWithCapacity: 20];
	}
    
	return self;
}

#pragma mark CCAnimationCache - load/get/del

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %p | num of animations =  %lu>", [self class], self, (unsigned long)[_animations count]];
}

- (void)addAnimation:(NSArray *)animation name:(NSString *)name
{
    [_animations setObject:animation forKey:name];
}

- (void)removeAnimationByName:(NSString *)name
{
    if( ! name )
		return;
    
	[_animations removeObjectForKey:name];
}

- (void)addAnimationsWithAtlas:(NSString *)atlasName fileBaseName:(NSString *)baseName name:(NSString *)name
{
    NSArray *animations = CBLoadFramesFromAtlas(atlasName, baseName);
    [self addAnimation:animations name:name];
}

@end
