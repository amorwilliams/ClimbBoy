//
//  PlaceItemContainerBehavior.m
//  ClimbBoy
//
//  Created by Robin on 13-10-3.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "PlaceItemContainerBehavior.h"
#import "ClimbBoy-ui.h"
#import "GameplayScene.h"

@implementation PlaceItemContainerBehavior

- (void)didInitialize
{
    _actived = NO;
}

- (void)didJoinController
{
    _container = [KKNode node];
    [self.node addChild:_container];
    _container.position = CGPointZero;
    _container.zPosition = 10;
    [self.node.kkScene addInputEventsObserver:self];

}

- (void)didLeaveController
{
    [_container removeFromParent];
    _container = nil;
    [self.node.kkScene removeInputEventsObserver:self];
}

//- (void) update:(NSTimeInterval)currentTime
//{
//    if (_actived) {
//    }
//}

- (void) setupContainer
{
    CGPoint dir = ccp(0, 80);
    CGFloat delay = 0;
    const int count = 3;
    for (int i = 0; i < count; i++)
    {
        CBButton *itemBtn = [CBButton buttonWithTitle:nil
                      spriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Bg_Normal.png"]
              selectedSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Bg_Disable.png"]
              disabledSpriteFrame:[KKSpriteNode spriteNodeWithImageNamed:@"Button_Bg_Disable.png"]];
        itemBtn.name = [NSString stringWithFormat:@"Level%02d", i+1];
//        levelButton.position = position;
        itemBtn.userData = [NSMutableDictionary dictionaryWithDictionary:@{@"id": [NSString stringWithFormat:@"%02d", i+1]}];
        itemBtn.title = [NSString stringWithFormat:@"%02d", i+1];
        itemBtn.label.fontName = @"Chalkduster";
        itemBtn.label.fontSize = 20;
        itemBtn.label.fontColor = [SKColor yellowColor];
        itemBtn.executesWhenPressed = YES;
        [_container addChild:itemBtn];
        
        itemBtn.alpha = 0;
        [itemBtn setScale:0];
        
        dir = ccpRotateByAngle(dir, CGPointZero, KK_DEG2RAD(360/count));
        delay += 0.1;
        SKAction *fadeIn = [SKAction group:@[[SKAction scaleTo:1 duration:0.2],
                                             [SKAction moveByX:dir.x y:dir.y duration:0.2],
                                             [SKAction fadeInWithDuration:0.2]]];
        fadeIn.timingMode = SKActionTimingEaseInEaseOut;
        [itemBtn runAction:[SKAction sequence:@[[SKAction waitForDuration:delay], fadeIn]]
                completion:^{
            [itemBtn setTarget:self selector:@selector(didSelectItem:)];
            [itemBtn setScale:1];
        }];
    }
}

- (void) clearContainer
{
    for (KKNode *node in [_container children]) {
        CBButton *btn = (CBButton *)node;
        btn.enabled = NO;
        
        SKAction *fadeOut = [SKAction group:@[[SKAction moveByX:btn.position.x y:btn.position.y duration:0.3], [SKAction fadeOutWithDuration:0.3]]];
        fadeOut.timingMode = SKActionTimingEaseInEaseOut;
        [node runAction:fadeOut completion:^{
            [btn removeFromParent];
        }];
    }
}

- (void) didSelectItem:(id)sender
{
    CBButton *button = (CBButton *)sender;
//    NSDictionary *itemData = button.userData;
    int index = [button.name intValue];
    
//    KKEmitterNode *emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle2" ofType:@"sks"]];
    //            _emitter.position = location;
//    emitter.targetNode = self.node.parent;
    
    SKSpriteNode *emitter = [SKSpriteNode spriteNodeWithImageNamed:@"dummy_case.png"];
    emitter.anchorPoint = ccp(0.5, 0.5);
    emitter.physicsBody = [emitter physicsBodyWithRectangleOfSize:CGSizeMake(20, 20)];
    emitter.physicsBody.allowsRotation = NO;
    emitter.physicsBody.categoryBitMask = kContactCategoryPickupItem;
    emitter.physicsBody.collisionBitMask = kContactCategoryPlayer;
    emitter.physicsBody.dynamic = NO;
    [self.node.parent.parent addChild:emitter];
    
    PlaceItemBehavior *placeItemBehavior = (PlaceItemBehavior *)[self.node behaviorMemberOfClass:[PlaceItemBehavior class]];
    if (placeItemBehavior) {
        placeItemBehavior.item = emitter;
        placeItemBehavior.trackedTouch = button.tracking;
    }
    
    NSLog(@"Selected item : %d", index);
    [self clearContainer];
    _actived = NO;
}

#pragma mark Input Events

#if TARGET_OS_IPHONE
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.enabled)
	{
		for (UITouch* touch in touches)
		{
            if (!_actived)
            {
//                GameplayScene *scene = (GameplayScene *)self.node.kkScene;
                if ([self.node containsPoint:[touch locationInNode:self.node.parent]]
                    && _container.children.count <= 0) {
                    NSLog(@"active");
                    [self setupContainer];
                    _actived = YES;
//                    [self.node.kkScene addSceneEventsObserver:self];
                }
            }
            else
            {
                GameplayScene *scene = (GameplayScene *)self.node.kkScene;
                if (![scene hasHUDAtPoint:[touch locationInNode:self.node.kkScene]]) {
                    NSLog(@"deactive");
                    [self clearContainer];
                    _actived = NO;
//                [self.node.kkScene removeSceneEventsObserver:self];
                }
            }
            break;
		}
	}
}

#else // Mac OS X

#endif

@end
