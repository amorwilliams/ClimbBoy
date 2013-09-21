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

@interface CBSpineSprite : SKNode
{
    Skeleton *_skeleton;
    NSMutableArray *_slotNodes;
    
    NSMutableArray* _stateDatas;
    bool _isSpineDirty;
    
     CFTimeInterval _lastUpdateTimeInterval;
    float _prevAnimationTimeScale;
    bool _isAnimationPaused;
}
@property (nonatomic, readonly) Skeleton* skeleton;
@property (nonatomic) float animationTimeScale;
@property (nonatomic) SKColor *color;
@property (nonatomic) bool debugSlots;
@property (nonatomic) bool debugBones;
@property (nonatomic) Bone* rootBone;

@property (retain, nonatomic, readonly) NSMutableArray* states;


+ (id) skeletonWithName:(NSString *)name;
+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale;
+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale;

- (id) initWithName:(NSString *)name;
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

- (void) addAnimationState;
- (void) addAnimationState:(AnimationStateData*)stateData;
- (AnimationState*) getAnimationState:(int)stateIndex;
- (void) setAnimationStateData:(AnimationStateData*)stateData forState:(int)stateIndex;

- (void) setMixFrom:(NSString*)fromAnimation to:(NSString*)toAnimation duration:(float)duration;
- (void) setMixFrom:(NSString*)fromAnimation to:(NSString*)toAnimation duration:(float)duration forState:(int)stateIndex;

- (void) playAnimation:(NSString*)name loop:(bool)loop;
- (void) playAnimation:(NSString*)name loop:(bool)loop forState:(int)stateIndex;

- (void) queueAnimation:(NSString*)name loop:(bool)loop afterDelay:(float)delay;
- (void) queueAnimation:(NSString*)name loop:(bool)loop afterDelay:(float)delay forState:(int)stateIndex;

- (void) pauseAnimation;
- (void) resumeAnimation;
- (void) stopAnmation;

- (void) clearAnimation;
- (void) clearAnimationForState:(int)stateIndex;

@end
