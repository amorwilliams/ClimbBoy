//
//  AppDelegate.m
//  ClimbBoy-Editor
//
//  Created by Robin on 13-10-25.
//  Copyright (c) 2013年 Steffen Itterheim. All rights reserved.
//

#import "AppDelegate.h"
#import "SpriteKitScene.h"
#import "NewDocWindowController.h"
#import "MainWindow.h"

@implementation AppDelegate

static AppDelegate* sharedAppDelegate;

#pragma mark Setup functions

+ (AppDelegate*) appDelegate
{
    return sharedAppDelegate;
}

- (void)setupSKScene {
    _kkViewController = [[KKViewController alloc] initWithNibName:nil bundle:nil];
	NSAssert([_kkViewController isKindOfClass:[KKViewController class]], @"'ViewController' class is not a subclass of KKViewController.");
	
	_kkViewController.view = self.spriteKitView;
	[_kkViewController viewDidLoad];
    
	NSLog(@"%@", koboldKitCommunityVersion());
	NSLog(@"%@", koboldKitProVersion());
    
	// create and present first scene
    _spriteKitScene = [SpriteKitScene sceneWithSize:self.spriteKitView.bounds.size];
    _spriteKitScene.scaleMode = SKSceneScaleModeResizeFill;
	[self.spriteKitView presentScene:_spriteKitScene];

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    sharedAppDelegate = self;
    
    [self setupSKScene];
    
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    return YES;
}


#pragma mark Document handling
- (BOOL) hasDirtyDocument
{
//    NSArray* docs = [tabView tabViewItems];
//    for (int i = 0; i < [docs count]; i++)
//    {
//        CCBDocument* doc = [(NSTabViewItem*)[docs objectAtIndex:i] identifier];
//        if (doc.isDirty) return YES;
//    }
    if ([[NSDocumentController sharedDocumentController] hasEditedDocuments])
    {
        return YES;
    }
    return NO;
}

- (void) updateDirtyMark
{
    [_window setDocumentEdited:[self hasDirtyDocument]];
}
- (NSMutableDictionary*) docDataFromCurrentNodeGraph
{
//    CCBGlobals* g= [CCBGlobals globals];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//    CCBDocument* doc = [self currentDocument];
    
    // Add node graph
//    NSMutableDictionary* nodeGraph = [CCBWriterInternal dictionaryFromCCObject:g.rootNode];
//    [dict setObject:nodeGraph forKey:@"nodeGraph"];
//    
//    // Add meta data
//    [dict setObject:@"CocosBuilder" forKey:@"fileType"];
//    [dict setObject:[NSNumber numberWithInt:kCCBFileFormatVersion] forKey:@"fileVersion"];
//    
//    [dict setObject:[NSNumber numberWithBool:jsControlled] forKey:@"jsControlled"];
//    
//    [dict setObject:[NSNumber numberWithBool:[[CocosScene cocosScene] centeredOrigin]] forKey:@"centeredOrigin"];
//    
//    [dict setObject:[NSNumber numberWithInt:[[CocosScene cocosScene] stageBorder]] forKey:@"stageBorder"];
//    
//    // Guides & notes
//    [dict setObject:[[CocosScene cocosScene].guideLayer serializeGuides] forKey:@"guides"];
//    [dict setObject:[[CocosScene cocosScene].notesLayer serializeNotes] forKey:@"notes"];
//    
//    // Resolutions
//    if (doc.resolutions)
//    {
//        NSMutableArray* resolutions = [NSMutableArray array];
//        for (ResolutionSetting* r in doc.resolutions)
//        {
//            [resolutions addObject:[r serialize]];
//        }
//        [dict setObject:resolutions forKey:@"resolutions"];
//        [dict setObject:[NSNumber numberWithInt:doc.currentResolution] forKey:@"currentResolution"];
//    }
//    
//    // Sequencer timelines
//    if (doc.sequences)
//    {
//        NSMutableArray* sequences = [NSMutableArray array];
//        for (SequencerSequence* seq in doc.sequences)
//        {
//            [sequences addObject:[seq serialize]];
//        }
//        [dict setObject:sequences forKey:@"sequences"];
//        [dict setObject:[NSNumber numberWithInt:sequenceHandler.currentSequence.sequenceId] forKey:@"currentSequenceId"];
//    }
//    
//    if (doc.exportPath && doc.exportPlugIn)
//    {
//        [dict setObject:doc.exportPlugIn forKey:@"exportPlugIn"];
//        [dict setObject:doc.exportPath forKey:@"exportPath"];
//        [dict setObject:[NSNumber numberWithBool:doc.exportFlattenPaths] forKey:@"exportFlattenPaths"];
//    }
    
    return dict;
}

