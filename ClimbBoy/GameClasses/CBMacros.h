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


/** Radians to Degrees and vice versa */
#define M_PI_180			0.01745329251994	/* pi/180           */
#define M_180_PI			57.29577951308233	/* 180/pi           */
#define CB_DEG2RAD(__ANGLE__) ((__ANGLE__) * M_PI_180)
#define CB_RAD2DEG(__ANGLE__) ((__ANGLE__) * M_180_PI)


/** simple random */
#define CBRANDOM_MINUS1_1()              ((random() / (float)0x3fffffff) - 1.0f)
#define CBRANDOM_0_1()                   ((random() / (float)0x7fffffff))

/** math **/
#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))


#endif
