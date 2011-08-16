//
//  SporkerAppDelegate.m
//  Sporker
//
//  Created by Vojto Rinik on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SporkerAppDelegate.h"

@implementation SporkerAppDelegate

@synthesize window;
@synthesize projectName;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
	statusItem = [[statusBar statusItemWithLength:NSVariableStatusItemLength] retain];
    
    // [statusItem setTitle:@"sporker"];
    [statusItem setImage:[NSImage imageNamed:@"SporkerIdle.png"]];
    [statusItem setAlternateImage:[NSImage imageNamed:@"SporkerSelected.png"]];
    [statusItem setHighlightMode:YES];
    [statusItem setMenu:menu];
    [self _updateMenuItem];
    
    [sporker addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    [sporker addObserver:self forKeyPath:@"projectPath" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [statusItem release];
    [super dealloc];
}

- (IBAction)chooseProjectAction:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseDirectories = YES;
    openPanel.canChooseFiles = NO;
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        NSURL *url = [openPanel URL];
        sporker.projectPath = [url path];
        self.projectName = [[url pathComponents] lastObject];
    }];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)startAction:(id)sender {
    [sporker start];
}

- (IBAction)stopAction:(id)sender {
    [sporker stop];
}

- (IBAction)restartAction:(id)sender {
    [sporker restart];
}

- (IBAction)quitAction:(id)sender {
    [sporker stop];
    [NSApp terminate:self];
}

#pragma mark - Observing Sporker state changes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self _updateMenuItem];
}

- (void)_updateMenuItem {
    [projectNameMenuItem setTitle:[[sporker.projectPath componentsSeparatedByString:@"/"] lastObject]];
    
    NSString *state = sporker.state;
    NSDictionary *images = [NSDictionary dictionaryWithObjectsAndKeys:@"SporkerStarting.png", @"starting", 
                            @"SporkerStopped.png", @"stopped",
                            @"SporkerRunning.png", @"running",
                            nil];
    NSImage *image = [NSImage imageNamed:[images objectForKey:state]];
    if (image) [statusItem setImage:image];
}

@end
