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
#import "SKNode+CBExtension.h"
#import "SKSpriteNode+CBExtension.h"

#define VIEW_SIZE_WIDHT 568
#define VIEW_SIZE_HEIGHT 320

@interface CBMyScene()
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
        
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    NSLog(@"frame size: %f, %f, %f, %f",
          view.frame.origin.x,
          view.frame.origin.y,
          view.bounds.size.width,
          view.bounds.size.height);
    
    [self addPhysicsWall];
    
    self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.myLabel.text = @"Hello, World!";
    self.myLabel.fontSize = 10;
    self.myLabel.position = CGPointMake(VIEW_SIZE_WIDHT/2,
                                   VIEW_SIZE_HEIGHT/2 + 100);
    [self addChild:self.myLabel];
    NSLog(@"%f, %f", self.myLabel.position.x, self.myLabel.position.y);
    
    self.hero = [[CBRobot alloc] initAtPosition:CGPointMake(100,100)];
    [self addChild:self.hero];
    self.moveToPoint = self.hero.position;
}

-(void)addPhysicsWall{
    SKNode *ground = [[SKNode alloc] init];
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 20, VIEW_SIZE_WIDHT, VIEW_SIZE_HEIGHT - 20), nil);
    ground.physicsBody = [ground physicsBodyWithEdgeLoopFromPath:path];
//    ground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    ground.physicsBody.restitution = 0;
//    ground.physicsBody.friction = 0.1;
    
    [self addChild:ground];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInNode:self];
    NSLog(@"%f, %f", location.x, location.y);
    
    if ([touch tapCount] == 1) {
        self.moveToPoint = location;
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
    [self.hero didEvaluateActions];
//    NSLog(@"Hero grounded is %@", self.hero.isGrounded ? @"YES" : @"NO" );
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast {
    // Overridden by subclasses.
    [self.hero updateWithTimeSinceLastUpdate:timeSinceLast];
//    [self.hero move:self.heroMoveDirection withTimeInterval:timeSinceLast];
    [self.hero moveTowards:self.moveToPoint withTimeInterval:timeSinceLast];
    
    
    self.myLabel.text = [NSString stringWithFormat:@"%@", self.hero.activeAnimationKey];
}

@end
