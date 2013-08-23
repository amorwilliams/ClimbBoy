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

- (void)addChild:(SKNode *)node tag:(NSInteger)tag;
- (void)insertChild:(SKNode *)node atIndex:(NSInteger)index tag:(NSInteger)tag;
- (void)removeChildByTag:(NSInteger)tag;
- (NSArray *)getChildByTag:(NSInteger)tag;

- (void)removeActionByTag:(NSInteger)tag;

/** Called after addChild / insertChild. The self.scene and self.parent properties are valid in this method. */
-(void) didMoveToParent;
/** Called after removeFromParent and other remove child methods. The self.scene and self.parent properties are still valid. */
-(void) willMoveFromParent;

/** Creates a physics Body with edge loop shape. Also assigns the physics body to the node's self.physicsBody property.
 @param path The CGPath with edge points.
 @returns The newly created SKPhysicsBody. */
-(SKPhysicsBody *) physicsBodyWithEdgeLoopFromPath:(CGPathRef)path;
/** Creates a physics Body with edge chain shape. Also assigns the physics body to the node's self.physicsBody property.
 @param path The CGPath with chain points.
 @returns The newly created SKPhysicsBody. */
-(SKPhysicsBody *) physicsBodyWithEdgeChainFromPath:(CGPathRef)path;
/** Creates a physics Body with rectangle shape. Also assigns the physics body to the node's self.physicsBody property.
 @param size The size of the rectangle.
 @returns size The newly created SKPhysicsBody. */
-(SKPhysicsBody *) physicsBodyWithRectangleOfSize:(CGSize)size;
-(SKPhysicsBody *) physicsBodyWithCircleOfRadius:(CGFloat)radius;
-(SKPhysicsBody *) physicsBodyWithCapsule:(CBCapsule)capsule;


@end
