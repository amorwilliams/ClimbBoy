//
//  CBSpineSprite.m
//  ClimbBoy
//
//  Created by Robin on 13-9-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CBSpineSprite.h"
#import "CBSpineManager.h"

@implementation CBSpineSprite

+ (id) skeletonWithName:(NSString *)name {
    return [[CBSpineSprite alloc] initWithName:name];
}

+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale {
	return [[CBSpineSprite alloc] initWithFile:skeletonDataFile atlas:atlas scale:scale];
}

+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale {
	return [[CBSpineSprite alloc] initWithFile:skeletonDataFile atlasFile:atlasFile scale:scale];
}

- (id) initWithName:(NSString *)name {
    self = [super init];
	if (self) {
        SkeletonData *skeletonData = [[CBSpineManager sharedManager] getSkeletonDataByName:name];
        NSAssert(skeletonData, @"Can not find skeleton data");
        
        [self initialize:skeletonData];
    }
    
	return self;
}

- (id) initWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale {
	self = [super init];
	if (self) {
        NSString *name = [skeletonDataFile stringByDeletingPathExtension];
        SkeletonData *skeletonData = [[CBSpineManager sharedManager] getSkeletonDataByName:name];
        if (skeletonDataFile) {
            skeletonData = [[CBSpineManager sharedManager] LoadSpineFile:skeletonDataFile atlas:atlas scale:scale];
        }
        NSAssert(skeletonData, @"Can not find skeleton data");

        [self initialize:skeletonData];
    }
    
	return self;
}

- (id) initWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale {
	self = [super init];
	if (self) {
        NSString *name = [skeletonDataFile stringByDeletingPathExtension];
        SkeletonData *skeletonData = [[CBSpineManager sharedManager] getSkeletonDataByName:name];
        if (skeletonDataFile) {
            skeletonData = [[CBSpineManager sharedManager] LoadSpineFile:skeletonDataFile atlasFile:atlasFile scale:scale];
        }
        
        NSAssert(skeletonData, @"Can not find skeleton data");
        
        [self initialize:skeletonData];
    }
    
	return self;
}

- (void) initialize:(SkeletonData*)skeletonData {
	_skeleton = Skeleton_create(skeletonData);
	_rootBone = _skeleton->bones[0];
	_animationTimeScale = 1;
    _prevAnimationTimeScale = 0;
    _isAnimationPaused = NO;
    _slotNodes = [NSMutableArray arrayWithCapacity:2];
    _states = [NSMutableArray arrayWithCapacity:2];
	_stateDatas = [NSMutableArray arrayWithCapacity:2];
    
//    if (_skeleton->data->skinCount > 0) {
//        [self setSkin:@(_skeleton->data->skins[0]->name)];
//    }
    
    [self buildSkeleton];
}

- (void) dealloc {
	SkeletonData_dispose(_skeleton->data);
	Skeleton_dispose(_skeleton);
    
    for (NSValue* value in _stateDatas)
		AnimationStateData_dispose([value pointerValue]);
	
	for (NSValue* value in _states)
		AnimationState_dispose([value pointerValue]);
}

- (void)didMoveToParent {
    [self observeSceneEvents];
}

- (void)buildSkeleton {
    NSAssert(_skeleton, @"skeleton can not be null");
    
    [self updateWorldTransform];
    
    for (int i = 0; i < _skeleton->slotCount; i++) {
        CBSpineSlot *slotNode = [CBSpineSlot slotNodeWithSlot:_skeleton->slots[i]];
        [_slotNodes addObject:slotNode];
        [self addChild:slotNode];
    }
    
    [self addAnimationState];
}


#pragma mark - Loop Update
- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - _lastUpdateTimeInterval;
    _lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1/60.0;
        _lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)delta {
    // is the animation currently playing? then update the bone positions and slot data
	for (NSValue* value in _states) {
		AnimationState* state = [value pointerValue];
        if (!AnimationState_isComplete(state) || state->loop) {
            Skeleton_update(_skeleton, delta * _animationTimeScale);
            AnimationState_update(state, delta * _animationTimeScale);
            AnimationState_apply(state, _skeleton);
            _isSpineDirty = YES;
        }
	}
    
    [self updateSprites];
}

