//
//  LevelTest.m
//  ClimbBoy
//
//  Created by Robin on 13-8-30.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "GameplayScene.h"
#import "Utilities.h"
#import "MapScene.h"
#import "CBBehaviors.h"
#import "GameManager.h"
#import "Skull.h"


#define VIEW_SIZE_WIDHT 568
#define VIEW_SIZE_HEIGHT 320


@implementation GameplayScene

+ (instancetype)sceneWithSize:(CGSize)size tmxFile:(NSString *)tmx {
    return [[GameplayScene alloc] initWithSize:size tmxFile:tmx];
}

- (instancetype)initWithSize:(CGSize)size tmxFile:(NSString *)tmx {
    self = [super initWithSize:size];
    if (self) {
        self.anchorPoint = CGPointMake(0.5f, 0.5f);
        // hide screen in the first couple frames behind a "curtain" sprite since it takes a few frames for the scene to be fully set up
		_curtainSprite = [KKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.size];
		_curtainSprite.zPosition = 1000;
		[self addChild:_curtainSprite];

        [HeroRobot loadSharedAssets];
        [Skull loadSharedAssets];

//        _tmxFile = tmx;
//        _tilemapNode = [KKTilemapNode tilemapWithContentsOfFile:_tmxFile];
//        [self addChild:_tilemapNode];
        
        _mapNode = [MapNode MapWithGridSize:CGSizeMake(64, 64)];
        [self addChild:_mapNode];
        _tilemapNode = [KKTilemapNode tilemapWithContentsOfTilemap:_mapNode.mainTilemap];
        [self addChild:_tilemapNode];

        if ([GameManager showsDebugNode]) {
            Debug *debugNode = [Debug sharedDebug];
            [self addChild:debugNode];
            debugNode.zPosition = 100;
        }
        
        _hud = [KKViewOriginNode node];
        _hud.zPosition = 20;
        [self addChild:_hud];
        
        //test loading scene
        float a = 2423;
        float b = 3432;
        for (int i = 0; i < 50000000; i++) {
            a /= b;
        }

        [[OALSimpleAudio sharedInstance] playBg:@"Water Temple.mp3" loop:YES];

    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
//    SKNode *mainLayerPhysics = [self.tilemapNode createPhysicsShapesWithTileLayerNode:self.tilemapNode.mainTileLayerNode];
//    for (SKNode *node in mainLayerPhysics.children) {
//        node.physicsBody.restitution = 0;
//    }
    
    NSArray *collisionsLayers = [_tilemapNode objectsLayerNodeNamed:@"collisions"];
    for (KKTilemapObjectLayerNode *layer in collisionsLayers)
    {
        SKNode *collisionsLayerPhysics = [_tilemapNode createPhysicsShapesWithObjectLayerNode:layer];
        for (SKNode *node in collisionsLayerPhysics.children) {
            node.physicsBody.restitution = 0;
        }
    }
    
    [_tilemapNode.tilemap writeToFile:[NSBundle pathForDocumentsFile:@"testWrite.tmx"]];
    NSLog(@"Documents: %@", [NSBundle pathForDocumentsFile:@"testWrite.tmx"]);
    
    KKTilemapProperties *mapProperties = _tilemapNode.tilemap.properties;
    self.physicsWorld.gravity = CGVectorMake(0, [mapProperties numberForKey:@"physicsGravityY"].floatValue);
	self.physicsWorld.speed = [mapProperties numberForKey:@"physicsSimulationSpeed"].floatValue;
    if(self.physicsWorld.speed == 0.0){
        // compatibility fallback
        self.physicsWorld.speed = [mapProperties numberForKey:@"physicsSpeed"].floatValue;
    }
    
    [_tilemapNode spawnObjects];
    
    _playerCharacter = (HeroRobot*)[_tilemapNode.gameObjectsLayerNode childNodeWithName:@"player"];
	NSAssert1([_playerCharacter isMemberOfClass:[HeroRobot class]], @"player node (%@) is not of class PlayerCharacter!", _playerCharacter);
    
    [self createSimpleControls];
    
    // this must be performed after the player setup, because the player is moving the camera
	if ([mapProperties numberForKey:@"restrictScrollingToMapBoundary"].boolValue)
	{
		[_tilemapNode restrictScrollingToMapBoundary];
	}
    [_tilemapNode enableParallaxScrolling];
    
    [self addDebugInfoNode];

    // remove the curtain
//	[_curtainSprite runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1],
//                                                   [SKAction fadeAlphaTo:0 duration:0.5]]]];
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
    [[OALSimpleAudio sharedInstance] stopBg];
}

- (void)addDebugInfoNode {
    _debugInfo = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    _debugInfo.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
//    _debugInfo.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    _debugInfo.text = @"Hello, World!";
    _debugInfo.fontSize = 15;
    _debugInfo.color = [UIColor blackColor];
    _debugInfo.position = CGPointMake( 30, self.frame.size.height - 40);
    [_hud addChild:_debugInfo];
    
    SKLabelNode *backButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backButton.text = @"Back";
    backButton.fontSize = 20;
    backButton.fontColor = [SKColor redColor];
    backButton.zPosition = 1;
    backButton.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height - 40);
    [_hud addChild:backButton];
    
    // KKButtonBehavior turns any node into a button
	KKButtonBehavior* buttonBehavior = [KKButtonBehavior behavior];
	buttonBehavior.selectedScale = 1.2;
	[backButton addBehavior:buttonBehavior];
	
	// observe button execute notification
	[self observeNotification:KKButtonDidExecuteNotification
					 selector:@selector(backButtonDidExecute:)
					   object:backButton];
}

