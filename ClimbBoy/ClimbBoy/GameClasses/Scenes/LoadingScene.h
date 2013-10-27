//
//  LoadingScene.h
//  ClimbBoy
//
//  Created by Robin on 13-9-23.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKScene.h"

@interface LoadingScene : KKScene
{
    SKLabelNode *_loadingLabel;
    int _timer;
}

@property (atomic, readonly) int index;
@property (atomic, readonly) NSDictionary *level;

+ (KKScene *)sceneWithWithSize:(CGSize)size level:(NSDictionary *)level index:(int)index;
- (id)initWithSize:(CGSize)size level:(NSDictionary *)level index:(int)index;

@end
