//
//  CharacterPhysicsBehavior.m
//  ClimbBoy
//
//  Created by Robin on 13-9-28.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "CharacterPhysicsBehavior.h"
#import "CBMacros.h"
#import "Debug.h"

static const int collisionDivisionsX = 3;
static const int collisionDivisionsY = 3;
static const float skin = 10;

@implementation CharacterPhysicsBehavior

- (void)didInitialize
{

}

- (void)didJoinController
{
    _character = (BaseCharacter *)self.node;
    _size = _character.boundingBox;
    _center = CGPointZero;
    [self.node.kkScene addSceneEventsObserver:self];
}

- (void)didLeaveController
{
    [self.node.kkScene removeSceneEventsObserver:self];
}

-(void) didEvaluateActions
{
    if (!_character) {
        return;
    }
    
    const CGPoint p = [self.node convertPoint:CGPointZero toNode:self.node.kkScene];
    
    //---------------------------- find body below player -------------------------------------
    __block BOOL rayHitBottom = NO;
	for (int i = 0; i < collisionDivisionsX; i++) {
        CGPoint rayStart = CGPointMake((p.x - _size.width/2) + _size.width/(collisionDivisionsX-1) * i , p.y);
        CGPoint rayEnd = CGPointMake(rayStart.x, rayStart.y -(_size.height/2 + skin));
        
        [Debug drawLineStart:rayStart end:rayEnd];
        
        SKPhysicsWorld* physicsWorld = _character.kkScene.physicsWorld;
        [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
            if (body.contactTestBitMask < 1){
                if (!self.isGrounded) {
                    [self onGrounded];
                }
                rayHitBottom = YES;
                *stop = YES;
            }
		}];
        
        if (rayHitBottom) {
            break;
        }
    }
    _grounded = rayHitBottom;

    
    //---------------------------- find body up player -------------------------------------
    __block BOOL rayHitTop = NO;
    for (int i = 0; i < collisionDivisionsX; i++) {
        CGPoint rayStart = CGPointMake((p.x - _size.width/2) + _size.width/(collisionDivisionsX-1) * i , p.y);
        CGPoint rayEnd = CGPointMake(rayStart.x, rayStart.y + _size.height/2 + skin);
        
        [Debug drawLineStart:rayStart end:rayEnd];
        
        SKPhysicsWorld* physicsWorld = _character.kkScene.physicsWorld;
        [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
            if (body.contactTestBitMask < 1){

                if (!self.isTouchTop) {
                    [self onTouchTop];
                }
                rayHitTop = YES;
                *stop = YES;
            }
		}];
        
        if (rayHitTop) {
            break;
        }
    }
    _touchTop = rayHitTop;
    
    //---------------------------- find body left or right player -------------------------------------
    __block BOOL rayHitSide = NO;
    int dir = _character.characterSprite.flipX ? -1 : 1;
    for (int i = 0; i < collisionDivisionsY; i++)
    {
        CGPoint rayStart = CGPointMake(p.x, (p.y - _size.height/2) + _size.height/(collisionDivisionsY-1) * i);
        CGPoint rayEnd = CGPointMake(rayStart.x + (_size.width/2 + skin) * dir, rayStart.y);
        
        [Debug drawLineStart:rayStart end:rayEnd];
        
        SKPhysicsWorld* physicsWorld = _character.kkScene.physicsWorld;
        [physicsWorld enumerateBodiesAlongRayStart:rayStart end:rayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
            if (body.contactTestBitMask <= 1){
                if (!self.isTouchSide) {
                    [self onTouchSide];
                }
                rayHitSide = YES;
                *stop = YES;
            }
        }];
        
        if (rayHitSide) {
            break;
        }
    }
    
    _touchSide = rayHitSide;
}

- (void)onGrounded
{
    if ([_character respondsToSelector:@selector(onGrounded)]) {
        [_character onGrounded];
    }
}

- (void)onTouchTop
{
    if ([_character respondsToSelector:@selector(onTouchTop)]) {
        [_character onTouchTop];
    }
}

- (void)onTouchSide
{
    if ([_character respondsToSelector:@selector(onTouchSide)]) {
        [_character onTouchSide];
    }
}

@end
