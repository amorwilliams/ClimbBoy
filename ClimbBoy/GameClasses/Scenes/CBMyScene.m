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

@interface CBMyScene()<SKPhysicsContactDelegate>
@property (nonatomic) SKLabelNode *myLabel;
@property (nonatomic) CFTimeInterval lastUpdateTimeInterval;
@property (nonatomic) CBMoveDirection heroMoveDirection;
@property (nonatomic) CGPoint moveToPoint;
@end

@implementation CBMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.heroMoveDirection = CBMoveDirectionRight;
        
        [CBRobot loadSharedAssets];
        
        [self buildWorld];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    [self addTitle];
    [self addHero];
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
    self.moveToPoint = self.hero.position;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInNode:self];
    NSLog(@"%f, %f", location.x, location.y);
    
    if ([touch tapCount] == 1) {
        self.moveToPoint = location;
        if (location.x > self.hero.position.x) {
            self.heroMoveDirection = CBMoveDirectionRight;
        }else{
            self.heroMoveDirection = CBMoveDirectionLeft;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];

    CGPoint location = [touch locationInNode:self];
    if (fabsf(self.hero.position.x - location.x) > 50) {
        self.moveToPoint = location;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([touch tapCount] == 2) {
        [self.hero performJump];
    }
}

#pragma mark - Loop Update
-(void)update:(CFTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = kMinTimeInterval;
        self.lastUpdateTimeInterval = currentTime;
//        self.worldMovedForUpdate = YES;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}

-(void)didEvaluateActions{
    
}

- (void)didSimulatePhysics {
    [self.hero didEvaluateActions];
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast {
    // Overridden by subclasses.
    [self.hero updateWithTimeSinceLastUpdate:timeSinceLast];
//    [self.hero move:self.heroMoveDirection withTimeInterval:timeSinceLast];
    [self.hero moveTowards:self.moveToPoint withTimeInterval:timeSinceLast];
    
    
    self.myLabel.text = [NSString stringWithFormat:@"%@", self.hero.activeAnimationKey];
}

#pragma mark - Physics Delegate
- (void)didBeginContact:(SKPhysicsContact *)contact{
    // Either bodyA or bodyB in the collision could be a character.
    SKNode *node = contact.bodyA.node;
    if ([node isKindOfClass:[CBCharacter class]]) {
        [(CBCharacter *)node collidedWith:contact.bodyB];
    }
    
    // Check bodyB too.
    node = contact.bodyB.node;
    if ([node isKindOfClass:[CBCharacter class]]) {
        [(CBCharacter *)node collidedWith:contact.bodyA];
    }
}
@end
