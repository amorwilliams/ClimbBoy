//
//  LevelTest.m
//  ClimbBoy
//
//  Created by Robin on 13-8-30.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "LevelTest.h"
#import "CBRobot.h"

#define VIEW_SIZE_WIDHT 568
#define VIEW_SIZE_HEIGHT 320

@interface LevelTest ()
@property (atomic, retain)KKTilemapNode *tilemapNode;
@property (atomic, retain)CBRobot *playerCharacter;
@property (nonatomic) SKLabelNode *myLabel;

@end

@implementation LevelTest

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
//        self.backgroundColor = [UIColor blueColor];
        self.anchorPoint = CGPointMake(0.5f, 0.5f);

        [CBRobot loadSharedAssets];
        
        [[OALSimpleAudio sharedInstance] playBg:@"Water Temple.mp3" loop:YES];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    _tilemapNode = [KKTilemapNode tilemapWithContentsOfFile:@"DemoStage001.tmx"];
    [self addChild:_tilemapNode];
    
    [self.tilemapNode createPhysicsShapesWithTileLayerNode:self.tilemapNode.mainTileLayerNode];
    [_tilemapNode createPhysicsShapesWithObjectLayerNode:[_tilemapNode objectLayerNodeNamed:@"extra-collision"]];
    
    KKTilemapProperties *mapProperties = self.tilemapNode.tilemap.properties;
    self.physicsWorld.gravity = CGPointMake(0, [mapProperties numberForKey:@"physicsGravityY"].floatValue);
	self.physicsWorld.speed = [mapProperties numberForKey:@"physicsSimulationSpeed"].floatValue;
    if(self.physicsWorld.speed == 0.0){
        // compatibility fallback
        self.physicsWorld.speed = [mapProperties numberForKey:@"physicsSpeed"].floatValue;
    }
    
    _playerCharacter = [[CBRobot alloc] initAtPosition:CGPointMake(100,100)];
    [self.tilemapNode.gameObjectsLayerNode addChild:_playerCharacter];
    
    KKCameraFollowBehavior *b = [KKCameraFollowBehavior behavior];
    b.scrollingNode = self.tilemapNode.mainTileLayerNode;
    [_playerCharacter addBehavior:b withKey:@"KKCameraFollowBehavior"];
    
    [_tilemapNode enableParallaxScrolling];
    
    [self addTitle];
}

- (void)addTitle {
    self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.myLabel.text = @"Hello, World!";
    self.myLabel.fontSize = 10;
    self.myLabel.color = [UIColor blackColor];
    self.myLabel.position = CGPointMake(VIEW_SIZE_WIDHT/2,
                                        VIEW_SIZE_HEIGHT/2 + 100);
    KKViewOriginNode *hud = [KKViewOriginNode node];
    [self addChild:hud];
    
    [hud addChild:self.myLabel];
    NSLog(@"%f, %f", self.myLabel.position.x, self.myLabel.position.y);
}

#pragma mark - Loop Update
-(void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
    self.myLabel.text = [NSString stringWithFormat:@"%@", _playerCharacter.activeAnimationKey];
}

@end
