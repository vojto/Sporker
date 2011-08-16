//
//  SporkerAppDelegate.h
//  Sporker
//
//  Created by Vojto Rinik on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Sporker.h"

@interface SporkerAppDelegate : NSObject <NSApplicationDelegate> {
    NSStatusItem *statusItem;
    IBOutlet NSMenu *menu;
    IBOutlet NSMenuItem *projectNameMenuItem;
    NSString *projectName;
    IBOutlet Sporker *sporker;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSString *projectName;

- (IBAction)chooseProjectAction:(id)sender;
- (IBAction)startAction:(id)sender;
- (IBAction)stopAction:(id)sender;
- (IBAction)restartAction:(id)sender;
- (IBAction)quitAction:(id)sender;

- (void)_updateMenuItem;


@end