- (void) newFile:(NSString*) fileName type:(int)type mapSize: (CGSize)mapSize tileSize:(CGSize)tileSize;
{
    BOOL origin = NO;
    CGSize stageSize = CGSizeMake(400,400);
    
//    ResolutionSetting* resolution = [resolutions objectAtIndex:0];
//    CGSize stageSize = CGSizeMake(resolution.width, resolution.height);
//    
//    // Close old doc if neccessary
//    CCBDocument* oldDoc = [self findDocumentFromFile:fileName];
//    if (oldDoc)
//    {
//        NSTabViewItem* item = [self tabViewItemFromDoc:oldDoc];
//        if (item) [tabView removeTabViewItem:item];
//    }
    
//    [self prepareForDocumentSwitch];
    
//    [[SpriteKitScene spriteKitScene].notesLayer removeAllNotes];
    
//    self.selectedNodes = NULL;
    [[SpriteKitScene spriteKitScene] setStageSize:stageSize centeredOrigin:origin];
    
    // Create new node
    [[SpriteKitScene spriteKitScene] replaceRootNodeWith:[SKNode node]];//[[PlugInManager sharedManager] createDefaultNodeOfType:type]];
    
    // Set default contentSize to 100% x 100%
//    if (([type isEqualToString:@"CCNode"] || [type isEqualToString:@"CCLayer"])
//        && stageSize.width != 0 && stageSize.height != 0)
//    {
//        [PositionPropertySetter setSize:NSMakeSize(100, 100) type:kCCBSizeTypePercent forNode:[SpriteKitScene spriteKitScene].rootNode prop:@"contentSize"];
//    }
    
//    [outlineHierarchy reloadData];
//    [sequenceHandler updateOutlineViewSelection];
//    [self updateInspectorFromSelection];
    
//    self.currentDocument = [[[CCBDocument alloc] init] autorelease];
//    self.currentDocument.resolutions = resolutions;
//    self.currentDocument.currentResolution = 0;
//    [self updateResolutionMenu];
    
    [self saveFile:fileName];

//    [self addDocument:currentDocument];
//    
//    // Setup a default timeline
//    NSMutableArray* sequences = [NSMutableArray array];
//    
//    SequencerSequence* seq = [[[SequencerSequence alloc] init] autorelease];
//    seq.name = @"Default Timeline";
//    seq.sequenceId = 0;
//    seq.autoPlay = YES;
//    [sequences addObject:seq];
//    
//    currentDocument.sequences = sequences;
//    sequenceHandler.currentSequence = seq;
//    
//    
//    self.hasOpenedDocument = YES;
//    
//    [self updateStateOriginCenteredMenu];
    
    [[SpriteKitScene spriteKitScene] setStageZoom:1];
    [[SpriteKitScene spriteKitScene] setScrollOffset:ccp(0,0)];
    
//    [self checkForTooManyDirectoriesInCurrentDoc];
}

#pragma mark Menu options

- (IBAction) menuZoomIn:(id)sender
{
    SpriteKitScene* cs = [SpriteKitScene spriteKitScene];
    
    float zoom = [cs stageZoom];
    zoom *= 1.2;
    if (zoom > 8) zoom = 8;
    [cs setStageZoom:zoom];
}

- (IBAction) menuZoomOut:(id)sender
{
    SpriteKitScene* cs = [SpriteKitScene spriteKitScene];
    
    float zoom = [cs stageZoom];
    zoom *= 1/1.2f;
    if (zoom < 0.125) zoom = 0.125f;
    [cs setStageZoom:zoom];
}

- (IBAction) menuResetView:(id)sender
{
    SpriteKitScene* cs = [SpriteKitScene spriteKitScene];
    cs.scrollOffset = ccp(0,0);
    [cs setStageZoom:1];
}

