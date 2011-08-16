//
//  Sporker.h
//  Sporker
//
//  Created by Vojto Rinik on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sporker : NSObject {
    NSString *projectPath;
    NSTask *task;
    NSString *state;
    BOOL didSendReadyMessage;
}

@property (retain) NSString *projectPath;
@property (retain) NSTask *task;
@property (retain) NSString *state;

- (void) start;
- (void) stop;
- (void) restart;
- (void) _didReadData:(NSNotification *)notif;

- (void) _changeState:(NSString *)state;

- (NSString *) _startScriptPath;

@end
