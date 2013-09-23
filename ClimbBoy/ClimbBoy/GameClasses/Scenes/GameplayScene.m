//
//  LevelTest.m
//  ClimbBoy
//
//  Created by Robin on 13-8-30.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "GameplayScene.h"
#import "HeroRobot.h"
#import "Debug.h"

#define VIEW_SIZE_WIDHT 568
#define VIEW_SIZE_HEIGHT 320

@interface GameplayScene ()
@property (atomic, retain)KKTilemapNode *tilemapNode;
@property (atomic, retain)HeroCharacter *playerCharacter;
@property (nonatomic) SKLabelNode *myLabel;

@end

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
        
        //test loading scene
        float a = 2423;
        float b = 3432;
        for (int i = 0; i < 300000000; i++) {
            a /= b;
        }

        [[OALSimpleAudio sharedInstance] playBg:@"Water Temple.mp3" loop:YES];

    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
//    [self addDebugNode];
    
    SKNode *mainLayerPhysics = [self.tilemapNode createPhysicsShapesWithTileLayerNode:self.tilemapNode.mainTileLayerNode];
    for (SKNode *node in mainLayerPhysics.children) {
        node.physicsBody.restitution = 0;
    }
    
    [_tilemapNode createPhysicsShapesWithObjectLayerNode:[_tilemapNode objectLayerNodeNamed:@"extra-collision"]];
    
    KKTilemapProperties *mapProperties = self.tilemapNode.tilemap.properties;
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
    
    [self addTitle];

    // remove the curtain
	[_curtainSprite runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1], [SKAction fadeAlphaTo:0 duration:0.5], [SKAction removeFromParent]]]];
	_curtainSprite = nil;
}

- (void)addDebugNode {
    Debug *debugNode = [Debug sharedDebug];
    [self addChild:debugNode];
    debugNode.zPosition = 100;
}

- (void)addTitle {
    self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.myLabel.text = @"Hello, World!";
    self.myLabel.fontSize = 15;
    self.myLabel.color = [UIColor blackColor];
    self.myLabel.position = CGPointMake(self.frame.size.width/2,
                                        self.frame.size.height - 40);
    KKViewOriginNode *hud = [KKViewOriginNode node];
    [self addChild:hud];
    
    [hud addChild:self.myLabel];
    
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
    [self.kkView popSceneWithTransition:[SKTransition fadeWithColor:[SKColor blackColor] duration:0.5]];
}

#pragma mark - Loop Update
-(void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
    self.myLabel.text = [NSString stringWithFormat:@"%@, velocity:%f,%f", _playerCharacter.animatorBehavior.activeAnimationKey, _playerCharacter.physicsBody.velocity.dx, _playerCharacter.physicsBody.velocity.dy];
}

-(void) createSimpleControls
{
	KKViewOriginNode* joypadNode = [KKViewOriginNode node];
	joypadNode.name = @"joypad";
	[self addChild:joypadNode];
    
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
    
	CGSize sceneSize = self.size;
	KKSpriteNode* jumpButtonNode = [KKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"button_jump_notpressed"]];
	jumpButtonNode.position = CGPointMake(sceneSize.width - (jumpButtonNode.size.width / 2 + 20), jumpButtonNode.size.height / 2 + 20);
	[joypadNode addChild:jumpButtonNode];
	
	KKButtonBehavior* button = [KKButtonBehavior new];
	button.name = @"jump";
	button.selectedTexture = [atlas textureNamed:@"button_jump_pressed"];
	button.executesWhenPressed = YES;
	button.selectedScale = 1.0;
	[jumpButtonNode addBehavior:button];
	
	// make player observe joypad
	[_playerCharacter observeNotification:KKControlPadDidChangeDirectionNotification
								 selector:@selector(controlPadDidChangeDirection:)
								   object:dpadNode];
	[_playerCharacter observeNotification:KKButtonDidExecuteNotification
								 selector:@selector(jumpButtonPressed:)
								   object:jumpButtonNode];
	[_playerCharacter observeNotification:KKButtonDidEndExecuteNotification
								 selector:@selector(jumpButtonReleased:)
								   object:jumpButtonNode];
}
@end
