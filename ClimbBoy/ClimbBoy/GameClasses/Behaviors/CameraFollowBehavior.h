//
//  CameraFollowBehavior.h
//  ClimbBoy
//
//  Created by Robin on 13-10-13.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "KKBehavior.h"

@interface CameraFollowBehavior : KKBehavior

@property (atomic, weak) SKNode* scrollingNode;

@end
