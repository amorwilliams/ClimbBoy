//
//  SKNode(ClimbBoy).h
//  ClimbBoy
//
//  Created by Robin on 13-8-21.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

/** Capsule for collision shape **/
struct CBCapsule {
    CGFloat radius;
    CGFloat height;
};
typedef struct CBCapsule CBCapsule;

static inline CBCapsule CBCapsuleMake(CGFloat radius, CGFloat height)
{
    CBCapsule capsule; capsule.radius = radius; capsule.height = height; return capsule;
}

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>


@interface SKNode (CBExtension)

/** A tag used to identify the node easily */
@property(SK_NONATOMIC_IOSONLY) NSInteger tag;
@property (SK_NONATOMIC_IOSONLY) BOOL flipX;
@property (SK_NONATOMIC_IOSONLY) BOOL flipY;

- (void)addChild:(SKNode *)node tag:(NSInteger)tag;
- (void)insertChild:(SKNode *)node atIndex:(NSInteger)index tag:(NSInteger)tag;
- (void)removeChildByTag:(NSInteger)tag;
- (NSArray *)getChildByTag:(NSInteger)tag;

- (void)removeActionByTag:(NSInteger)tag;

-(SKPhysicsBody *) physicsBodyWithCircleOfRadius:(CGFloat)radius;
-(SKPhysicsBody *) physicsBodyWithCapsule:(CBCapsule)capsule;


@end
