//
//  Button.m
//  ClimbBoy
//
//  Created by Robin on 13-9-26.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "Button.h"

static NSString* const Prefix = @"Button";
static NSString* const Suffix_Normal = @"Normal";
static NSString* const Suffix_Clicked = @"Clicked";
static NSString* const Suffix_Disable = @"Disable";


@implementation Button

- (id)initWithButtonNamed:(NSString *)name scale:(CGFloat)scale
{
    NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@.png", Prefix, name, Suffix_Normal];
    self = [super initWithImageNamed:imageName];
    if (self) {
        self.name = name;
        self.zPosition = 1;
        [self setScale:scale];
        
        // KKButtonBehavior turns any node into a button
        KKButtonBehavior* startButtonBehavior = [KKButtonBehavior behavior];
        NSString *selectionImageName = [NSString stringWithFormat:@"%@_%@_%@.png", Prefix, name, Suffix_Clicked];
        startButtonBehavior.selectedTexture = [SKTexture textureWithImageNamed:selectionImageName];
//        startButtonBehavior.selectedScale = 1.2;
        [self addBehavior:startButtonBehavior withKey:@"button"];
        
        // observe button execute notification
        [self observeNotification:KKButtonDidExecuteNotification
                         selector:@selector(buttonDidExecute:)
                           object:self];
        
        [self observeNotification:KKButtonDidEndExecuteNotification
                         selector:@selector(buttonDidEndExecute:)
                           object:self];
    }
    return self;
}

- (void)buttonDidExecute:(NSNotification *)notification {
    
}

- (void)buttonDidEndExecute:(NSNotification *)notification {
    
}

@end
