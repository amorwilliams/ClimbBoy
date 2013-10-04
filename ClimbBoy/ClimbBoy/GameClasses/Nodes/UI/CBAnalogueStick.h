//
//  CBAnalogueStick.h
//  ClimbBoy
//
//  Created by Robin on 13-10-4.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CBControl.h"

@class CBAnalogueStick;
@protocol CBAnalogueStickDelegate <NSObject>

@optional
- (void)analogueStickDidChangeValue:(CBAnalogueStick *)analogueStick;

@end

@interface CBAnalogueStick : CBControl
+ (id) StickWithHandle:(SKSpriteNode *)handleSprite background:(SKSpriteNode *)backgroundSprite;

- (id) initWithHandle:(SKSpriteNode *)handleSprite background:(SKSpriteNode *)backgroundSprite;

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat deadZone;
@property (nonatomic, readonly) CGFloat xValue;
@property (nonatomic, readonly) CGFloat yValue;
@property (nonatomic, assign) BOOL invertedYAxis;

@property (nonatomic, assign) id <CBAnalogueStickDelegate> delegate;

@property (nonatomic, readonly) SKSpriteNode *backgroundSprite;
@property (nonatomic, readonly) SKSpriteNode *handleSprite;

@end
