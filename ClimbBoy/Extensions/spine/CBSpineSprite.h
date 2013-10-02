//
//  CBSpineSprite.h
//  ClimbBoy
//
//  Created by Robin on 13-9-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <spine/spine.h>
#import "CBSpineSlot.h"

@class CBSpineSprite;

@protocol CBSpineSpriteDelegate <NSObject>
@optional
- (void) animationDidStart:(CBSpineSprite*)animation track:(int)trackIndex;
- (void) animationWillEnd:(CBSpineSprite*)animation track:(int)trackIndex;
- (void) animationDidTriggerEvent:(CBSpineSprite*)animation track:(int)trackIndex event:(Event*)event;
- (void) animationDidComplete:(CBSpineSprite*)animation track:(int)trackIndex loopCount:(int)loopCount;
@end

@interface CBSpineSprite : KKNode
{
    Skeleton *_skeleton;
    NSMutableArray *_slotNodes;
    
    bool _isSpineDirty;
        
	id<CBSpineSpriteDelegate> _delegate;
	bool _delegateStart, _delegateEnd, _delegateEvent, _delegateComplete;
    
     CFTimeInterval _lastUpdateTimeInterval;
    float _prevAnimationTimeScale;
    bool _isAnimationPaused;
}
@property (nonatomic, readonly) Skeleton* skeleton;
@property (nonatomic) float animationTimeScale;
@property (nonatomic) bool debugSlots;
@property (nonatomic) bool debugBones;
@property (nonatomic) Bone* rootBone;

+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale;
+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale;

- (id) initWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale;
- (id) initWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale;

- (void) updateWithTimeSinceLastUpdate:(CFTimeInterval)delta;

// --- Convenience methods for common Skeleton_* functions.
- (void) updateWorldTransform;

- (void) setToSetupPose;
- (void) setBonesToSetupPose;
- (void) setSlotsToSetupPose;

/* Returns 0 if the bone was not found. */
- (Bone*) findBone:(NSString*)boneName;

/* Returns 0 if the slot was not found. */
- (Slot*) findSlot:(NSString*)slotName;

/* Sets the skin used to look up attachments not found in the SkeletonData defaultSkin. Attachments from the new skin are
 * attached if the corresponding attachment from the old skin was attached. Returns false if the skin was not found.
 * @param skin May be 0.*/
- (bool) setSkin:(NSString*)skinName;

/* Returns 0 if the slot or attachment was not found. */
- (Attachment*) getAttachment:(NSString*)slotName attachmentName:(NSString*)attachmentName;
/* Returns false if the slot or attachment was not found. */
- (bool) setAttachment:(NSString*)slotName attachmentName:(NSString*)attachmentName;

//----------------------------- animation -------------------------------
@property (nonatomic, readonly) AnimationState* state;

- (void) setDelegate:(id<CBSpineSpriteDelegate>)delegate;

- (void) setAnimationStateData:(AnimationStateData*)stateData;
- (void) setMixFrom:(NSString*)fromAnimation to:(NSString*)toAnimation duration:(float)duration;

- (TrackEntry *) setAnimationForTrack:(int)trackIndex name:(NSString*)name loop:(bool)loop;
- (TrackEntry *) addAnimationForTrack:(int)trackIndex name:(NSString*)name loop:(bool)loop afterDelay:(float)delay;
- (TrackEntry *) getCurrentForTrack:(int)trackIndex;

- (void) pauseAnimation;
- (void) resumeAnimation;
- (void) stopAnmation;

- (void) clearAllTracks;
- (void) clearTrack:(int)trackIndex;

- (void) onAnimationStateEvent:(int)trackIndex type:(EventType)type event:(Event*)event loopCount:(int)loopCount;

@end
