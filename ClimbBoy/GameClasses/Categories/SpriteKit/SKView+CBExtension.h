//
//  SKView.h
//  ClimbBoy
//
//  Created by Robin on 13-8-21.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKView (CBExtension)

/** If YES, will render physics shape outlines. */
@property (atomic) BOOL showsPhysicsShapes;
/** If YES, will render node outlines according to their frame property. */
@property (atomic) BOOL showsNodeFrames;
/** If YES, will render a dot on the node's position. */
@property (atomic) BOOL showsNodeAnchorPoints;

/** @returns Whether physics shape outlines are drawn. */
+(BOOL) showsPhysicsShapes;
/** @returns Whether node frame outlines are drawn. */
+(BOOL) showsNodeFrames;
/** @returns Whether node positions are drawn. */
+(BOOL) showsNodeAnchorPoints;

@end
