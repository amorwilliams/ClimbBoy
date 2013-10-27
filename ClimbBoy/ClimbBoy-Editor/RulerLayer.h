//
//  RulerLayer.h
//  ClimbBoy
//
//  Created by Robin on 13-10-27.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface RulerLayer : SKNode
{
    SKSpriteNode* bgHorizontal;
    SKSpriteNode* bgVertical;
    
    SKNode* marksVertical;
    SKNode* marksHorizontal;
    
    SKSpriteNode* mouseMarkHorizontal;
    SKSpriteNode* mouseMarkVertical;
    
    CGSize winSize;
    CGPoint stageOrigin;
    float zoom;
    
    SKLabelNode* lblX;
    SKLabelNode* lblY;
}

- (void)updateWithSize:(CGSize)winSize stageOrigin:(CGPoint)stageOrigin zoom:(float)zoom;

- (void)updateMousePos:(CGPoint)pos;

@end
