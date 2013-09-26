//
//  CBControl.h
//  ClimbBoy
//
//  Created by Robin on 13-9-26.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/** The possible state for a control.  */
enum
{
    CBControlStateNormal       = 1 << 0, // The normal, or default state of a control—that is, enabled but neither selected nor highlighted.
    CBControlStateHighlighted  = 1 << 1, // Highlighted state of a control. A control enters this state when a touch down, drag inside or drag enter is performed. You can retrieve and set this value through the highlighted property.
    CBControlStateDisabled     = 1 << 2, // Disabled state of a control. This state indicates that the control is currently disabled. You can retrieve and set this value through the enabled property.
    CBControlStateSelected     = 1 << 3  // Selected state of a control. This state indicates that the control is currently selected. You can retrieve and set this value through the selected property.
};
typedef int CBControlState;



@interface CBControl : KKNode
{
     BOOL _needsLayout;
}

@property (nonatomic,assign) CGSize preferredSize;
//@property (nonatomic,assign) CCContentSizeType preferredSizeType;
@property (nonatomic,assign) CGSize maxSize;
//@property (nonatomic,assign) CCContentSizeType maxSizeType;

@property (nonatomic,assign) CBControlState state;
@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) BOOL highlighted;

@property (nonatomic,assign) BOOL continuous;

@property (nonatomic,readonly) BOOL tracking;
@property (nonatomic,readonly) BOOL touchInside;

@property (nonatomic,copy) void(^block)(id sender);

-(void) setTarget:(id)target selector:(SEL)selector;

- (void) triggerAction;
- (void) stateChanged;

//- (void) needsLayout;
//- (void) layout;

#if TARGET_OS_IPHONE
- (void) touchEntered:(UITouch*) touch withEvent:(UIEvent*)event;
- (void) touchExited:(UITouch*) touch withEvent:(UIEvent*) event;
- (void) touchUpInside:(UITouch*) touch withEvent:(UIEvent*) event;
- (void) touchUpOutside:(UITouch*) touch withEvent:(UIEvent*) event;
#else
- (void) mouseDownEntered:(NSEvent*) event;
- (void) mouseDownExited:(NSEvent*) event;
- (void) mouseUpInside:(NSEvent*) event;
- (void) mouseUpOutside:(NSEvent*) event;
#endif

@end
