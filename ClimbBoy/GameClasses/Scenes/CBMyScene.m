//
//  CBMyScene.m
//  ClimbBoy
//
//  Created by Robin on 13-8-19.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "CBMyScene.h"
#import "CBGraphicsUtilities.h"
#import "CBRobot.h"

#define VIEW_SIZE_WIDHT 568
#define VIEW_SIZE_HEIGHT 320

@interface CBMyScene()
@property (nonatomic) SKLabelNode *myLabel;
@property (nonatomic) CFTimeInterval lastUpdateTimeInterval;
@end

@implementation CBMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [CBRobot loadSharedAssets];
        
        [self buildWorld];
        [self addButtons];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    [self addTitle];
    [self addHero];
    
//    KKCameraFollowBehavior *cameraFollow = [KKCameraFollowBehavior behavior];
//    cameraFollow.node = self.hero;
//    [self addBehavior:cameraFollow withKey:@"Camera"];
}

- (void)addButtons {
    SKLabelNode *backButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backButton.text = @"Back";
    backButton.fontSize = 20;
    backButton.zPosition = 1;
    backButton.position = CGPointMake(CGRectGetMaxX(self.frame) - 50, CGRectGetMaxY(self.frame) - 30);
    [self addChild:backButton];
    
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

- (void)buildWorld {
    NSLog(@"Building the world");

//    self.physicsWorld.gravity = CGPointZero;
    self.physicsWorld.contactDelegate = self;
    [self addCollisionWalls];
}

- (void)addCollisionWalls {
    [self addCollisionWallAtWorldPoint:ccp(0, 20) withWidth:VIEW_SIZE_WIDHT height:20];
    [self addCollisionWallAtWorldPoint:ccp(0, VIEW_SIZE_HEIGHT) withWidth:VIEW_SIZE_WIDHT height:20];
    [self addCollisionWallAtWorldPoint:ccp(0, VIEW_SIZE_HEIGHT) withWidth:20 height:VIEW_SIZE_HEIGHT];
    [self addCollisionWallAtWorldPoint:ccp(VIEW_SIZE_WIDHT-20, VIEW_SIZE_HEIGHT) withWidth:20 height:VIEW_SIZE_HEIGHT];
    
    [self addCollisionWallAtWorldPoint:ccp(VIEW_SIZE_WIDHT/2, VIEW_SIZE_HEIGHT/2) withWidth:20 height:VIEW_SIZE_HEIGHT/2];

}

- (void)addCollisionWallAtWorldPoint:(CGPoint)worldPoint withWidth:(CGFloat)width height:(CGFloat)height {
    CGRect rect = CGRectMake(0, 0, width, height);
    
    SKNode *wallNode = [SKNode node];
    wallNode.position = CGPointMake(worldPoint.x + rect.size.width * 0.5, worldPoint.y - rect.size.height * 0.5);
    wallNode.physicsBody = [wallNode physicsBodyWithRectangleOfSize:rect.size];
    wallNode.physicsBody.dynamic = NO;
    wallNode.physicsBody.restitution = 0;
    wallNode.physicsBody.categoryBitMask = CBColliderTypeWall;
    wallNode.physicsBody.collisionBitMask = 0;
    
    [self addChild:wallNode];
}

- (void)addTitle {
    self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.myLabel.text = @"Hello, World!";
    self.myLabel.fontSize = 10;
    self.myLabel.position = CGPointMake(VIEW_SIZE_WIDHT/2,
                                        VIEW_SIZE_HEIGHT/2 + 100);
    [self addChild:self.myLabel];
    NSLog(@"%f, %f", self.myLabel.position.x, self.myLabel.position.y);
}

- (void)addHero {
    self.hero = [[CBRobot alloc] initAtPosition:CGPointMake(100,100)];
    [self addChild:self.hero];
}



#pragma mark - Loop Update
-(void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
    self.myLabel.text = [NSString stringWithFormat:@"%@", self.hero.activeAnimationKey];
}
@end
