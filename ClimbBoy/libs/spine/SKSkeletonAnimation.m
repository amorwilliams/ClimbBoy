//
//  SKSkeletonAnimation.m
//  ClimbBoy
//
//  Created by Robin on 13-9-12.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "SKSkeletonAnimation.h"

@implementation SKSkeletonAnimation

+ (id) skeletonWithData:(SkeletonData*)skeletonData ownsSkeletonData:(bool)ownsSkeletonData {
	return [[SKSkeletonAnimation alloc] initWithData:skeletonData ownsSkeletonData:ownsSkeletonData];
}

+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale {
	return [[SKSkeletonAnimation alloc] initWithFile:skeletonDataFile atlas:atlas scale:scale];
}

+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale {
	return [[SKSkeletonAnimation alloc] initWithFile:skeletonDataFile atlasFile:atlasFile scale:scale];
}

- (id) initWithData:(SkeletonData*)skeletonData ownsSkeletonData:(bool)ownsSkeletonData {
	self = [super initWithData:skeletonData ownsSkeletonData:ownsSkeletonData];
	if (!self) return nil;
	
	[self initialize];
	
	return self;
}

- (id) initWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale {
	self = [super initWithFile:skeletonDataFile atlas:atlas scale:scale];
	if (!self) return nil;
	
	[self initialize];
	
	return self;
}

- (id) initWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale {
	self = [super initWithFile:skeletonDataFile atlasFile:atlasFile scale:scale];
	if (!self) return nil;
	
	[self initialize];
	
	return self;
}

- (void) initialize {
	_states = [NSMutableArray arrayWithCapacity:2];
	_stateDatas = [NSMutableArray arrayWithCapacity:2];
    [self addAnimationState];
    
    [self setToSetupPose];
    [self setupAttachmentSprites];
}

- (void) dealloc {
	for (NSValue* value in _stateDatas)
		AnimationStateData_dispose([value pointerValue]);
	
	for (NSValue* value in _states)
		AnimationState_dispose([value pointerValue]);
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)delta {
    [super updateWithTimeSinceLastUpdate:delta];
    
    delta *= _timeScale;
	for (NSValue* value in _states) {
		AnimationState* state = [value pointerValue];
		AnimationState_update(state, delta);
		AnimationState_apply(state, _skeleton);
	}
	Skeleton_updateWorldTransform(_skeleton);
    
    [self updateAttachmentSprites];
}

- (void) addAnimationState {
	AnimationStateData* stateData = AnimationStateData_create(_skeleton->data);
	[_stateDatas addObject:[NSValue valueWithPointer:stateData]];
	[self addAnimationState:stateData];
}

- (void) addAnimationState:(AnimationStateData*)stateData {
	NSAssert(stateData, @"stateData cannot be null.");
	AnimationState* state = AnimationState_create(stateData);
	[_states addObject:[NSValue valueWithPointer:state]];
}

- (AnimationState*) getAnimationState:(int)stateIndex {
	NSAssert(stateIndex >= 0 && stateIndex < (int)_states.count, @"stateIndex out of range.");
	return [[_states objectAtIndex:stateIndex] pointerValue];
}

- (void) setAnimationStateData:(AnimationStateData*)stateData forState:(int)stateIndex {
	NSAssert(stateData, @"stateData cannot be null.");
	NSAssert(stateIndex >= 0 && stateIndex < (int)_states.count, @"stateIndex out of range.");
	
	AnimationState* state = [[_states objectAtIndex:stateIndex] pointerValue];
	for (NSValue* value in _stateDatas) {
		if (state->data == [value pointerValue]) {
			AnimationStateData_dispose(state->data);
			[_stateDatas removeObject:value];
			break;
		}
	}
	[_states removeObject:[NSValue valueWithPointer:state]];
	AnimationState_dispose(state);
    
	state = AnimationState_create(stateData);
	[_states setObject:[NSValue valueWithPointer:state] atIndexedSubscript:stateIndex];
}

- (void) setMixFrom:(NSString*)fromAnimation to:(NSString*)toAnimation duration:(float)duration {
	[self setMixFrom:fromAnimation to:toAnimation duration:duration forState:0];
}

- (void) setMixFrom:(NSString*)fromAnimation to:(NSString*)toAnimation duration:(float)duration forState:(int)stateIndex {
	NSAssert(stateIndex >= 0 && stateIndex < (int)_states.count, @"stateIndex out of range.");
	AnimationState* state = [[_states objectAtIndex:stateIndex] pointerValue];
	AnimationStateData_setMixByName(state->data, [fromAnimation UTF8String], [toAnimation UTF8String], duration);
}

- (void) setAnimation:(NSString*)name loop:(bool)loop {
	[self setAnimation:name loop:loop forState:0];
}

- (void) setAnimation:(NSString*)name loop:(bool)loop forState:(int)stateIndex {
	NSAssert(stateIndex >= 0 && stateIndex < (int)_states.count, @"stateIndex out of range.");
	AnimationState* state = [[_states objectAtIndex:stateIndex] pointerValue];
	AnimationState_setAnimationByName(state, [name UTF8String], loop);
}

- (void) addAnimation:(NSString*)name loop:(bool)loop afterDelay:(float)delay {
	[self addAnimation:name loop:loop afterDelay:delay forState:0];
}

- (void) addAnimation:(NSString*)name loop:(bool)loop afterDelay:(float)delay forState:(int)stateIndex {
	NSAssert(stateIndex >= 0 && stateIndex < (int)_states.count, @"stateIndex out of range.");
	AnimationState* state = [[_states objectAtIndex:stateIndex] pointerValue];
	AnimationState_addAnimationByName(state, [name UTF8String], loop, delay);
}

- (void) clearAnimation {
	[self clearAnimationForState:0];
}

- (void) clearAnimationForState:(int)stateIndex {
	NSAssert(stateIndex >= 0 && stateIndex < (int)_states.count, @"stateIndex out of range.");
	AnimationState* state = [[_states objectAtIndex:stateIndex] pointerValue];
	AnimationState_clearAnimation(state);
}



@end
