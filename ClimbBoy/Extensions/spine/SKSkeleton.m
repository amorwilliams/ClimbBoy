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

- (id) initWithData:(SkeletonData*)skeletonData ownsSkeletonData:(bool)ownsSkeletonData {
	NSAssert(skeletonData, @"skeletonData cannot be null.");
    
	self = [super init];
	if (self){
        [self initialize:skeletonData ownsSkeletonData:ownsSkeletonData];

    }
	return self;
}

- (id) initWithFile:(NSString*)skeletonDataFile atlas:(Atlas*)atlas scale:(float)scale {
	self = [super init];
	if (self) {
        SkeletonJson* json = SkeletonJson_create(atlas);
        json->scale = scale;
        SkeletonData* skeletonData = SkeletonJson_readSkeletonDataFile(json, [skeletonDataFile UTF8String]);
        NSAssert(skeletonData, ([NSString stringWithFormat:@"Error reading skeleton data file: %@\nError: %s", skeletonDataFile, json->error]));
        SkeletonJson_dispose(json);
        if (!skeletonData) return 0;
        
        [self initialize:skeletonData ownsSkeletonData:YES];
    }
    
	return self;
}

- (id) initWithFile:(NSString*)skeletonDataFile atlasFile:(NSString*)atlasFile scale:(float)scale {
	self = [super init];
	if (self) {
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
    }
    
	return self;
}

- (void) initialize:(SkeletonData*)skeletonData ownsSkeletonData:(bool)ownsSkeletonData {
	_ownsSkeletonData = ownsSkeletonData;
    
	_skeleton = Skeleton_create(skeletonData);
	_rootBone = _skeleton->bones[0];
    
	_timeScale = 1;
    
    _attachmentSprites = [NSMutableDictionary dictionary];
    
}

- (void) dealloc {
	if (_ownsSkeletonData) SkeletonData_dispose(_skeleton->data);
	if (_atlas) Atlas_dispose(_atlas);
	Skeleton_dispose(_skeleton);
}

- (void)didMoveToParent {
    [self observeSceneEvents];
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
    Skeleton_update(_skeleton, delta * _timeScale);
}

- (void)setupAttachmentSprites {
    uint index = 0;
    for (int i = 0; i < [self slotCount]; i++) {
        Slot* slot = _skeleton->slots[i];
        if (!slot->attachment || slot->attachment->type != ATTACHMENT_REGION) {
            continue;
        }
        
        //create attachment texture node
        NSString *attachmentName = @(slot->attachment->name);
        if ([_attachmentSprites objectForKey:attachmentName]) {
            continue;
        }
        
        //get region texture
        RegionAttachment* attachment = (RegionAttachment*)slot->attachment;
        SKSpriteNode *attachmentSpriteNode = [self createAttahcmentNode:attachment];
        [_attachmentSprites setValue:attachmentSpriteNode forKey:attachmentName];
//        [self addChild:attachmentSpriteNode];
//        attachmentSpriteNode.zPosition = i;
        [self insertChild:attachmentSpriteNode atIndex:index];
        
        index++;
    }
    
    [self updateAttachmentSprites];
}

- (SKSpriteNode *)createAttahcmentNode:(RegionAttachment *)attachment {
    SKTexture *regionTextureAtlas = [self getTextureAtlas:attachment];
    AtlasRegion *regionTexture = ((AtlasRegion *)attachment->rendererObject);
    float w = regionTexture->width / regionTextureAtlas.size.width;
    float h = regionTexture->height / regionTextureAtlas.size.height;
    float x = regionTexture->x  / regionTextureAtlas.size.width;
    float y = (regionTextureAtlas.size.height - regionTexture->y - regionTexture->height) / regionTextureAtlas.size.height;
    
    SKTexture *attachmentTexture = [SKTexture textureWithRect:CGRectMake(x, y, w, h)
                                                    inTexture:regionTextureAtlas];
    
    SKSpriteNode *attachmentSpriteNode = [SKSpriteNode spriteNodeWithTexture:attachmentTexture];
    attachmentSpriteNode.size = CGSizeMake(attachment->width, attachment->height);
    return attachmentSpriteNode;
}

- (void)updateAttachmentSprites {
    NSMutableArray *remainKey = [NSMutableArray arrayWithArray:[_attachmentSprites allKeys]];
    
    for (int i = 0; i < [self slotCount]; i++) {
        Slot* slot = _skeleton->slots[i];
        
        //检测attachment是否存在
        if (slot->attachment && slot->attachment->type == ATTACHMENT_REGION) {
            RegionAttachment* attachment = (RegionAttachment*)slot->attachment;
            NSString *attachmentName = @(slot->attachment->name);
            
            //如果attachment存在于列表内，则更新他的信息。
            if ([_attachmentSprites objectForKey:attachmentName]) {
                SKSpriteNode *textureNode = [_attachmentSprites objectForKey:attachmentName];
                
                //set postion
                float vertices[8];
                RegionAttachment_computeVertices(attachment, slot->skeleton->x, slot->skeleton->y, slot->bone, vertices);
                CGPoint pos = [self centerPointFromQuad:vertices];
                textureNode.position = pos;
                
                //set rotation
                float amount = 0;
                Bone *bone = slot->bone;
                while (bone) {
                    amount += bone->rotation;
                    bone = bone->parent;
                }
                textureNode.zRotation = KK_DEG2RAD(amount +  attachment->rotation);
                
                //set color
                float r = slot->skeleton->r * slot->r;
                float g = slot->skeleton->g * slot->g;
                float b = slot->skeleton->b * slot->b;
                float normalizedAlpha = slot->skeleton->a * slot->a;
                textureNode.alpha = normalizedAlpha;
                textureNode.color = [SKColor colorWithRed:r green:g blue:b alpha:1];
                textureNode.colorBlendFactor = 1;
            }else{
                
                //如果attachment存在，但是还未加入列表。则生成它，并加入列表
                SKSpriteNode *attachmentSpriteNode = [self createAttahcmentNode:attachment];
                [_attachmentSprites setValue:attachmentSpriteNode forKey:attachmentName];
                [self addChild:attachmentSpriteNode];
            }
            
            [remainKey removeObject:attachmentName];
        }
    }
    
    //如果不存在，并且已经加入了列表，代表当前帧为隐藏状态。设置alpha为0；
    for (NSString *key in remainKey) {
        if ([_attachmentSprites objectForKey:key]) {
            SKSpriteNode *textureNode = [_attachmentSprites objectForKey:key];
            textureNode.alpha = 0;
        }
    }
}

