//
//  KoboldKitScene.m
//  ClimbBoy
//
//  Created by Robin on 13-10-27.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "SpriteKitScene.h"
#import "RulerLayer.h"

static SpriteKitScene* sharedSpriteKitScene;

@implementation SpriteKitScene

+ (SpriteKitScene *)spriteKitScene
{
    return sharedSpriteKitScene;
}

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        
        sharedSpriteKitScene = self;

        [self setupEditorNodes];
        
        _stageZoom = 1;
        
        [_stageBgLayer setSize:CGSizeMake(400, 400)];
        _stageBgLayer.position = CGPointZero;
    }
    return self;
}


- (void)setupEditorNodes
{
    // Rulers
    _rulerLayer = [RulerLayer node];
    _rulerLayer.zPosition = 10;
    [self addChild:_rulerLayer];
    
    // Border layer
    _borderLayer = [SKNode node];
    _borderLayer.zPosition = 1;
    [self addChild:_borderLayer];
    
    SKColor *borderColor = [SKColor colorWithCalibratedRed:0.4 green:0.4 blue:0.4 alpha:0.6];
    
    _borderBottom = [SKSpriteNode spriteNodeWithColor:borderColor size:CGSizeZero];
    _borderBottom.anchorPoint = ccp(0, 0);
    _borderTop = [SKSpriteNode spriteNodeWithColor:borderColor size:CGSizeZero];
    _borderTop.anchorPoint = ccp(0, 0);
    _borderLeft = [SKSpriteNode spriteNodeWithColor:borderColor size:CGSizeZero];
    _borderLeft.anchorPoint = ccp(0, 0);
    _borderRight = [SKSpriteNode spriteNodeWithColor:borderColor size:CGSizeZero];
    _borderRight.anchorPoint = ccp(0, 0);
    
    [_borderLayer addChild:_borderBottom];
    [_borderLayer addChild:_borderTop];
    [_borderLayer addChild:_borderLeft];
    [_borderLayer addChild:_borderRight];
    
    _borderDevice = [SKSpriteNode spriteNodeWithTexture:nil];
    [_borderLayer addChild:_borderDevice];
    
    
    // Gray background
//    _bgLayer = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(4096, 4096)];
//    _bgLayer.anchorPoint = ccp(0,0);
//    _bgLayer.position = ccp(0,0);
//    _bgLayer.zPosition = -1;
//    [self addChild:_bgLayer];

    
    // Black content layer
    _stageBgLayer = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeZero];
    _stageBgLayer.anchorPoint = ccp(0,0);
//    _stageBgLayer.ignoreAnchorPointForPosition = NO;
    [self addChild:_stageBgLayer];
    
    _contentLayer = [SKNode node];
    [_stageBgLayer addChild:_contentLayer];
}

