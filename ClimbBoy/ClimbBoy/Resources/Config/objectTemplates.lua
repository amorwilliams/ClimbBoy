-- objectTemplates.lua
-- Defines names of objects in Tileds to determine which ObjC classes to create
-- and which properties/ivars to set on these classes.

local kContactCategoryWorld = 0
local kContactCategoryPlayer = 1
local kContactCategoryEnemy = 2
local kContactCategoryPickupItem = 4
local kContactCategoryTrigger = 8
local kContactCategoryStaticObject = 16

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
		className = "HeroRobot",

        properties =
        {
            fallSpeedAcceleration = 3000,    -- how fast player accelerates when falling down
            fallSpeedLimit = 800,			-- max falling speed
            jumpAbortVelocity = 500,		-- the (max) upwards velocity forcibly set when jump is aborted
            jumpSpeedInitial = 600,         -- how fast the player initially moves upwards when jumping is initiated
            jumpSpeedDeceleration = 800,	-- how fast upwards motion (caused by jumping) decelerates
            runSpeedAcceleration = 1200,	-- how fast player accelerates sideways (0 = instant)
            runSpeedDeceleration = 900,		-- how fast player decelerates sideways (0 = instant)
            runSpeedLimit = 300,			-- max sideways running speed
            climbUpSpeedLimit = 300,
            climbDownSpeedLimit = 50,
            boundingBox = "{32, 52}",
            zPosition = 10,
            --anchorPoint = "{0.5, 0.3}",

            --_defaultImage = "dummy_stickman.png",
        },

		physicsBody =
		{
			properties =
			{
				allowsRotation = NO,
				mass = 0.1,
				restitution = 0,
				linearDamping = 0,
				angularDamping = 0,
				friction = 0,
				affectedByGravity = YES,
				categoryBitMask = kContactCategoryPlayer,
				contactTestBitMask = kContactCategoryWorld + kContactCategoryPlayer + kContactCategoryPickupItem,
				collisionBitMask = kGameObjectCollisionBitMask - kContactCategoryEnemy,
			},
		},
		
        behaviors =
		{
			--{behaviorClass = "KKLimitVelocityBehavior", properties = {velocityLimit = 100}},
			--{className = "KKStayInBoundsBehavior", properties = {bounds = "{{0, 0}, {0, 0}}"}},
            --{className = "CharacterAnimatorBehavior"},
			{className = "CameraFollowBehavior"},
            {className = "KKItemCollectorBehavior"},
            {className = "KKNotifyOnItemCountBehavior", properties = {itemName = "briefcase", count = 1}},
		},

		actions =
		{
			-- not yet, coming soon
		},
	},

	Skull =
	{
		-- create an instance of this class (class must inherit from SKNode or its subclasses)
		className = "Skull",

        properties =
        {
            fallSpeedAcceleration = 3000,    -- how fast player accelerates when falling down
            fallSpeedLimit = 800,			-- max falling speed
            jumpAbortVelocity = 500,		-- the (max) upwards velocity forcibly set when jump is aborted
            jumpSpeedInitial = 600,         -- how fast the player initially moves upwards when jumping is initiated
            jumpSpeedDeceleration = 800,	-- how fast upwards motion (caused by jumping) decelerates
            runSpeedAcceleration = 1200,		-- how fast player accelerates sideways (0 = instant)
            runSpeedDeceleration = 900,		-- how fast player decelerates sideways (0 = instant)
            runSpeedLimit = 300,			-- max sideways running speed
            boundingBox = "{32, 52}",
            zPosition = 10,
            --anchorPoint = "{0.5, 0.3}",

            --_defaultImage = "dummy_stickman.png",
        },

		physicsBody =
		{
			properties =
			{
				allowsRotation = NO,
				mass = 0.1,
				restitution = 0,
				linearDamping = 0,
				angularDamping = 0,
				friction = 0,
				affectedByGravity = YES,
				categoryBitMask = kContactCategoryEnemy,
				contactTestBitMask = kContactCategoryWorld + kContactCategoryPlayer,
				collisionBitMask = kGameObjectCollisionBitMask - kContactCategoryPlayer,
			},
		},
		
        behaviors =
		{
			
		},
	},

    PickupItem =
    {
        inheritsFrom = "Image",

        physicsBody =
        {
            properties =
            {
            categoryBitMask = kContactCategoryPickupItem,
            contactTestBitMask = kContactCategoryPlayer,
            dynamic = NO,
            },
        },

        behaviors =
        {
            {className = "KKRemoveOnContactBehavior"}, -- physics contact resolves in a remove of this node
            {className = "KKPickupItemBehavior"},
        },
    },

    -- Game-Specific Items
    Briefcase =
    {
        inheritsFrom = "PickupItem",

        properties =
        {
            name = "briefcase",
            imageName = "dummy_case.png",
            --imageName = "dummy_case2.png",
        },
    },

    ExitDoor =
    {
        inheritsFrom = "Image",

        physicsBody =
        {
            properties =
            {
                categoryBitMask = kContactCategoryStaticObject,
                contactTestBitMask = kContactCategoryPlayer,
                collisionBitMask = 0xffffffff,
                dynamic = NO,
            },
        },
        behaviors =
        {
            {className = "KKRemoveOnNotificationBehavior", properties = {notification = "OpenExitDoor"}},
        },
    },

    LockedDoor1 =
    {
        inheritsFrom = "Image",

        physicsBody =
        {
            properties =
            {
                categoryBitMask = kContactCategoryStaticObject,
                contactTestBitMask = kContactCategoryPlayer,
                collisionBitMask = 0xffffffff,
                dynamic = NO,
            },
        },

        properties =
        {
            imageName = "dummy_lockeddoor_1_3x1.png",
        },

        behaviors =
        {
            {className = "KKRemoveOnNotificationBehavior", properties = {notification = "OpenLockedDoor1"}},
        },
    },

    LockedDoor2 =
    {
        inheritsFrom = "Image",

        physicsBody =
        {
            properties =
            {
                categoryBitMask = kContactCategoryStaticObject,
                contactTestBitMask = kContactCategoryPlayer,
                collisionBitMask = 0xffffffff,
                dynamic = NO,
            },
        },

        properties =
        {
            imageName = "dummy_lockeddoor_2_3x1.png",
        },

        behaviors =
        {
            {className = "KKRemoveOnNotificationBehavior", properties = {notification = "OpenLockedDoor2"}},
        },
    },

    Platform =
    {
        inheritsFrom = "Image",

        physicsBody =
        {
            properties =
            {
                categoryBitMask = kContactCategoryStaticObject,
                contactTestBitMask = kContactCategoryPlayer,
                collisionBitMask = kGameObjectCollisionBitMask,
                dynamic = YES,
                allowsRotation = NO,
                affectedByGravity = NO,
                mass = 265535,
                friction = 1,
                restitution = 0,
            },
        },
    },

    OnSidePlatform =
    {
        inheritsFrom = "Image",

        physicsBody =
        {
            properties =
            {
                categoryBitMask = kContactCategoryTrigger,
                contactTestBitMask = kContactCategoryPlayer,
                dynamic = NO,
                allowsRotation = NO,
                affectedByGravity = NO,
                mass = 265535,
                friction = 1,
                restitution = 0,
            },
        },

        behaviors =
        {
            {className = "OneSidePlatformBehavior"},
        },
    },
}

return objectTemplates
