//
//  LevelTest.h
//  ClimbBoy
//
//  Created by Robin on 13-8-30.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKScene.h"
#import "HeroRobot.h"
#import "ClimbBoy-ui.h"

@interface GameplayScene : KKScene <CBAnalogueStickDelegate>
{
    NSString *_tmxFile;
    KKSpriteNode *_curtainSprite;
    
    KKTilemapNode *_tilemapNode;
    HeroCharacter *_playerCharacter;
    SKLabelNode *_debugInfo;
    
    SKEmitterNode *_emitter;
}
@property (nonatomic, readonly) KKViewOriginNode *hud;

+ (instancetype) sceneWithSize:(CGSize)size tmxFile:(NSString *)tmx;

- (instancetype) initWithSize:(CGSize)size tmxFile:(NSString *)tmx;

- (BOOL) hasHUDAtPoint:(CGPoint)point;

@end