- (void) setStageBorder:(int)type
{
    _borderDevice.hidden = YES;
    
    if (_stageBgLayer.size.width == 0 || _stageBgLayer.size.height == 0)
    {
//        type = kCCBBorderNone;
        _stageBgLayer.hidden = YES;
    }
    else
    {
        _stageBgLayer.hidden = NO;
    }
    
    /*
    if (type == kCCBBorderDevice)
    {
        [borderBottom setOpacity:255];
        [borderTop setOpacity:255];
        [borderLeft setOpacity:255];
        [borderRight setOpacity:255];
        
        CCTexture2D* deviceTexture = NULL;
        BOOL rotateDevice = NO;
        
        int devType = [appDelegate orientedDeviceTypeForSize:stageBgLayer.contentSize];
        if (devType == kCCBCanvasSizeIPhonePortrait)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-iphone.png"];
            rotateDevice = NO;
        }
        else if (devType == kCCBCanvasSizeIPhoneLandscape)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-iphone.png"];
            rotateDevice = YES;
        }
        if (devType == kCCBCanvasSizeIPhone5Portrait)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-iphone5.png"];
            rotateDevice = NO;
        }
        else if (devType == kCCBCanvasSizeIPhone5Landscape)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-iphone5.png"];
            rotateDevice = YES;
        }
        else if (devType == kCCBCanvasSizeIPadPortrait)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-ipad.png"];
            rotateDevice = NO;
        }
        else if (devType == kCCBCanvasSizeIPadLandscape)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-ipad.png"];
            rotateDevice = YES;
        }
        else if (devType == kCCBCanvasSizeAndroidXSmallPortrait)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-android-xsmall.png"];
            rotateDevice = NO;
        }
        else if (devType == kCCBCanvasSizeAndroidXSmallLandscape)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-android-xsmall.png"];
            rotateDevice = YES;
        }
        else if (devType == kCCBCanvasSizeAndroidSmallPortrait)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-android-small.png"];
            rotateDevice = NO;
        }
        else if (devType == kCCBCanvasSizeAndroidSmallLandscape)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-android-small.png"];
            rotateDevice = YES;
        }
        else if (devType == kCCBCanvasSizeAndroidMediumPortrait)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-android-medium.png"];
            rotateDevice = NO;
        }
        else if (devType == kCCBCanvasSizeAndroidMediumLandscape)
        {
            deviceTexture = [[CCTextureCache sharedTextureCache] addImage:@"frame-android-medium.png"];
            rotateDevice = YES;
        }
        
        if (deviceTexture)
        {
            if (rotateDevice) borderDevice.rotation = 90;
            else borderDevice.rotation = 0;
            
            borderDevice.texture = deviceTexture;
            borderDevice.textureRect = CGRectMake(0, 0, deviceTexture.contentSize.width, deviceTexture.contentSize.height);
            
            borderDevice.visible = YES;
        }
        borderLayer.visible = YES;
    }
    else if (type == kCCBBorderTransparent)
    {
        [borderBottom setOpacity:180];
        [borderTop setOpacity:180];
        [borderLeft setOpacity:180];
        [borderRight setOpacity:180];
        
        borderLayer.visible = YES;
    }
    else if (type == kCCBBorderOpaque)
    {
        [borderBottom setOpacity:255];
        [borderTop setOpacity:255];
        [borderLeft setOpacity:255];
        [borderRight setOpacity:255];
        borderLayer.visible = YES;
    }
    else
    {
        borderLayer.visible = NO;
    }
    
    stageBorderType = type;
    
    [appDelegate updateCanvasBorderMenu];
     */
}


#pragma mark Stage properties
- (void) setStageSize: (CGSize) size centeredOrigin:(BOOL)centeredOrigin
{
    _stageBgLayer.size = size;
    if (centeredOrigin) _contentLayer.position = ccp(size.width/2, size.height/2);
    else _contentLayer.position = ccp(0,0);
    
//    [self setStageBorder:stageBorderType];
    
    
//    if (renderedScene)
//    {
//        [self removeChild:renderedScene cleanup:YES];
//        renderedScene = NULL;
//    }
    
//    if (size.width > 0 && size.height > 0 && size.width <= 1024 && size.height <= 1024)
//    {
//        // Use a new autorelease pool
//        // Otherwise, two successive calls to the running method (_cmd) cause a crash!
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//        
//        renderedScene = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
//        renderedScene.anchorPoint = ccp(0.5f,0.5f);
//        [self addChild:renderedScene];
//        
//        [pool drain];
//    }
    
    
}

- (CGSize) stageSize
{
    return _stageBgLayer.size;
}

- (BOOL) centeredOrigin
{
    return (_contentLayer.position.x != 0);
}


- (void)setStageZoom:(CGFloat)zoom
{
    float zoomFactor = zoom/_stageZoom;
    
    _scrollOffset = ccpMult(_scrollOffset, zoomFactor);
    
    [_stageBgLayer setScale:zoom];
    [_borderDevice setScale:zoom];
    
    _stageZoom = zoom;
}

#pragma mark Replacing content

- (void) replaceRootNodeWith:(SKNode *)node
{
//    CCBGlobals* g = [CCBGlobals globals];
    
    [_rootNode removeFromParent];
    
    self.rootNode = node;
//    g.rootNode = node;
    
    if (!node) return;
    
    [_contentLayer addChild:node];
}

#pragma mark Handle mouse input

- (CGPoint) convertToDocSpace:(CGPoint)viewPt
{
    return [self convertPoint:viewPt toNode:_contentLayer];
}