- (void)backButtonDidExecute:(NSNotification *)notification {
//    [self.kkView popSceneWithTransition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
    MapScene *mapScene = [MapScene sceneWithSize:self.size];
    [self.kkView presentScene:mapScene transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.3]];
}

#pragma mark - Loop Update
-(void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
    _debugInfo.text = [NSString stringWithFormat:@"%@, velocity:%04f,%04f",
                         _playerCharacter.activeAnimationKey, _playerCharacter.physicsBody.velocity.dx,
                         _playerCharacter.physicsBody.velocity.dy];
    
    CGPoint p = _playerCharacter.position;// [self convertPoint:_playerCharacter.position fromNode:_playerCharacter.parent];
    _debugInfo.text = [NSString stringWithFormat:@"%@, velocity:%04f,%04f bounds: %f, %f, %f, %f",
                       _playerCharacter.activeAnimationKey, p.x,p.y, _roomBounds.origin.x, _roomBounds.origin.y, _roomBounds.size.width, _roomBounds.size.height];
    
    CGRect bounds = [_mapNode boundsFromMainLayerPosition:_playerCharacter.position];
    if (!CGRectEqualToRect(bounds, _roomBounds)) {
        _roomBounds = bounds;
        KKStayInBoundsBehavior *stayInBoundsBehavior  = [_tilemapNode.mainTileLayerNode behaviorKindOfClass:[KKStayInBoundsBehavior class]];
        if (stayInBoundsBehavior){
            stayInBoundsBehavior.bounds = _roomBounds;
            _curtainSprite.alpha = 1;
            [_curtainSprite runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0 duration:0.1]]]];
        }
    }
    
}

-(void)didEvaluateActions
{
    [super didEvaluateActions];

}

