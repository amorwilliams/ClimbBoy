//
//  LevelTest.m
//  ClimbBoy
//
//  Created by Robin on 13-8-30.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "GameplayScene.h"
#import "Debug.h"
#import "MapScene.h"
#import "CBBehaviors.h"

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

        _tmxFile = tmx;
        _tilemapNode = [KKTilemapNode tilemapWithContentsOfFile:_tmxFile];
        [self addChild:_tilemapNode];
        
        Debug *debugNode = [Debug sharedDebug];
        [self addChild:debugNode];
        debugNode.zPosition = 100;
        
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
    
    SKNode *collisionsLayerPhysics = [_tilemapNode createPhysicsShapesWithObjectLayerNode:[_tilemapNode objectLayerNodeNamed:@"collisions"]];
    for (SKNode *node in collisionsLayerPhysics.children) {
        node.physicsBody.restitution = 0;
    }
    
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
	[_curtainSprite runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1], [SKAction fadeAlphaTo:0 duration:0.5], [SKAction removeFromParent]]]];
	_curtainSprite = nil;
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
    KKViewOriginNode *hud = [KKViewOriginNode node];
    [self addChild:hud];
    
    [hud addChild:_debugInfo];
    
    SKLabelNode *backButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backButton.text = @"Back";
    backButton.fontSize = 20;
    backButton.fontColor = [SKColor redColor];
    backButton.zPosition = 1;
    backButton.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height - 40);
    [hud addChild:backButton];
    
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
}

-(void) createSimpleControls
{
	KKViewOriginNode* joypadNode = [KKViewOriginNode node];
	joypadNode.name = @"joypad";
	[self addChild:joypadNode];
    
    // ----------------------------- DPad ----------------------------
	SKTextureAtlas* atlas = [SKTextureAtlas atlasNamed:@"Jetpack"];
    
	KKSpriteNode* dpadNode = [KKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"button_directions_background"]];
	dpadNode.position = CGPointMake(dpadNode.size.width / 2 + 15, dpadNode.size.height / 2 + 15);
	[joypadNode addChild:dpadNode];
	
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
    
    
    // ----------------------------- Attack Button ----------------------------
    CBButton *attackButtonNode = [CBButton buttonWithTitle:nil
                                               spriteFrame:[KKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"button_jump_notpressed"]]
                                       selectedSpriteFrame:[KKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"button_jump_pressed"]]
                                       disabledSpriteFrame:nil];
    attackButtonNode.position = CGPointMake(self.size.width - 150 , 60);
    attackButtonNode.executesWhenPressed = YES;
	[joypadNode addChild:attackButtonNode];
    
    [attackButtonNode setTarget:_playerCharacter selector:@selector(attackButtonExecute:)];

    // ----------------------------- Jump Button ----------------------------
    CBButton *jumpButtonNode = [CBButton buttonWithTitle:nil
                                             spriteFrame:[KKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"button_jump_notpressed"]]
                                     selectedSpriteFrame:[KKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"button_jump_pressed"]]
                                     disabledSpriteFrame:nil];
	jumpButtonNode.position = CGPointMake(self.size.width - 60 , 60);
    jumpButtonNode.executesWhenPressed = YES;
	[joypadNode addChild:jumpButtonNode];
	
    [jumpButtonNode setTarget:_playerCharacter selector:@selector(jumpButtonExecute:)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:_tilemapNode.gameObjectsLayerNode];
        
        
        if (!_emitter) {
            _emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle2" ofType:@"sks"]];
//            _emitter.position = location;
            _emitter.targetNode = _tilemapNode.gameObjectsLayerNode;
            [_tilemapNode.gameObjectsLayerNode addChild:_emitter];
        }
        
        PlaceItemBehavior *placeItemBehavior = (PlaceItemBehavior *)[_playerCharacter behaviorMemberOfClass:[PlaceItemBehavior class]];
        if (placeItemBehavior) {
            placeItemBehavior.item = _emitter;
        }
    }
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:_tilemapNode.gameObjectsLayerNode];
//        
//        
//        if (_emitter) {
//            _emitter.position = location;
//        }
//        
//    }
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:_tilemapNode.gameObjectsLayerNode];
        
//        if (_emitter) {
//            [_emitter removeFromParent];
//            _emitter = nil;
//        }
        
    }
}

@end
