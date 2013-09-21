//
//  DebugNodeTestScene.m
//  ClimbBoy
//
//  Created by Robin on 13-9-19.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "DebugNodeTestScene.h"
#import "CBDebug.h"

@interface DebugNodeTestScene ()
{
    CGPoint _endPoint;
    
}
@end

@implementation DebugNodeTestScene

- (id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        /* Setup your scene here */
		self.backgroundColor = [SKColor colorWithRed:0.4 green:0.0 blue:0.4 alpha:1.0];
		
		SKLabelNode* myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
		myLabel.text = @"Debug Draw Test";
		myLabel.fontSize = 30;
		myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
		[self addChild:myLabel];
        
        
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [self addChild:[CBDebug sharedCBDebug]];
    _endPoint = ccp(300, 200);
}

- (void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
}

- (void)didSimulatePhysics {
    [super didSimulatePhysics];
    [CBDebug drawLineStart:ccp(200, 200) end:_endPoint];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    
    _endPoint = location;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    
    _endPoint = location;
}



@end
