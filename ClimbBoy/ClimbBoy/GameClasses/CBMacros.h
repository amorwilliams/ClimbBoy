//
//  CBMacros.h
//  ClimbBoy
//
//  Created by Robin on 13-8-23.
//  Copyright (c) 2013年 macbookpro. All rights reserved.
//

#ifndef ClimbBoy_CBMacros_h
#define ClimbBoy_CBMacros_h

/** @file CBMacros.h */
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** math **/
#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

/** singleton **/
#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
    static className *shared##className = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared##className = [[self alloc] init]; \
    }); \
    return shared##className; \
}

#endif
