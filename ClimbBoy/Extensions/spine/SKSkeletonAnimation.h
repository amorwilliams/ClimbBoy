//
//  SKSkeletonAnimation.h
//  ClimbBoy
//
//  Created by Robin on 13-9-12.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <spine/spine.h>
#import "SKSkeleton.h"


@interface SKSkeletonAnimation : SKSkeleton
{    
	NSMutableArray* _stateDatas;
}
@property (retain, nonatomic, readonly) NSMutableArray* states;

+ (id) skeletonWithData:(SkeletonData*)skeletonData ownsSkeletonData:(bool)ownsSkeletonData;
+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale;
+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale;

- (id) initWithData:(SkeletonData*)skeletonData ownsSkeletonData:(bool)ownsSkeletonData;
- (id) initWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale;
- (id) initWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale;

- (void) addAnimationState;
- (void) addAnimationState:(AnimationStateData*)stateData;
- (AnimationState*) getAnimationState:(int)stateIndex;
- (void) setAnimationStateData:(AnimationStateData*)stateData forState:(int)stateIndex;

- (void) setMixFrom:(NSString*)fromAnimation to:(NSString*)toAnimation duration:(float)duration;
- (void) setMixFrom:(NSString*)fromAnimation to:(NSString*)toAnimation duration:(float)duration forState:(int)stateIndex;

- (void) setAnimation:(NSString*)name loop:(bool)loop;
- (void) setAnimation:(NSString*)name loop:(bool)loop forState:(int)stateIndex;

- (void) addAnimation:(NSString*)name loop:(bool)loop afterDelay:(float)delay;
- (void) addAnimation:(NSString*)name loop:(bool)loop afterDelay:(float)delay forState:(int)stateIndex;

- (void) clearAnimation;
- (void) clearAnimationForState:(int)stateIndex;


@end
