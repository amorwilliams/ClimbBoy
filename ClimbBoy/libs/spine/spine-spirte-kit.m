//
//  spine-spirte-kit.m
//  ClimbBoy
//
//  Created by Robin on 13-9-10.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "spine-spirte-kit.h"
#import <spine/spine.h>
#import <spine/extension.h>


void _AtlasPage_createTexture (AtlasPage* self, const char* path) {
//    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"spine"];
//    SKTexture *texture = [atlas textureNamed:@(path)];
    SKTexture *texture = [SKTexture textureWithImageNamed:@(path)];
    self->rendererObject = (__bridge void *)(texture);
    self->width = texture.size.width;
    self->height = texture.size.height;
}

void _AtlasPage_disposeTexture (AtlasPage* self) {
//	[(__bridge SKTexture*)self->rendererObject release];
}

char* _Util_readFile (const char* path, int* length) {
    NSString *fileName = [@(path) stringByDeletingPathExtension];
    NSString *extension = [@(path) pathExtension];
	return _readFile([[[NSBundle mainBundle] pathForResource:fileName ofType:extension] UTF8String], length);
    return NULL;
}
