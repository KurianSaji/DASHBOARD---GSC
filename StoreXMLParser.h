//
//  StoreXMLParser.h
//  epubstore_svc
//
//  Created by Zaah Technologies India PVT on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class epubstore_svcAppDelegate,BookDetails;
@interface StoreXMLParser : NSObject 
{
	NSMutableString *currentElementValue;
	BookDetails *allBookDetail;
	epubstore_svcAppDelegate *appDelegate;
}
- (StoreXMLParser *) initXMLParser;
@end
