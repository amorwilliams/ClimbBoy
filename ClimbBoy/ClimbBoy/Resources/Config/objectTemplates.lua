-- objectTemplates.lua
-- Defines names of objects in Tileds to determine which ObjC classes to create
-- and which properties/ivars to set on these classes.

local kContactCategoryWorld = 0
local kContactCategoryPlayer = 1
local kContactCategoryPickupItem = 2
local kContactCategoryTrigger = 4
local kContactCategoryStaticObject = 8

local kGameObjectCollisionBitMask = 0xffffffff - (kContactCategoryPickupItem + kContactCategoryTrigger)

local objectTemplates =
{
	-- Behavior templates are not actually nodes but one or more behaviors that can be added to a node in Tiled
	-- with the behavior's properties taken from Tiled's properties
	FollowPath =
	{
		{className = "KKFollowPathBehavior"}, -- physics contact resolves in a remove of this node
	},

	-- default node types and their class names
	Node = {className = "KKNode"},
	SpriteNode = {className = "KKSpriteNode", tiledColor = "#ffffff"},
	LabelNode = {className = "KKLabelNode"},
	EmitterNode = {className = "KKEmitterNode", initMethod = "emitterWithFile:", initParam = "emitterFile"},
	ContactNotificationNode = {className = "KKContactNotificationNode", tiledColor = "#ff00ff"},
	-- not yet supported
	ShapeNode = {className = "KKShapeNode"},
	VideoNode = {className = "KKAutoplayVideoNode"},
	
    Trigger =
	{
		inheritsFrom = "ContactNotificationNode",
		physicsBody =
		{
			properties = 
			{
				categoryBitMask = kContactCategoryTrigger,
				contactTestBitMask = kContactCategoryPlayer,
				dynamic = NO,
			},
		},
	},

	TriggerOnce =
	{
		inheritsFrom = "Trigger",
		properties =
		{
			onlyOnce = YES,
		},
	},
	
	Checkpoint =
	{
		inheritsFrom = "SpriteNode",
		physicsBody =
		{
			properties =
			{
				categoryBitMask = kContactCategoryTrigger,
				contactTestBitMask = kContactCategoryPlayer,
				dynamic = NO,
			},
		},
		behaviors =
		{
			{className = "KKNotifyOnContactBehavior", properties = {notification = "CheckpointActivated"}},
		},
	},
	
	Emitter =
	{
		inheritsFrom = "EmitterNode",
		emitterFile = "<missingfile.sks>",
	},
	
	Image =
	{
		inheritsFrom = "SpriteNode",
	},

	Text =
	{
		inheritsFrom = "LabelNode",
		properties =
		{
			fontName = "Arial",
			fontSize = 10,
			fontColor = {color = "1.0 0.0 1.0 1.0"}, -- color = "R G B A"
			text = "<missing text>",
		},
	},

	Player =
	{
		-- create an instance of this class (class must inherit from SKNode or its subclasses)
		className = "CBRobot",

		physicsBody =
		{
			properties =
			{
				allowsRotation = NO,
				mass = 0.05,
				restitution = 0,
				linearDamping = 0,
				angularDamping = 0,
				friction = 0,
				affectedByGravity = YES,
				categoryBitMask = kContactCategoryPlayer,
				contactTestBitMask = 0, --kContactCategoryPlayer + kContactCategoryPickupItem,
				collisionBitMask = kGameObjectCollisionBitMask,
			},
		},
		
        behaviors =
		{
			--{behaviorClass = "KKLimitVelocityBehavior", properties = {velocityLimit = 100}},
			--{className = "KKStayInBoundsBehavior", properties = {bounds = "{{0, 0}, {0, 0}}"}},
            {className = "CBCharacterAnimator"},
			{className = "KKCameraFollowBehavior"},
		},
		
		actions = 
		{
			-- not yet, coming soon
		},
	},
}

return objectTemplates