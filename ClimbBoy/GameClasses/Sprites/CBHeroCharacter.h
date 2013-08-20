//
//  CBHeroCharacter.h
//  ClimbBoy
//
//  Created by Robin on 13-8-20.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import "CBCharacter.h"

@interface CBHeroCharacter : CBCharacter

/* Designated Initializer. */
- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position;

- (id)initAtPosition:(CGPoint)position;

@end
