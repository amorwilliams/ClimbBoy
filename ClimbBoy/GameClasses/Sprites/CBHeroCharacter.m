//
//  CBHeroCharacter.m
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "CBHeroCharacter.h"

@interface CBHeroCharacter ()
@property (nonatomic) CGPoint moveToPoint;
@property (nonatomic) CBMoveDirection heroMoveDirection;

@end

@implementation CBHeroCharacter

#pragma mark - Initialization
- (id)initAtPosition:(CGPoint)position {
    return [self initWithTexture:nil atPosition:position];
}

- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position {
    self = [super initWithTexture:texture atPosition:position];
    if (self) {
//        _player = player;
        
        // Rotate by PI radians (180 degrees) so hero faces down rather than toward wall at start of game.
//        self.zRotation = M_PI;
//        self.zPosition = -0.25;
        self.name = [NSString stringWithFormat:@"Hero"];
    }
    
    return self;
}

- (void)didMoveToParent {
    [super didMoveToParent];
    [self observeInputEvents];
    self.moveToPoint = self.position;
    self.heroMoveDirection = CBMoveDirectionRight;
}

#pragma mark - Overridden Methods
- (void)configurePhysicsBody {
//    self.physicsBody = [self physicsBodyWithCircleOfRadius:self.collisionRadius];
//    self.physicsBody = [self physicsBodyWithRectangleOfSize:CGSizeMake(30, 38)];
    self.physicsBody = [self physicsBodyWithCapsule:self.collisionCapsule];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.restitution = 0;
    self.physicsBody.mass = 0.05;
//    self.physicsBody.usesPreciseCollisionDetection = YES;
//    self.physicsBody.friction = 1;

    // Our object type for collisions.
    self.physicsBody.categoryBitMask = CBColliderTypeHero;
    
    // Collides with these objects.
    self.physicsBody.collisionBitMask = CBColliderTypeGoblinOrBoss | CBColliderTypeHero | CBColliderTypeWall | CBColliderTypeCave;
    
    // We want notifications for colliding with these objects.
    self.physicsBody.contactTestBitMask = CBColliderTypeGoblinOrBoss | CBColliderTypeWall;
}

- (void)performJump{
    if (self.isJumping) {
        return;
    }
    
    if (self.isClimbing) {
        self.climbing = NO;
        self.wallJumping = YES;
        CGVector dir = ccvNormalize(self.touchSideNormal);
        NSLog(@"%f, %f", self.touchSideNormal.dx, self.touchSideNormal.dy);
        [self.physicsBody applyImpulse:CGVectorMake(dir.dx * 30, 40)];
    }else{
        [self.physicsBody applyImpulse:CGVectorMake(0, 40)];
    }
    
    [super performJump];

}

- (void)onGrounded{
    [super onGrounded];
    NSLog(@"onGrounded");
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval{
    [super updateWithTimeSinceLastUpdate:interval];
    
    [self moveTowards:self.moveToPoint withTimeInterval:interval];
}

- (void)move:(CBMoveDirection)direction bySpeed:(CGFloat)speed withTimeInterval:(NSTimeInterval)timeInterval{
    if (self.isClimbing) {
        [self climb:direction withTimeInterval:timeInterval];
    }else{
        [super move:direction bySpeed:speed withTimeInterval:timeInterval];
    }
}

- (void)moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval {
    if (self.isClimbing) {
        [self climb:CBMoveDirectionRight withTimeInterval:timeInterval];
    }else{
        [super moveTowards:position withTimeInterval:timeInterval];
    }
}

#pragma mark - Input Observer
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInNode:self];
    NSLog(@"%f, %f", location.x, location.y);
    
    if ([touch tapCount] == 1) {
        self.moveToPoint = [self convertPoint:location toNode:self.kkScene];
        if (location.x > self.position.x) {
            self.heroMoveDirection = CBMoveDirectionRight;
        }else{
            self.heroMoveDirection = CBMoveDirectionLeft;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInNode:self];
    if (fabsf(self.position.x - location.x) > 50) {
        self.moveToPoint = [self convertPoint:location toNode:self.kkScene];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([touch tapCount] == 2) {
        [self performJump];
    }
}




@end