- (IBAction) openDocument:(id)sender
{
    // Create the File Open Dialog
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowedFileTypes:[NSArray arrayWithObject:@"tmx"]];
    
    [openDlg beginSheetModalForWindow:_window completionHandler:^(NSInteger result){
        if (result == NSOKButton)
        {
            NSArray* files = [openDlg URLs];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0),
                           dispatch_get_main_queue(), ^{
                               for (int i = 0; i < [files count]; i++)
                               {
                                   NSString* fileName = [[files objectAtIndex:i] path];
                                   [self openFile:fileName];
                               }
                           });
        }
    }];
}

- (IBAction) newDocument:(id)sender
{
    NewDocWindowController* wc = [[NewDocWindowController alloc] initWithWindowNibName:@"NewDocWindow"];
    
    // Show new document sheet
    [NSApp beginSheet:[wc window] modalForWindow:_window modalDelegate:NULL didEndSelector:NULL contextInfo:NULL];
    int acceptedModal = (int)[NSApp runModalForWindow:[wc window]];
    [NSApp endSheet:[wc window]];
    [[wc window] close];

    if (acceptedModal)
    {
        // Accepted create document, prompt for place for file
        NSSavePanel* saveDlg = [NSSavePanel savePanel];
        [saveDlg setAllowedFileTypes:[NSArray arrayWithObject:@"tmx"]];

//        SavePanelLimiter* limiter = [[SavePanelLimiter alloc] initWithPanel:saveDlg resManager:resManager];

        [saveDlg beginSheetModalForWindow:_window completionHandler:^(NSInteger result){
            if (result == NSOKButton)
            {
                int type = wc.orientationIndex;
                CGSize mapSize = CGSizeMake(wc.width, wc.height);
                CGSize tileSize = CGSizeMake(wc.tilewidth, wc.tileheight);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0),
                               dispatch_get_main_queue(), ^{
                                   [self newFile:[[saveDlg URL] path] type:type mapSize:mapSize tileSize:tileSize];
                               });
            }
        }];
    }
}

- (IBAction) performClose:(id)sender
{
    NSLog(@"performClose (AppDelegate)");
    
//    if (!currentDocument) return;
//    NSTabViewItem* item = [self tabViewItemFromDoc:currentDocument];
//    if (!item) return;
//    
//    if ([self tabView:tabView shouldCloseTabViewItem:item])
//    {
//        [tabView removeTabViewItem:item];
//    }
}

- (void)openFile:(NSString *)fileName
{
    NSLog(@"opned file: %@", fileName);
//    
//    [[[CCDirector sharedDirector] view] lockOpenGLContext];
//    
//    // Check if file is already open
//    CCBDocument* openDoc = [self findDocumentFromFile:fileName];
//    if (openDoc)
//    {
//        [tabView selectTabViewItem:[self tabViewItemFromDoc:openDoc]];
//        return;
//    }
//    
//    [self prepareForDocumentSwitch];
//    
//    NSMutableDictionary* doc = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
//    
//    CCBDocument* newDoc = [[[CCBDocument alloc] init] autorelease];
//    newDoc.fileName = fileName;
//    newDoc.docData = doc;
//    newDoc.exportPath = [doc objectForKey:@"exportPath"];
//    newDoc.exportPlugIn = [doc objectForKey:@"exportPlugIn"];
//    newDoc.exportFlattenPaths = [[doc objectForKey:@"exportFlattenPaths"] boolValue];
//    
//    [self switchToDocument:newDoc];
//    
//    [self addDocument:newDoc];
//    self.hasOpenedDocument = YES;
//    
//    [self checkForTooManyDirectoriesInCurrentDoc];
//    
//    // Remove selections
//    [self setSelectedNodes:NULL];
//    
//    // Make sure timeline is up to date
//    [sequenceHandler updatePropertiesToTimelinePosition];
//    
//	[[[CCDirector sharedDirector] view] unlockOpenGLContext];
}

- (void) saveFile:(NSString*) fileName
{
    NSMutableDictionary* doc = [self docDataFromCurrentNodeGraph];

    [doc writeToFile:fileName atomically:YES];

//    currentDocument.fileName = fileName;
//    currentDocument.docData = doc;
//    
//    currentDocument.isDirty = NO;
//    NSTabViewItem* item = [self tabViewItemFromDoc:currentDocument];
//    
//    if (item)
//    {
//        [tabBar setIsEdited:NO ForTabViewItem:item];
//        [self updateDirtyMark];
//    }
//    
//    [currentDocument.undoManager removeAllActions];
//    currentDocument.lastEditedProperty = NULL;
}

@end
