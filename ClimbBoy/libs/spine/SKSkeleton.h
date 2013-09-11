//
//  SKSkeleton.h
//  ClimbBoy
//
//  Created by Robin on 13-9-10.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <spine/spine.h>

@interface SKSkeleton : KKNode
{
    Skeleton* _skeleton;
	Bone* _rootBone;
	float _timeScale;
	bool _debugSlots;
	bool _debugBones;
	bool _premultipliedAlpha;
    
	bool _ownsSkeletonData;
	Atlas* _atlas;
    
    NSMutableDictionary *_attachmentSprites;
    CFTimeInterval _lastUpdateTimeInterval;
}
@property (nonatomic, readonly) Skeleton* skeleton;
@property (nonatomic) float timeScale;
@property (nonatomic) bool debugSlots;
@property (nonatomic) bool debugBones;
@property (nonatomic) Bone* rootBone;

+ (id) skeletonWithData:(SkeletonData*)skeletonData ownsSkeletonData:(bool)ownsSkeletonData;
+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale;
+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale;

- (id) initWithData:(SkeletonData*)skeletonData ownsSkeletonData:(bool)ownsSkeletonData;
- (id) initWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale;
- (id) initWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale;

- (void) setupAttachmentSprites;
- (void) updateAttachmentSprites;
- (SKTexture *) getTextureAtlas:(RegionAttachment *)regionAttachment;

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

- (NSInteger)slotCount;
@end
