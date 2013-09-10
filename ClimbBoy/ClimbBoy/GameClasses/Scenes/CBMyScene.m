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

#define VIEW_SIZE_WIDHT 1024
#define VIEW_SIZE_HEIGHT 768

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
        
        [self buildWorldWithSize:size];
        [self addButtons];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    [self addTitle];
    [self addHero];
}

- (void)addButtons {
    SKLabelNode *backButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    backButton.text = @"Back";
    backButton.fontSize = 40;
    backButton.zPosition = 1;
    backButton.position = CGPointMake(CGRectGetMaxX(self.frame) - 100, CGRectGetMaxY(self.frame) - 100);
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

- (void)buildWorldWithSize:(CGSize)size {
    NSLog(@"Building the world");

//    self.physicsWorld.gravity = CGPointZero;
    self.physicsWorld.contactDelegate = self;
    
    [self addCollisionWallAtWorldPoint:ccp(0, 20) withWidth:size.width height:20];
    [self addCollisionWallAtWorldPoint:ccp(0, size.height) withWidth:size.width height:20];
    [self addCollisionWallAtWorldPoint:ccp(0, size.height) withWidth:20 height:size.height];
    [self addCollisionWallAtWorldPoint:ccp(size.width-20, size.height) withWidth:20 height:size.height];
    [self addCollisionWallAtWorldPoint:ccp(size.width/2, size.height/2) withWidth:20 height:size.height/2];
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
    self.myLabel.fontSize = 40;
    self.myLabel.position = CGPointMake(self.frame.size.width/2,
                                        self.frame.size.height/2 + 100);
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
    self.myLabel.text = [NSString stringWithFormat:@"%@", self.hero.animatorBehavior.activeAnimationKey];
}
@end
