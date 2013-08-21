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
                                   VIEW_SIZE_HEIGHT/2);
    [self addChild:self.myLabel];
    NSLog(@"%f, %f", self.myLabel.position.x, self.myLabel.position.y);
    
    self.hero = [[CBRobot alloc] initAtPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    [self addChild:self.hero];
    self.moveToPoint = self.hero.position;
}

-(void)addPhysicsWall{
    SKNode *ground = [[SKNode alloc] init];
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, VIEW_SIZE_WIDHT, VIEW_SIZE_HEIGHT), nil);
    ground.physicsBody = [ground physicsBodyWithEdgeLoopFromPath:path];
//    ground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    ground.physicsBody.restitution = 0;
//    ground.physicsBody.friction = 0.1;
    
    [self addChild:ground];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        self.moveToPoint = location;
        NSLog(@"%f, %f", location.x, location.y);

//        if (self.hero.requestedAnimation == CBAnimationStateIdle) {
//            self.hero.requestedAnimation = CBAnimationStateRun;
//        }
//        else{
//            self.hero.requestedAnimation = CBAnimationStateIdle;
//        }
        
//        [self.hero.physicsBody applyImpulse:CGVectorMake(40, 40)];
//        if (self.heroMoveDirection == CBMoveDirectionRight) {
//            self.heroMoveDirection = CBMoveDirectionLeft;
//        }else{
//            self.heroMoveDirection = CBMoveDirectionRight;
//        }
        
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

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast {
    // Overridden by subclasses.
    [self.hero updateWithTimeSinceLastUpdate:timeSinceLast];
//    [self.hero move:self.heroMoveDirection withTimeInterval:timeSinceLast];
    [self.hero moveTowards:self.moveToPoint withTimeInterval:timeSinceLast];
    
    
    self.myLabel.text = [NSString stringWithFormat:@"%hhu", self.hero.requestedAnimation];
}

@end
