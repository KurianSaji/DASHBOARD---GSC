//
//  AuthorXmlParser.h
//  Comic Store
//
//  Created by Zaah Technologies India PVT on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorBookDetails.h"
@class epubstore_svcAppDelegate;
@interface AuthorXmlParser : NSObject {
	epubstore_svcAppDelegate *appDelegate;
	NSMutableString *currentElementValue;
	NSString *Name ;
	NSString *Photo;
	NSString *Description;
	NSMutableArray *authorBookDetArray;
	AuthorBookDetails *authorBookDetails;
}
@property (nonatomic,retain) NSString *Name ;
@property (nonatomic,retain) NSString *Photo;
@property (nonatomic,retain) NSString *Description;
@property (nonatomic,retain) NSMutableArray *authorBookDetArray;

@end
