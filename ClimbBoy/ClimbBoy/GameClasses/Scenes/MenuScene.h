//
//  MainMenu.h
//  ClimbBoy
//
//  Created by Robin on 13-9-2.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKScene.h"
#import "spine-spirte-kit.h"
#import "ClimbBoy-ui.h"

@interface MenuScene : KKScene
{
    CBSpineSprite *_menuAnimationSprite;
    CBButton *_startGameButton;
    CBButton *_optionsButton;
    CBButton *_creditsButton;
}
@end
