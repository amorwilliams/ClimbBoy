//
//  CBSpineSprite.m
//  ClimbBoy
//
//  Created by Robin on 13-9-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CBSpineSprite.h"

static void callback (AnimationState* state, int trackIndex, EventType type, Event* event, int loopCount) {
	[(__bridge CBSpineSprite *)state->context onAnimationStateEvent:trackIndex type:type event:event loopCount:loopCount];
}

@implementation CBSpineSprite

+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale {
	return [[CBSpineSprite alloc] initWithFile:skeletonDataFile atlas:atlas scale:scale];
}

+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale {
	return [[CBSpineSprite alloc] initWithFile:skeletonDataFile atlasFile:atlasFile scale:scale];
}

- (id) initWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale {
	self = [super init];
	if (self) {
        SkeletonJson* json = SkeletonJson_create(atlas);
        json->scale = scale;
        SkeletonData* skeletonData = SkeletonJson_readSkeletonDataFile(json, [skeletonDataFile UTF8String]);
        NSAssert(skeletonData, ([NSString stringWithFormat:@"Error reading skeleton data file: %@\nError: %s", skeletonDataFile, json->error]));
        SkeletonJson_dispose(json);
        
        NSAssert(skeletonData, @"Can not find skeleton data");

        [self initialize:skeletonData];
    }
    
	return self;
}

- (id) initWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale {
	self = [super init];
	if (self) {
        Atlas *atlas = Atlas_readAtlasFile([atlasFile UTF8String]);
        NSAssert(atlas, ([NSString stringWithFormat:@"Error reading atlas file: %@", atlasFile]));
        
        SkeletonJson* json = SkeletonJson_create(atlas);
        json->scale = scale;
        SkeletonData* skeletonData = SkeletonJson_readSkeletonDataFile(json, [skeletonDataFile UTF8String]);
        NSAssert(skeletonData, ([NSString stringWithFormat:@"Error reading skeleton data file: %@\nError: %s", skeletonDataFile, json->error]));
        SkeletonJson_dispose(json);
        
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
    
    [self buildSkeleton];
    
    _state = AnimationState_create(AnimationStateData_create(_skeleton->data));
	_state->context = (__bridge void *)(self);
	_state->listener = callback;
}

- (void) dealloc {
    AnimationStateData_dispose(_state->data);
    AnimationState_dispose(_state);
    
	SkeletonData_dispose(_skeleton->data);
	Skeleton_dispose(_skeleton);
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
    Skeleton_update(_skeleton, delta * _animationTimeScale);
    
    AnimationState_update(_state, delta * _animationTimeScale);
    AnimationState_apply(_state, _skeleton);
    _isSpineDirty = YES;
    
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
- (void) setAnimationStateData:(AnimationStateData*)stateData {
	NSAssert(stateData, @"stateData cannot be null.");
	
	AnimationStateData_dispose(_state->data);
	AnimationState_dispose(_state);
    
	_state = AnimationState_create(stateData);
	_state->context = (__bridge void *)(self);
	_state->listener = callback;
}

- (void) setMixFrom:(NSString*)fromAnimation to:(NSString*)toAnimation duration:(float)duration {
	AnimationStateData_setMixByName(_state->data, [fromAnimation UTF8String], [toAnimation UTF8String], duration);
}

- (void) setDelegate:(id<CBSpineSpriteDelegate>)delegate {
	_delegate = delegate;
	_delegateStart = [delegate respondsToSelector:@selector(animationDidStart:track:)];
	_delegateEnd = [delegate respondsToSelector:@selector(animationWillEnd:track:)];
	_delegateEvent = [delegate respondsToSelector:@selector(animationDidTriggerEvent:track:event:)];
	_delegateComplete = [delegate respondsToSelector:@selector(animationDidComplete:track:loopCount:)];
}

- (TrackEntry*) setAnimationForTrack:(int)trackIndex name:(NSString*)name loop:(bool)loop {
	return AnimationState_setAnimationByName(_state, trackIndex, [name UTF8String], loop);
}

- (TrackEntry*) addAnimationForTrack:(int)trackIndex name:(NSString*)name loop:(bool)loop afterDelay:(float)delay {
	return AnimationState_addAnimationByName(_state, trackIndex, [name UTF8String], loop, delay);
}

- (TrackEntry*) getCurrentForTrack:(int)trackIndex {
	return AnimationState_getCurrent(_state, trackIndex);
}

- (void) clearAllTracks {
	AnimationState_clearTracks(_state);
}

- (void) clearTrack:(int)trackIndex {
	AnimationState_clearTrack(_state, trackIndex);
}

- (void) onAnimationStateEvent:(int)trackIndex type:(EventType)type event:(Event*)event loopCount:(int)loopCount {
	if (!_delegate) return;
	switch (type) {
		case ANIMATION_START:
			if (_delegateStart) [_delegate animationDidStart:self track:trackIndex];
			break;
		case ANIMATION_END:
			if (_delegateEnd) [_delegate animationWillEnd:self track:trackIndex];
			break;
		case ANIMATION_COMPLETE:
			if (_delegateComplete) [_delegate animationDidComplete:self track:trackIndex loopCount:loopCount];
			break;
		case ANIMATION_EVENT:
			if (_delegateEvent) [_delegate animationDidTriggerEvent:self track:trackIndex event:event];
			break;
	}
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
    [self clearAllTracks];
    [self setToSetupPose];
    _isSpineDirty = true;
}

@end
