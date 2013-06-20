//
//  GCHelper.h
//  man
//
//  Created by neo on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "epubstore_svcAppDelegate.h"
#import <GameKit/GameKit.h>

//@class epubstore_svcAppDelegate;

@interface GCHelper : NSObject {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
//	GCHelper *help;
	//epubstore_svcAppDelegate *appdelegate;
}

@property (assign, readonly) BOOL gameCenterAvailable;
//@property(nonatomic,assign)BOOL userAuthenticated;
+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
-(void)authenticationChanged;
- (void) reloadHighScoresForCategory: (NSString*) category;

@end