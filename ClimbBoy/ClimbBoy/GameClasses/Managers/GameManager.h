//
//  GameData.h
//  ClimbBoy
//
//  Created by Robin on 13-9-22.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBMacros.h"

@interface GameManager : NSObject <NSCopying, NSCoding>
{
    
}
DEFINE_SINGLETON_FOR_HEADER(GameManager)

@property (nonatomic, weak) KKView *view;
@property (nonatomic) BOOL showsDebugNode;

@property (nonatomic) NSMutableArray *levels;
@property (nonatomic) NSMutableDictionary *settings;

+ (BOOL) showsDebugNode;

@end
