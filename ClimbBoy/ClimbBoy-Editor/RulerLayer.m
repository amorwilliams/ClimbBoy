//
//  RulerLayer.m
//  ClimbBoy
//
//  Created by Robin on 13-10-27.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "RulerLayer.h"
#import "SpriteKitScene.h"

#define kCCBRulerWidth 15

@implementation RulerLayer

- (id)init
{
    self = [super init];
    if (self) {
        bgVertical = [SKSpriteNode spriteNodeWithImageNamed:@"ruler-bg-vertical.png"];
        bgVertical.anchorPoint = ccp(0,0);
        
        bgHorizontal = [SKSpriteNode spriteNodeWithImageNamed:@"ruler-bg-horizontal.png"];
        bgHorizontal.anchorPoint = ccp(0,0);
        
        [self addChild:bgVertical];
        [self addChild:bgHorizontal];
        
        marksVertical = [SKNode node];
        marksHorizontal = [SKNode node];
        [self addChild:marksVertical];
        [self addChild:marksHorizontal];
        
        mouseMarkVertical = [SKSpriteNode spriteNodeWithImageNamed:@"ruler-guide.png"];
        mouseMarkVertical.anchorPoint = ccp(0, 0.5f);
        mouseMarkVertical.hidden = YES;
        [self addChild:mouseMarkVertical];
        
        mouseMarkHorizontal = [SKSpriteNode spriteNodeWithImageNamed:@"ruler-guide.png"];
        mouseMarkHorizontal.zRotation = KK_DEG2RAD(90);
        mouseMarkHorizontal.anchorPoint = ccp(0, 0.5f);
        mouseMarkHorizontal.hidden = YES;
        [self addChild:mouseMarkHorizontal];
        
        SKSpriteNode* xyBg = [SKSpriteNode spriteNodeWithImageNamed:@"ruler-xy.png"];
        [self addChild:xyBg];
        xyBg.anchorPoint = ccp(0,0);
        xyBg.zPosition = 2;
        xyBg.position = ccp(0,0);
        
        lblX = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
        lblX.text = @"0";
        lblX.fontSize = 9;
        lblX.fontColor = [SKColor blackColor];
        lblX.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        lblX.position = ccp(32,3);
        lblX.zPosition = 2;
        lblX.hidden = YES;
        [self addChild:lblX];
        
        lblY = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
        lblY.text = @"0";
        lblY.fontSize = 9;
        lblY.fontColor = [SKColor blackColor];
        lblY.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        lblY.position = ccp(82,3);
        lblY.zPosition = 2;
        lblY.hidden = YES;
        [self addChild:lblY];
        //lblY = [CCLabelAtlas labelWithString:@"0" charMapFile:@"ruler-numbers.png" itemWidth:6 itemHeight:8 startCharMap:'0'];
        
        return self;
    }
    return self;
}

- (void)updateWithSize:(CGSize)ws stageOrigin:(CGPoint)so zoom:(float)zm
{
    stageOrigin.x = (int) stageOrigin.x;
    stageOrigin.y = (int) stageOrigin.y;
    
    if (CGSizeEqualToSize(ws, winSize)
        && CGPointEqualToPoint(so, stageOrigin)
        && zm == zoom)
    {
        return;
    }
    
    // Store values
    winSize = ws;
    stageOrigin = so;
    zoom = zm;
    
    // Resize backrounds
    bgHorizontal.size = CGSizeMake(winSize.width, kCCBRulerWidth);
    bgVertical.size = CGSizeMake(kCCBRulerWidth, winSize.height);
    
    // Add marks and numbers
    [marksVertical removeAllChildren];
    [marksHorizontal removeAllChildren];
    
    // Vertical marks
    int y = (int)so.y - (((int)so.y)/10)*10;
    while (y < winSize.height)
    {
        int yDist = abs(y - (int)stageOrigin.y);
        
        SKSpriteNode* mark = NULL;
        BOOL addLabel = NO;
        if (yDist == 0)
        {
            mark = [SKSpriteNode spriteNodeWithImageNamed:@"ruler-mark-origin.png"];
            addLabel = YES;
        }
        else if (yDist % 50 == 0)
        {
            mark = [SKSpriteNode spriteNodeWithImageNamed:@"ruler-mark-major.png"];
            addLabel = YES;
        }
        else
        {
            mark = [SKSpriteNode spriteNodeWithImageNamed:@"ruler-mark-minor.png"];
        }
        mark.anchorPoint = ccp(0, 0.5f);
        mark.position = ccp(0, y);
        [marksVertical addChild:mark];
        
        if (addLabel)
        {
            int displayDist = yDist / zoom;
            NSString* str = [NSString stringWithFormat:@"%d",displayDist];
            NSInteger strLen = [str length];
            
            for (int i = 0; i < strLen; i++)
            {
                NSString* ch = [str substringWithRange:NSMakeRange(i, 1)];
                
                SKLabelNode* lbl = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
                lbl.text = ch;
                lbl.fontSize = 9;
                lbl.fontColor = [SKColor blackColor];
                lbl.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
                lbl.position = ccp(5, y + 1 + 8* (strLen - i - 1));
                lbl.zPosition = 1;
                [marksVertical addChild:lbl];
            }
        }
        y+=10;
    }
    
    // Horizontal marks
    int x = (int)so.x - (((int)so.x)/10)*10;
    while (x < winSize.width)
    {
        int xDist = abs(x - (int)stageOrigin.x);
        
        SKSpriteNode* mark = NULL;
        BOOL addLabel = NO;
        if (xDist == 0)
        {
            mark = [SKSpriteNode spriteNodeWithImageNamed:@"ruler-mark-origin.png"];
            addLabel = YES;
        }
        else if (xDist % 50 == 0)
        {
            mark = [SKSpriteNode spriteNodeWithImageNamed:@"ruler-mark-major.png"];
            addLabel = YES;
        }
        else
        {
            mark = [SKSpriteNode spriteNodeWithImageNamed:@"ruler-mark-minor.png"];
        }
        mark.anchorPoint = ccp(0, 0.5f);
        mark.position = ccp(x, 0);
        mark.zRotation= KK_DEG2RAD(90);
        [marksHorizontal addChild:mark];
        
        
        if (addLabel)
        {
            int displayDist = xDist / zoom;
            NSString* str = [NSString stringWithFormat:@"%d",displayDist];
            
            SKLabelNode* lbl = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
            lbl.text = str;
            lbl.fontSize = 9;
            lbl.fontColor = [SKColor blackColor];
            lbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            lbl.position = ccp(x+1, 1);
            lbl.zPosition = 1;
            [marksHorizontal addChild:lbl];
        }
        x+=10;
    }
}

- (void)updateMousePos:(CGPoint)pos
{
    mouseMarkHorizontal.position = ccp(pos.x, 0);
    mouseMarkVertical.position = ccp(0, pos.y);
    
    SpriteKitScene* cs = [SpriteKitScene spriteKitScene];
    CGPoint docPos = [cs convertToDocSpace:pos];
    [lblX setText:[NSString stringWithFormat:@"%d",(int)docPos.x]];
    [lblY setText:[NSString stringWithFormat:@"%d",(int)docPos.y]];
}

- (void)mouseEntered:(NSEvent *)event
{
    mouseMarkHorizontal.hidden = NO;
    mouseMarkVertical.hidden = NO;
    lblX.hidden = NO;
    lblY.hidden = NO;
}

- (void)mouseExited:(NSEvent *)event
{
    mouseMarkHorizontal.hidden = YES;
    mouseMarkVertical.hidden = YES;
    lblX.hidden = YES;
    lblY.hidden = YES;
}

@end
