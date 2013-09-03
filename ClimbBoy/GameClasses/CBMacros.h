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


#endif
