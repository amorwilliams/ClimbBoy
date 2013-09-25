//
//  MainMenu.h
//  ClimbBoy
//
//  Created by Robin on 13-9-2.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKScene.h"
#import "spine-spirte-kit.h"

@interface MenuScene : KKScene
{
    CBSpineSprite *_menuAnimationSprite;
    KKSpriteNode *_startGameButton;
    KKSpriteNode *_optionsButton;
    KKSpriteNode *_creditsButton;
}
@end