- (CGPoint)centerPointFromQuad:(float *)vertices {
    CGPoint p1 = ccp(vertices[VERTEX_X1], vertices[VERTEX_Y1]);
    CGPoint p2 = ccp(vertices[VERTEX_X2], vertices[VERTEX_Y2]);
    CGPoint p3 = ccp(vertices[VERTEX_X3], vertices[VERTEX_Y3]);
    CGPoint p4 = ccp(vertices[VERTEX_X4], vertices[VERTEX_Y4]);
    
    CGPoint ret = CGPointZero;
    ret.x = (p1.x + p2.x + p3.x + p4.x)/4;
    ret.y = (p1.y + p2.y + p3.y + p4.y)/4;
    
    return ret;
}

- (SKTexture*) getTextureAtlas:(RegionAttachment*)regionAttachment {
	return (__bridge SKTexture*)((AtlasRegion*)regionAttachment->rendererObject)->page->rendererObject;
}

- (CGRect) boundingBox {
	float minX = FLT_MAX, minY = FLT_MAX, maxX = FLT_MIN, maxY = FLT_MIN;
	float scaleX = self.xScale;
	float scaleY = self.yScale;
	float vertices[8];
	for (int i = 0; i < _skeleton->slotCount; ++i) {
		Slot* slot = _skeleton->slots[i];
		if (!slot->attachment || slot->attachment->type != ATTACHMENT_REGION) continue;
		RegionAttachment* attachment = (RegionAttachment*)slot->attachment;
		RegionAttachment_computeVertices(attachment, slot->skeleton->x, slot->skeleton->y, slot->bone, vertices);
		minX = fmin(minX, vertices[VERTEX_X1] * scaleX);
		minY = fmin(minY, vertices[VERTEX_Y1] * scaleY);
		maxX = fmax(maxX, vertices[VERTEX_X1] * scaleX);
		maxY = fmax(maxY, vertices[VERTEX_Y1] * scaleY);
		minX = fmin(minX, vertices[VERTEX_X4] * scaleX);
		minY = fmin(minY, vertices[VERTEX_Y4] * scaleY);
		maxX = fmax(maxX, vertices[VERTEX_X4] * scaleX);
		maxY = fmax(maxY, vertices[VERTEX_Y4] * scaleY);
		minX = fmin(minX, vertices[VERTEX_X2] * scaleX);
		minY = fmin(minY, vertices[VERTEX_Y2] * scaleY);
		maxX = fmax(maxX, vertices[VERTEX_X2] * scaleX);
		maxY = fmax(maxY, vertices[VERTEX_Y2] * scaleY);
		minX = fmin(minX, vertices[VERTEX_X3] * scaleX);
		minY = fmin(minY, vertices[VERTEX_Y3] * scaleY);
		maxX = fmax(maxX, vertices[VERTEX_X3] * scaleX);
		maxY = fmax(maxY, vertices[VERTEX_Y3] * scaleY);
	}
	minX = self.position.x + minX;
	minY = self.position.y + minY;
	maxX = self.position.x + maxX;
	maxY = self.position.y + maxY;
	return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}

#pragma mark - Convenience methods for Skeleton_* functions.

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
	bool ret = (bool)Skeleton_setSkinByName(_skeleton, skinName ? [skinName UTF8String] : 0);
    if (ret) {
        for (SKNode *child in self.children) {
            [child removeFromParent];
        }
        
        [_attachmentSprites removeAllObjects];
        
        [self setToSetupPose];
        [self setupAttachmentSprites];
    }
    return ret;
}

- (Attachment*) getAttachment:(NSString*)slotName attachmentName:(NSString*)attachmentName {
	return Skeleton_getAttachmentForSlotName(_skeleton, [slotName UTF8String], [attachmentName UTF8String]);
}
- (bool) setAttachment:(NSString*)slotName attachmentName:(NSString*)attachmentName {
	bool ret = (bool)Skeleton_setAttachment(_skeleton, [slotName UTF8String], [attachmentName UTF8String]);
    if (ret && [_attachmentSprites objectForKey:attachmentName]) {
        [_attachmentSprites removeObjectForKey:attachmentName];
    }
    return ret;
}

- (NSInteger)slotCount{
    return _skeleton->slotCount;
}

@end
