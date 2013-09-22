//
//  GameData.h
//  ClimbBoy
//
//  Created by Robin on 13-9-22.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBMacros.h"

@interface GameData : NSObject
{
    
}
DEFINE_SINGLETON_FOR_HEADER(GameData)

@property (nonatomic) NSMutableArray *levels;
@property (nonatomic) NSMutableDictionary *settings;

@end
