//
//  PlaceItemContainerBehavior.h
//  ClimbBoy
//
//  Created by Robin on 13-10-3.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKBehavior.h"

@interface PlaceItemContainerBehavior : KKBehavior
{
    KKNode *_container;
    NSMutableArray *_itemButtons;
    int _trackedTouch;
}

@property (nonatomic) BOOL actived;

@end