- (void)updateSprites {
    if (_isSpineDirty) {
        _isSpineDirty = NO;
        [self updateWorldTransform];
        
        for (int i = 0; i < _skeleton->slotCount; i++) {
            CBSpineSlot *slotNode = (CBSpineSlot *)_slotNodes[i];
            [slotNode updateSlot:_skeleton->slots[i]];
        }
    }
}

#pragma mark -  Methods wrapper

- (void) updateWorldTransform {
	Skeleton_updateWorldTransform(_skeleton);
}

- (void) setToSetupPose {
	Skeleton_setToSetupPose(_skeleton);
}
- (void) setBonesToSetupPose {
	Skeleton_setBonesToSetupPose(_skeleton);
}
- (void) setSlotsToSetupPose {
	Skeleton_setSlotsToSetupPose(_skeleton);
}

- (Bone*) findBone:(NSString*)boneName {
	return Skeleton_findBone(_skeleton, [boneName UTF8String]);
}

- (Slot*) findSlot:(NSString*)slotName {
	return Skeleton_findSlot(_skeleton, [slotName UTF8String]);
}

#pragma mark - Skin

- (bool) setSkin:(NSString*)skinName {
	bool ret = (bool)Skeleton_setSkinByName(_skeleton, skinName ? [skinName UTF8String] : 0);
    if (ret) {
        for (int i = 0; i < _slotNodes.count; i++) {
            CBSpineSlot *slotNode = _slotNodes[i];
            [slotNode removeAttachment];
        }
        
        [self setToSetupPose];
        [self updateWorldTransform];

        _isSpineDirty = YES;
        [self updateSprites];
    }
    return ret;
}

#pragma mark - Attachment

- (Attachment*) getAttachment:(NSString*)slotName attachmentName:(NSString*)attachmentName {
	return Skeleton_getAttachmentForSlotName(_skeleton, [slotName UTF8String], [attachmentName UTF8String]);
}

- (bool) setAttachment:(NSString*)slotName attachmentName:(NSString*)attachmentName {
	return (bool)Skeleton_setAttachment(_skeleton, [slotName UTF8String], [attachmentName UTF8String]);
}

#pragma mark - Animation methods
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

- (void) playAnimation:(NSString*)name loop:(bool)loop {
	[self playAnimation:name loop:loop forState:0];
}

- (void) playAnimation:(NSString*)name loop:(bool)loop forState:(int)stateIndex {
	NSAssert(stateIndex >= 0 && stateIndex < (int)_states.count, @"stateIndex out of range.");
	AnimationState* state = [[_states objectAtIndex:stateIndex] pointerValue];
	AnimationState_setAnimationByName(state, [name UTF8String], loop);
}

- (void) queueAnimation:(NSString*)name loop:(bool)loop afterDelay:(float)delay {
	[self queueAnimation:name loop:loop afterDelay:delay forState:0];
}

- (void) queueAnimation:(NSString*)name loop:(bool)loop afterDelay:(float)delay forState:(int)stateIndex {
	NSAssert(stateIndex >= 0 && stateIndex < (int)_states.count, @"stateIndex out of range.");
	AnimationState* state = [[_states objectAtIndex:stateIndex] pointerValue];
	AnimationState_addAnimationByName(state, [name UTF8String], loop, delay);
}

- (void) pauseAnimation {
    if(!_isAnimationPaused){
        _isAnimationPaused = true;
        _prevAnimationTimeScale = _animationTimeScale;
        _animationTimeScale = 0.0f;
    }
}

- (void) resumeAnimation {
    if(_isAnimationPaused){
        _isAnimationPaused = false;
        _animationTimeScale = _prevAnimationTimeScale;
    }
}

- (void) stopAnmation {
    [self clearAnimation];
    [self setToSetupPose];
    _isSpineDirty = true;
}

- (void) clearAnimation {
	[self clearAnimationForState:0];
}

- (void) clearAnimationForState:(int)stateIndex {
	NSAssert(stateIndex >= 0 && stateIndex < (int)_states.count, @"stateIndex out of range.");
	AnimationState* state = [[_states objectAtIndex:stateIndex] pointerValue];
	AnimationState_clearAnimation(state);
}

- (void)setColor:(UIColor *)color {
    for (int i = 0; i < [_slotNodes count]; i++) {
        CBSpineSlot *slotNode = [_slotNodes objectAtIndex:i];
        slotNode.color = color;
    }

}

@end
