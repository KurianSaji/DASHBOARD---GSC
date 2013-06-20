//
//  XMLParser.h
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

//@class BookReaderAppDelegate;

@interface XMLParser : NSObject {

	NSMutableString *currentElementValue;
	NSMutableArray *HtmlNameParsedArray;
//	BookReaderAppDelegate *bookAppDelegate;
 
}
@property(nonatomic,retain)NSMutableArray* HtmlNameParsedArray;
- (XMLParser *) initXMLParser;

@end
