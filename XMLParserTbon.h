//
//  XMLParser.h
//  FreeRideHome
//
//  Created by Partha on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "epubstore_svcAppDelegate.h"

//@class TBONEAppDelegate;

@interface XMLParserTbon : UIViewController<NSXMLParserDelegate> {
	
	epubstore_svcAppDelegate *appDelegate;
	NSMutableString *currentElementValueNew;
	NSMutableDictionary *tempDict;
    NSInteger xmlIndex;
	NSInteger count;
}

@property(nonatomic,assign) NSInteger xmlIndex;
- (XMLParserTbon *) initXMLParserwithIndex:(NSInteger)index;

@end
 