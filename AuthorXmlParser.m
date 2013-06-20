//
//  AuthorXmlParser.m
//  Comic Store
//
//  Created by Zaah Technologies India PVT on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AuthorXmlParser.h"
#import "AuthorBookDetails.h"
#import "epubstore_svcAppDelegate.h"


@implementation AuthorXmlParser
@synthesize Name ;
@synthesize Photo;
@synthesize Description;
@synthesize authorBookDetArray;
BOOL bookDetailStarted = FALSE;

- (AuthorXmlParser *) initXMLParser {
	
	[super init];
	
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	Name =@"";
	Photo =@"";
	Description =@"";
	authorBookDetArray= [[NSMutableArray alloc]init];
	return self;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"Books"]) {
		
		bookDetailStarted = TRUE;
		authorBookDetArray= [[NSMutableArray alloc]init];
	}
	if ([elementName isEqualToString:@"Book"]) {
		authorBookDetails = [[AuthorBookDetails alloc]init];
	}
	
	
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (currentElementValue!=nil) {
		NSRange replaceRange = NSMakeRange(0, [currentElementValue length]);

		[currentElementValue replaceOccurrencesOfString:@"\t" withString:@"" options:NSCaseInsensitiveSearch range:replaceRange];
		replaceRange = NSMakeRange(0, [currentElementValue length]);
		[currentElementValue replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:replaceRange];
	}
   if (bookDetailStarted ==FALSE) {
	   @try {
		 //  [self setValue:currentElementValue forKey:elementName];
		   if ([elementName isEqualToString:@"Name"]) {
			   Name = currentElementValue;
		   }
		   if ([elementName isEqualToString:@"Photo"]) {
			   Photo = currentElementValue;
		   }
		   if ([elementName isEqualToString:@"Description"]) {
			   Description = currentElementValue;
		   }
		   
		   
	   }
	   @catch (NSException * e) {
		   
	   }
	   
	   
   }
	else {
		if (![elementName isEqualToString:@"Book"]&&![elementName isEqualToString:@"Books"]) {
			@try {
				
				[authorBookDetails setValue:currentElementValue forKey:elementName];
				
			}
			@catch (NSException * e) {
				 
			}
		}
		else if ([elementName isEqualToString:@"Book"] ) {
			@try {
				[authorBookDetArray addObject:authorBookDetails];
				[authorBookDetails release];
				
			}
			@catch (NSException * e) {
				 
			}
			
		}
		
	}

	currentElementValue = nil;
}

- (void) dealloc {
	[Name release];
	[Photo release];
	[Description release];
	[authorBookDetArray release];
	[currentElementValue release];
	[super dealloc];
}

@end
