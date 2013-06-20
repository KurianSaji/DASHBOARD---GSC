//
//  BookDetailParser.h
//  epubstore_svc
//
//  Created by Zaah Technologies India PVT on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RelatedBookDeatails.h"
@class epubstore_svcAppDelegate,OneBookDetails;
@interface BookDetailParser : NSObject {
	NSMutableString *currentElementValue;
	OneBookDetails *myBookDetails;
	RelatedBookDeatails *relatedBookDeatails;
	epubstore_svcAppDelegate *appDelegate;
}
- (BookDetailParser *) initXMLParser;
@end
