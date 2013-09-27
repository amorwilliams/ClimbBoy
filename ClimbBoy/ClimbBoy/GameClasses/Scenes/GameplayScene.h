//
//  LevelTest.h
//  ClimbBoy
//
//  Created by Robin on 13-8-30.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKScene.h"
#import "ClimbBoy-ui.h"

@interface GameplayScene : KKScene
{
    NSString *_tmxFile;
    KKSpriteNode *_curtainSprite;
}
+ (instancetype) sceneWithSize:(CGSize)size tmxFile:(NSString *)tmx;

- (instancetype) initWithSize:(CGSize)size tmxFile:(NSString *)tmx;

@end
