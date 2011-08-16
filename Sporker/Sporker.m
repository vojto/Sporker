//
//  Sporker.m
//  Sporker
//
//  Created by Vojto Rinik on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sporker.h"

#define RKPostNotificationWithName(name) NSNotification *notif = [NSNotification notificationWithName:name object:nil]; [[NSNotificationCenter defaultCenter] postNotification:notif]

@implementation Sporker

@synthesize task, state;

- (void) awakeFromNib {
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"projectPath"];
    NSLog(@"Awakening Sporker... %@", path);
    if (path) {
        self.projectPath = path;
    }
}

- (NSString *)projectPath {
    return projectPath;
}

- (void)setProjectPath:(NSString *)aProjectPath {
    [projectPath release];
    projectPath = [aProjectPath retain];
    [[NSUserDefaults standardUserDefaults] setObject:projectPath forKey:@"projectPath"];
}

- (void) start {
    if (!projectPath) return;
    
    [self _changeState:@"starting"];
    didSendReadyMessage = NO;
    
    self.task = [[[NSTask alloc] init] autorelease];
    [self.task setLaunchPath: @"/bin/bash"];
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects:[self _startScriptPath], projectPath, nil];
    [self.task setArguments:arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [pipe retain];
    [self.task setStandardOutput:pipe];
    [self.task setStandardError:pipe];
    [self.task setStandardInput:[NSPipe pipe]];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didReadData:) name:NSFileHandleReadCompletionNotification object:file];
    
    [self.task launch];
    [file readInBackgroundAndNotify];
}

- (void)_didReadData:(NSNotification *)notif {
    NSFileHandle *file = (NSFileHandle *)[notif object];
    NSData *incomingData = [[notif userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *string = [[NSString alloc] initWithData:incomingData encoding:NSUTF8StringEncoding];
    NSLog(@"----> %@", string);
    
    if ([string hasPrefix:@"Spork is ready"]) {
        didSendReadyMessage = YES;
    }
    
    if ([task isRunning] && didSendReadyMessage) {
        [self _changeState:@"running"];
    } else if ([task isRunning]) {
        [self _changeState:@"starting"];
    } else {
        [self _changeState:@"stopped"];
    }
    if ([incomingData length] > 0)
        [file readInBackgroundAndNotify];
}

- (void) stop {
    [self _changeState:@"stopping"];
    [task interrupt];
}

- (void) restart {
    [self stop];
    [self start];
}

- (void)_changeState:(NSString *)aState {
    if ([aState isEqualToString:self.state]) return;
    self.state = aState;
    // RKPostNotificationWithName(@"SporkerDidChangeState");
}

- (NSString *)_startScriptPath {
    return [[NSBundle mainBundle] pathForResource:@"spork-start" ofType:@"sh"];
}

@end
