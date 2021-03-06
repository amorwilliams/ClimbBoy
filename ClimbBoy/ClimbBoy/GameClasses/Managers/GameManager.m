//
//  GameData.m
//  ClimbBoy
//
//  Created by Robin on 13-9-22.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "GameManager.h"

static BOOL _showsDebugNode = NO;

@implementation GameManager

DEFINE_SINGLETON_FOR_CLASS(GameManager)

- (id)init
{
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

- (void)loadData {
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"GameData.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"GameData" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %lu", errorDesc, format);
    }
    
    self.maps = [NSArray arrayWithArray:[temp objectForKey:@"Maps"]];
    [self checkMapDuplicated];
    
    self.levels = [NSArray arrayWithArray:[temp objectForKey:@"Levels"]];
}

- (void)setView:(KKView *)view
{
    _view = view;
    self.showsDebugNode = [view.model boolForKeyPath:@"devconfig.showsDebugNode"];
}

@dynamic showsDebugNode;
+ (BOOL)showsDebugNode
{
    return _showsDebugNode;
}
- (BOOL)showsDebugNode
{
    return _showsDebugNode;
}
- (void)setShowsDebugNode:(BOOL)showsDebugNode
{
    _showsDebugNode = showsDebugNode;
}

- (void)checkMapDuplicated
{
    for (int i = 0; i < _maps.count; i++) {
        NSDictionary *map1 = [_maps objectAtIndex:i];
        NSString *tilemapFile1 = [map1 valueForKey:@"Tilemap"];
        
        for (int j = i+1; j < _maps.count; j++) {
            NSDictionary *map2 = [_maps objectAtIndex:j];
            NSString *tilemapFile2 = [map2 valueForKey:@"Tilemap"];
            
            if ([tilemapFile1 isEqualToString:tilemapFile2]) {
                NSAssert(NO, @"Have duplicated name of map:%@ in index:%d and %d", tilemapFile1, i, j);
            }
        }
    }
}

#pragma mark !! Update methods below whenever class layout changes !!
#pragma mark NSCoding

static NSString* const ArchiveKeyForLevel = @"level";
static NSString* const ArchiveKeyForSettings = @"settings";

-(id) initWithCoder:(NSCoder*)decoder
{
	self = [super init];
	if (self)
	{
		_levels = [decoder decodeObjectForKey:ArchiveKeyForLevel];
		_settings = [decoder decodeObjectForKey:ArchiveKeyForSettings];
	}
	return self;
}

-(void) encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:_levels forKey:ArchiveKeyForLevel];
	[encoder encodeObject:_settings forKey:ArchiveKeyForSettings];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    GameManager* copy = [[[self class] allocWithZone:zone] init];
	copy->_levels = _levels;
	copy->_settings = _settings;
	return copy;
}



@end
