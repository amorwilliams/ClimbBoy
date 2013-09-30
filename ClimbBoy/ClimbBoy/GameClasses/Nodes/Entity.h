//
//  Entity.h
//  ClimbBoy
//
//  Created by Robin on 13-9-29.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

/* Bitmask for the different entities with physics bodies. */
typedef enum : uint8_t {
    kContactCategoryWorld               = 0,
    kContactCategoryPlayer              = 1 << 0,
    kContactCategoryPickupItem          = 1 << 1,
    kContactCategoryTrigger             = 1 << 2,
    kContactCategoryStaticObject        = 1 << 3
} ContactCategoryType;

typedef enum : uint8_t {
    kCBAxisTypeX = 0,
    kCBAxisTypeY,
    kCBAxisTypeXY,
} CBAxisType;

#import "KKNode.h"

@interface Entity : KKNode <KKPhysicsContactEventDelegate>
- (void) didBeginContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody;
- (void) didEndContact:(SKPhysicsContact *)contact otherBody:(SKPhysicsBody *)otherBody;
@end
