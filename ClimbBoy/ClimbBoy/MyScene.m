/*
 * Copyright (c) 2013 Steffen Itterheim.
 * Released under the MIT License:
 * KoboldAid/licenses/KoboldKitFree.License.txt
 */

#import "MyScene.h"
#import "RemoveSpaceshipBehavior.h"
#import "spine-spirte-kit.h"
#import "ClimbBoy-ui.h"

@implementation MyScene

-(id) initWithSize:(CGSize)size
{
	self = [super initWithSize:size];
	if (self)
	{
		/* Setup your scene here */
		self.backgroundColor = [SKColor blackColor];
		
		SKLabelNode* myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
		myLabel.text = @"Hello, Kobold!";
		myLabel.fontSize = 60;
		myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        myLabel.alpha = 0.3;
		[self addChild:myLabel];
        
        _mapNode = [MapNode MapWithGridSize:CGSizeMake(64, 64)];
        [_mapNode setScale:0.3];
        [self addChild:_mapNode];
        [_mapNode generate];
        
        CBButton *generateButton = [CBButton buttonWithTitle:nil
                                                 spriteFrame:[SKSpriteNode spriteNodeWithImageNamed:@"button.png"]
                                         selectedSpriteFrame:[SKSpriteNode spriteNodeWithImageNamed:@"button-pressed.png"]
                                         disabledSpriteFrame:nil];
        [generateButton setScale:0.3];
        generateButton.zPosition = 10;
        generateButton.position = ccp(self.size.width - 20, self.size.height - 20);
        [self addChild:generateButton];
        [generateButton setTarget:self selector:@selector(clickRandom:)];
	}
	return self;
}

- (void)didMoveToView:(SKView *)view {

}

- (void)clickRandom:(id)sender
{
    [_mapNode removeFromParent];
    _mapNode = [MapNode MapWithGridSize:CGSizeMake(64, 64)];
    [_mapNode generate];
    [self addChild:_mapNode];
}


#if TARGET_OS_IPHONE // iOS
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	/* Called when a touch begins */
	
	for (UITouch* touch in touches)
	{
		 _location = [touch locationInNode:self];
        
	}
	
	// (optional) call super implementation to allow KKScene to dispatch touch events
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches) {
        CGPoint offset = ccpSub([touch locationInNode:self], _location);
        _mapNode.position = ccpAdd(_mapNode.position, offset);
        
        _location = [touch locationInNode:self];
    }
}
#else // Mac OS X
-(void) mouseDown:(NSEvent *)event
{
	/* Called when a mouse click occurs */
	
	CGPoint location = [event locationInNode:self];
//	[self addSpaceshipAt:location];

	// (optional) call super implementation to allow KKScene to dispatch mouse events
	[super mouseDown:event];
}
#endif

-(void) update:(CFTimeInterval)currentTime
{
	/* Called before each frame is rendered */
	
	// (optional) call super implementation to allow KKScene to dispatch update events
	[super update:currentTime];
}

@end
