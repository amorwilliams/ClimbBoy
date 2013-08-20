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

@interface CBMyScene(){
    SKLabelNode *myLabel;
}
@end

@implementation CBMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 10;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame) + 20);
        
        [self addChild:myLabel];
        
        
//        NSArray *idleFrames = CBLoadFramesFromAtlas(@"Hero_Idle", @"hero_idle_");
//        
//        
//        SKSpriteNode *hero = [SKSpriteNode spriteNodeWithTexture:[idleFrames firstObject]];
//        hero.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
//        [hero setScale:0.1];
//        [self addChild:hero];
//        
//        const NSTimeInterval kHeroAnimSpeed = 1/30.0;
//        SKAction *idleAnimAction = [SKAction repeatActionForever:[SKAction animateWithTextures:idleFrames
//                                                                                  timePerFrame:kHeroAnimSpeed
//                                                                                        resize:YES
//                                                                                       restore:YES]];
//        [hero runAction:idleAnimAction];
        
        [CBRobot loadSharedAssets];
        self.hero = [[CBRobot alloc] initAtPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
        [self addChild:self.hero];
        [self.hero setScale:0.1];
        self.hero.animationSpeed = 1/50.0;
//        self.hero.requestedAnimation = CBAnimationStateRun;
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
        
        if (self.hero.requestedAnimation == CBAnimationStateIdle) {
            self.hero.requestedAnimation = CBAnimationStateRun;
        }
        else{
            self.hero.requestedAnimation = CBAnimationStateIdle;
        }
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self.hero updateWithTimeSinceLastUpdate:currentTime];
    
    myLabel.text = [NSString stringWithFormat:@"%hhu", self.hero.requestedAnimation];
}

@end
