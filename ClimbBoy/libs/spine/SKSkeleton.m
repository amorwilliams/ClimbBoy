//
//  SKSkeleton.m
//  ClimbBoy
//
//  Created by Robin on 13-9-10.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "SKSkeleton.h"

@implementation SKSkeleton

@synthesize skeleton = _skeleton;
@synthesize rootBone = _rootBone;
@synthesize timeScale = _timeScale;
@synthesize debugSlots = _debugSlots;
@synthesize debugBones = _debugBones;

+ (id) skeletonWithData:(SkeletonData*)skeletonData ownsSkeletonData:(bool)ownsSkeletonData {
	return [[SKSkeleton alloc] initWithData:skeletonData ownsSkeletonData:ownsSkeletonData];
}

+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale {
	return [[SKSkeleton alloc] initWithFile:skeletonDataFile atlas:atlas scale:scale];
}

+ (id) skeletonWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale {
	return [[SKSkeleton alloc] initWithFile:skeletonDataFile atlasFile:atlasFile scale:scale];
}

- (void) initialize:(SkeletonData*)skeletonData ownsSkeletonData:(bool)ownsSkeletonData {
	_ownsSkeletonData = ownsSkeletonData;
    
	_skeleton = Skeleton_create(skeletonData);
	_rootBone = _skeleton->bones[0];
    
	_timeScale = 1;
}

- (id) initWithData:(SkeletonData*)skeletonData ownsSkeletonData:(bool)ownsSkeletonData {
	NSAssert(skeletonData, @"skeletonData cannot be null.");
    
	self = [super init];
	if (!self) return nil;
    
	[self initialize:skeletonData ownsSkeletonData:ownsSkeletonData];
    
	return self;
}

- (id) initWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale {
	self = [super init];
	if (!self) return nil;
    
	SkeletonJson* json = SkeletonJson_create(atlas);
	json->scale = scale;
	SkeletonData* skeletonData = SkeletonJson_readSkeletonDataFile(json, [skeletonDataFile UTF8String]);
	NSAssert(skeletonData, ([NSString stringWithFormat:@"Error reading skeleton data file: %@\nError: %s", skeletonDataFile, json->error]));
	SkeletonJson_dispose(json);
	if (!skeletonData) return 0;
    
	[self initialize:skeletonData ownsSkeletonData:YES];
    
	return self;
}

- (id) initWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale {
	self = [super init];
	if (!self) return nil;
    
	_atlas = Atlas_readAtlasFile([atlasFile UTF8String]);
	NSAssert(_atlas, ([NSString stringWithFormat:@"Error reading atlas file: %@", atlasFile]));
	if (!_atlas) return 0;
    
	SkeletonJson* json = SkeletonJson_create(_atlas);
	json->scale = scale;
	SkeletonData* skeletonData = SkeletonJson_readSkeletonDataFile(json, [skeletonDataFile UTF8String]);
	NSAssert(skeletonData, ([NSString stringWithFormat:@"Error reading skeleton data file: %@\nError: %s", skeletonDataFile, json->error]));
	SkeletonJson_dispose(json);
	if (!skeletonData) return 0;
    
	[self initialize:skeletonData ownsSkeletonData:YES];
    
	return self;
}

- (void) dealloc {
	if (_ownsSkeletonData) SkeletonData_dispose(_skeleton->data);
	if (_atlas) Atlas_dispose(_atlas);
	Skeleton_dispose(_skeleton);
}

- (SKTexture *)getTextureBySlotIndex:(NSInteger)slotIndex {
    Slot* slot = _skeleton->slots[slotIndex];
    if (!slot->attachment || slot->attachment->type != ATTACHMENT_REGION) return nil;
    RegionAttachment* attachment = (RegionAttachment*)slot->attachment;
    SKTexture *regionTextureAtlas = [self getTextureAtlas:attachment];
    AtlasRegion *regionTexture = ((AtlasRegion *)attachment->rendererObject);
    float w = ((AtlasRegion *)attachment->rendererObject)->width;
    float h = ((AtlasRegion *)attachment->rendererObject)->height;
    float x = ((AtlasRegion *)attachment->rendererObject)->x;
    float y = regionTextureAtlas.size.height - ((AtlasRegion *)attachment->rendererObject)->y - h;
    
//    if (regionTextureAtlas != textureAtlas) {
//        if (textureAtlas) {
//            [textureAtlas drawQuads];
//            [textureAtlas removeAllQuads];
//        }
//    }

    SKTexture *textureAtlas = [SKTexture textureWithRect:CGRectMake(x/regionTextureAtlas.size.width,
                                                                    y/regionTextureAtlas.size.height,
                                                                    w/regionTextureAtlas.size.width,
                                                                    h/regionTextureAtlas.size.height)
                                               inTexture:regionTextureAtlas];
//    if (textureAtlas.capacity == textureAtlas.totalQuads &&
//        ![textureAtlas resizeCapacity:textureAtlas.capacity * 2]) return;
//    RegionAttachment_updateQuad(attachment, slot, &quad, _premultipliedAlpha);
//    [textureAtlas updateQuad:&quad atIndex:textureAtlas.totalQuads];
    return textureAtlas;
}

- (SKTexture*) getTextureAtlas:(RegionAttachment*)regionAttachment {
	return (__bridge SKTexture*)((AtlasRegion*)regionAttachment->rendererObject)->page->rendererObject;
}

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

- (bool) setSkin:(NSString*)skinName {
	return (bool)Skeleton_setSkinByName(_skeleton, skinName ? [skinName UTF8String] : 0);
}

- (Attachment*) getAttachment:(NSString*)slotName attachmentName:(NSString*)attachmentName {
	return Skeleton_getAttachmentForSlotName(_skeleton, [slotName UTF8String], [attachmentName UTF8String]);
}
- (bool) setAttachment:(NSString*)slotName attachmentName:(NSString*)attachmentName {
	return (bool)Skeleton_setAttachment(_skeleton, [slotName UTF8String], [attachmentName UTF8String]);
}

- (NSInteger)slotCount{
    return _skeleton->slotCount;
}

@end