-(void) createSimpleControls
{
    // ----------------------------- DPad ----------------------------
	SKTextureAtlas* atlas = [SKTextureAtlas atlasNamed:@"GUI"];

    /*
	KKSpriteNode* dpadNode = [KKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"button_directions_background"]];
	dpadNode.position = CGPointMake(dpadNode.size.width / 2 + 15, dpadNode.size.height / 2 + 15);
	[_hud addChild:dpadNode];
	
	NSArray* dpadTextures = [NSArray arrayWithObjects:
							 [atlas textureNamed:@"button_directions_right"],
							 [atlas textureNamed:@"button_directions_left"],
							 nil];
	KKControlPadBehavior* dpad = [KKControlPadBehavior controlPadBehaviorWithTextures:dpadTextures];
	dpad.deadZone = 0;
	[dpadNode addBehavior:dpad withKey:@"simple dpad"];
    
    [_playerCharacter observeNotification:KKControlPadDidChangeDirectionNotification
								 selector:@selector(controlPadDidChangeDirection:)
								   object:dpadNode];
     */
    
    //-------------------------------Joystick-----------------------------------
    CBAnalogueStick *stick = [CBAnalogueStick StickWithHandle:[SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"analogue_handle"]]
                                                   background:[SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"analogue_bg"]]];
    stick.position = CGPointMake(80 , 80);
    stick.radius = 130;
    [stick setScale:0.4];
    [stick setAlpha:0.5];
    stick.delegate = self;
    [_hud addChild:stick];
    
    // ----------------------------- Attack Button ----------------------------
    CBButton *attackButtonNode = [CBButton buttonWithTitle:nil
                                               spriteFrame:[KKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"button"]]
                                       selectedSpriteFrame:[KKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"button-pressed"]]
                                       disabledSpriteFrame:nil];
    attackButtonNode.position = CGPointMake(self.size.width - 150 , 60);
    [attackButtonNode setScale:0.5];
    [attackButtonNode setAlpha:0.5];
    attackButtonNode.executesWhenPressed = YES;
	[_hud addChild:attackButtonNode];
    
    [attackButtonNode setTarget:_playerCharacter selector:@selector(attackButtonExecute:)];

    // ----------------------------- Jump Button ----------------------------
    CBButton *jumpButtonNode = [CBButton buttonWithTitle:nil
                                             spriteFrame:[KKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"button"]]
                                     selectedSpriteFrame:[KKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"button-pressed"]]
                                     disabledSpriteFrame:nil];
	jumpButtonNode.position = CGPointMake(self.size.width - 60 , 60);
    [jumpButtonNode setScale:0.5];
    [jumpButtonNode setAlpha:0.5];
    jumpButtonNode.executesWhenPressed = YES;
	[_hud addChild:jumpButtonNode];
	
    [jumpButtonNode setTarget:_playerCharacter selector:@selector(jumpButtonExecute:)];
        
}

- (void)analogueStickDidChangeValue:(CBAnalogueStick *)analogueStick
{
    if ([_playerCharacter respondsToSelector:@selector(analogueStickDidChangeValue:)]) {
        [_playerCharacter analogueStickDidChangeValue:analogueStick];
    }    
}

- (BOOL) hasHUDAtPoint:(CGPoint)point
{
    NSArray *nodes = [_hud nodesAtPoint:[_hud convertPoint:point fromNode:self]];
    if (nodes.count) {
        return YES;
    };
    return NO;
}

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	/* Called when a touch begins */
//    [super touchesBegan:touches withEvent:event];
//	
//	for (UITouch* touch in touches)
//	{
//        if ([self hasHUDAtPoint:[touch locationInNode:self]]) {
//            return;
//        }
//        _location = [touch locationInNode:self];
//        
//	}
//	
//	// (optional) call super implementation to allow KKScene to dispatch touch events
//	[super touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//    
//    for (UITouch* touch in touches) {
//        if ([self hasHUDAtPoint:[touch locationInNode:self]]) {
//            return;
//        }
//        CGPoint offset = ccpSub([touch locationInNode:self], _location);
//        _mapNode.position = ccpAdd(_mapNode.position, offset);
//        
//        _location = [touch locationInNode:self];
//    }
//}


//-(void) didSimulatePhysics
//{
//    SKNode* node = _playerCharacter;
//    SKNode* p = _mapNode;
//    CGPoint cameraPositionInScene = [self convertPoint:node.position fromNode:p];
//    CGPoint pos = CGPointMake(p.position.x - cameraPositionInScene.x,
//                              p.position.y - cameraPositionInScene.y);
//    p.position = pos;
//    [super didSimulatePhysics];
//}

@end