- (CGPoint) convertToViewSpace:(CGPoint)docPt
{
    return [self convertPoint:docPt fromNode:_contentLayer];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    CGPoint location = [theEvent locationInNode:_contentLayer];
    _mouseDownPos = location;
    NSLog(@"%@", NSStringFromPoint(location));
    
    
    SKSpriteNode *boxSprite = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(50, 50)];
    boxSprite.anchorPoint = ccp(0.5, 0.5);
    boxSprite.position =  _mouseDownPos;
    [_contentLayer addChild:boxSprite];
    
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    [super mouseMoved:theEvent];
//    if (!appDelegate.hasOpenedDocument) return;
    
    CGPoint pos = [theEvent locationInNode:self];
//    NSPoint posRaw = [theEvent locationInWindow];
    _mousePos = pos;
    
//    NSLog(@"%@", NSStringFromPoint(pos));
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    _mouseInside = YES;
    
//    if (!appDelegate.hasOpenedDocument) return;
    
    [_rulerLayer mouseEntered:theEvent];
}
- (void)mouseExited:(NSEvent *)theEvent
{
    _mouseInside = NO;
    
//    if (!appDelegate.hasOpenedDocument) return;
    
    [_rulerLayer mouseExited:theEvent];
}

- (void)cursorUpdate:(NSEvent *)event
{
//    if (!appDelegate.hasOpenedDocument) return;
    
//    if (currentTool == kCCBToolGrab)
//    {
        [[NSCursor openHandCursor] set];
//    }
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    int dx = [theEvent deltaX]*4;
    int dy = -[theEvent deltaY]*4;
    
    _scrollOffset.x = _scrollOffset.x+dx;
    _scrollOffset.y = _scrollOffset.y+dy;
    
//    NSLog(@"%@", NSStringFromPoint(_scrollOffset));
}

- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    
    BOOL winSizeChanged = !CGSizeEqualToSize(_winSize, self.kkView.frame.size);
    _winSize = self.kkView.bounds.size;
    CGPoint stageCenter = ccp((int)(_winSize.width/2+_scrollOffset.x) , (int)(_winSize.height/2+_scrollOffset.y));

    _stageBgLayer.position = stageCenter;
    
    // Setup border layer
    CGRect bounds = _stageBgLayer.frame;
    
    _borderBottom.position = ccp(0,0);
    [_borderBottom setSize:CGSizeMake(_winSize.width, bounds.origin.y)];
    
    _borderTop.position = ccp(0, bounds.size.height + bounds.origin.y);
    [_borderTop setSize:CGSizeMake(_winSize.width, _winSize.height - bounds.size.height - bounds.origin.y)];
    
    _borderLeft.position = ccp(0,bounds.origin.y);
    [_borderLeft setSize:CGSizeMake(bounds.origin.x, bounds.size.height)];
    
    _borderRight.position = ccp(bounds.origin.x+bounds.size.width, bounds.origin.y);
    [_borderRight setSize:CGSizeMake(_winSize.width - bounds.origin.x - bounds.size.width, bounds.size.height)];
    
    CGPoint center = ccp(bounds.origin.x+bounds.size.width/2, bounds.origin.y+bounds.size.height/2);
    _borderDevice.position = center;

    // Update rulers
    _origin = ccpAdd(stageCenter, ccpMult(_contentLayer.position,_stageZoom));
//    _origin.x -= _stageBgLayer.size.width/2 * _stageZoom;
//    _origin.y -= _stageBgLayer.size.height/2 * _stageZoom;
    
    [_rulerLayer updateWithSize:_winSize stageOrigin:_origin zoom:_stageZoom];
    [_rulerLayer updateMousePos:_mousePos];
    
    if (winSizeChanged)
    {
        // Update mouse tracking
        if (_trackingArea)
        {
            [self.kkView removeTrackingArea:_trackingArea];
        }
        
        _trackingArea = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, 0, _winSize.width, _winSize.height) options:NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate | NSTrackingActiveInKeyWindow  owner:self.kkView userInfo:NULL];
        [self.kkView addTrackingArea:_trackingArea];
    }
}

@end
