//
//  UserXMLParser.h
//  epubstore_svc
//
//  Created by zaah technologies india pvt on 10/5/10.
//  Copyright 2010 zaah. All rights reserved.
//

#import <Foundation/Foundation.h>

@class epubstore_svcAppDelegate;
@interface UserXMLParser : NSObject{
	epubstore_svcAppDelegate *appDelegate;
	NSMutableString *currentElementValue;
}

- (UserXMLParser *) initXMLParser;
@end
