//
//  KoboldKitScene.h
//  ClimbBoy
//
//  Created by Robin on 13-10-27.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKScene.h"

@class RulerLayer;


@interface SpriteKitScene : KKScene
{
    SKSpriteNode *_bgLayer;
    SKSpriteNode *_stageBgLayer;
    SKNode *_contentLayer;
    SKNode *_selectionLayer;
    SKNode *_borderLayer;
    RulerLayer *_rulerLayer;
    CGSize _winSize;
    
    NSTrackingArea* _trackingArea;
    
    // Mouse handling
    BOOL _mouseInside;
    CGPoint _mousePos;
    CGPoint _mouseDownPos;
    float _transformStartRotation;
    float _transformStartScaleX;
    float _transformStartScaleY;
    SKNode *_transformScalingNode;
    //CGPoint transformStartPosition;
    int _currentMouseTransform;
    BOOL _isMouseTransforming;
    BOOL _isPanning;
    CGPoint _panningStartScrollOffset;
    
    // Origin position in screen coordinates
    CGPoint _origin;
    
    SKSpriteNode* _borderBottom;
    SKSpriteNode* _borderTop;
    SKSpriteNode* _borderLeft;
    SKSpriteNode* _borderRight;
    SKSpriteNode* _borderDevice;
    
    int _currentTool;
}
@property (nonatomic,assign) SKNode *rootNode;
@property (nonatomic,assign) CGPoint scrollOffset;

@property (nonatomic) CGFloat stageZoom;

+ (SpriteKitScene*) spriteKitScene;

- (void) setStageSize: (CGSize) size centeredOrigin:(BOOL)centeredOrigin;
- (CGSize) stageSize;
- (BOOL) centeredOrigin;
- (void) setStageBorder:(int)type;
- (int) stageBorder;

- (void) replaceRootNodeWith:(SKNode *)node;

- (CGPoint) convertToDocSpace:(CGPoint)viewPt;
- (CGPoint) convertToViewSpace:(CGPoint)docPt;

@end
