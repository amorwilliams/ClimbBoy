//
//  CBHeroCharacter.m
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "CBHeroCharacter.h"

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

@end
