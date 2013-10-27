//
//  LoadingScene.m
//  ClimbBoy
//
//  Created by Robin on 13-9-23.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "LoadingScene.h"
#import "GameplayScene.h"

@implementation LoadingScene

+ (KKScene *)sceneWithWithSize:(CGSize)size level:(NSDictionary *)level index:(int)index {
    return [[LoadingScene alloc] initWithSize:size level:level index:index];
}

- (id)initWithSize:(CGSize)size level:(NSDictionary *)level index:(int)index
{
    self = [super initWithSize:size];
    if (self) {
        _level = level;
        _index = index;
        
        _timer = 0;
        _loadingLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
		_loadingLabel.text = @"Loading.......";
		_loadingLabel.fontSize = 30;
		_loadingLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
		[self addChild:_loadingLabel];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    if (_level) {
        [self setup];
    }
}

- (void)willMoveFromView:(SKView *)view {
    _level = nil;
    [super willMoveFromView:view];
}


- (void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
    
    _timer += currentTime;
    _loadingLabel.text = [NSString stringWithFormat:@"loading : %d", (int)_timer];
}

static dispatch_queue_t loadingQueue = NULL;
- (void)setup {
    if (!loadingQueue) {
        loadingQueue = dispatch_queue_create("com.ClimbBoy.loadingQueue", NULL);
    }
    
    dispatch_async(loadingQueue, ^{
        @autoreleasepool {
            NSString *levelName = [_level objectForKey:@"Tilemap"];
            NSLog(@"load level file name: %@", levelName);
            SKScene *nextScene = [GameplayScene sceneWithSize:self.size tmxFile:levelName];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startMap:nextScene];
            });
        }
    });
}

- (void)startMap:(SKScene *)scene {
    [self.kkView presentScene:scene transition:[SKTransition fadeWithColor:[SKColor blackColor] duration:1]];
}

@end
