//
//  XMLParser.m
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "XMLParser.h"
#import "epubstore_svcAppDelegate.h"

@implementation XMLParser
@synthesize HtmlNameParsedArray;
- (XMLParser *) initXMLParser {
	
	[super init];
	
	
////	bookAppDelegate = (BookReaderAppDelegate *)[[UIApplication sharedApplication] delegate];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"package"]) {
		//Initialize the array.
		NSLog(@"Array to be Initalized ");
        @try {
			
			
			 HtmlNameParsedArray = [[NSMutableArray alloc] init];
		}
		@catch (NSException * exception) {
		  NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
		}
		
		
		NSLog(@"Array Initalize");
		
	}
	else if([elementName isEqualToString:@"item"]) {
		
		//Initialize the book.
		
		
		//Extract the attribute here.
		NSString *mediaType = [attributeDict objectForKey:@"media-type"];
		if ([mediaType isEqualToString:@"application/xhtml+xml"]) {
			
			NSString *HtmlName = [attributeDict objectForKey:@"href"];
			if([[HtmlName lowercaseString]rangeOfString:@".ncx"].location==NSNotFound)
			{
				HtmlName =[HtmlName stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
				
				[HtmlNameParsedArray addObject:HtmlName];
			}
		}
		
		
	}
	
	NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
	NSLog(@"Processing Value: %@", currentElementValue);
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"package"])
		return;
	
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
	
}

- (void) dealloc {
	

	[currentElementValue release];
	[super dealloc];
}

@end
