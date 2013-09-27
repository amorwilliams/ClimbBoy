//
//  LevelsMenu.h
//  ClimbBoy
//
//  Created by Robin on 13-9-2.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKScene.h"
#import "ClimbBoy-ui.h"

@interface MapScene : KKScene
{
    KKSpriteNode *_mapBoard;
    
    CBButton *_homeButton;
    CBButton *_shopButton;
    CBButton *_previousButton;
    CBButton *_nextButton;
}

@end
