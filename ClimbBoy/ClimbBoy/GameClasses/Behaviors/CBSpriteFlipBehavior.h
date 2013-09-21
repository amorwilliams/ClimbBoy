//
//  CBSpriteFlipBehavior.h
//  ClimbBoy
//
//  Created by Robin on 13-8-30.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKBehavior.h"

@interface CBSpriteFlipBehavior : KKBehavior

+ (id) SpriteFlipWithTarget:(SKSpriteNode *)target;

- (id) initWithTarget:(SKSpriteNode *)target;

@end
