//
//  BookListParser.m
//  epubstore_svc
//
//  Created by Zaah Technologies India PVT on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BookDetailParser.h"
#import "OneBookDetails.h"
#import "epubstore_svcAppDelegate.h"
#import "Book.h"

BOOL success = FALSE;

@implementation BookDetailParser

- (BookDetailParser *) initXMLParser {
	
	[super init];
	
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.booksDetailsArray removeAllObjects];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"BookDetail"]) 
	{
		//Initialize the array.
		appDelegate.booksDetailsArray = [[NSMutableArray alloc] init];
		
	}
	if([elementName isEqualToString:@"ReleatedBooks"]) {
		myBookDetails.RealatedBookArray = [[NSMutableArray alloc]init];
	}
	
	else if([elementName isEqualToString:@"Book"]) {
		
		//Initialize the book.
		myBookDetails = [[OneBookDetails alloc] init];
		
		//Extract the attribute here.
		
	}
	else if([elementName isEqualToString:@"ReleatedBook"]) {
		relatedBookDeatails = [[RelatedBookDeatails alloc]init];
	}
	
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
	NSString *Str_CurrEle = [[NSString alloc] initWithFormat:@"%@",currentElementValue];
	Str_CurrEle = [Str_CurrEle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if([elementName isEqualToString:@"Response"])
		return;
	
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
	else if([elementName isEqualToString:@"Book"]) 
	{
		
		//[myBookDetails release];
		//myBookDetails = nil;
	}
	//Details About Each and every related book details
	else if ([elementName isEqualToString:@"ReleatedBook"]) 
	{
		
		[myBookDetails.RealatedBookArray addObject:relatedBookDeatails];
		[relatedBookDeatails release];
		relatedBookDeatails =nil;
	    
	}
	// end of whole (book details)
	else if([elementName isEqualToString:@"ReleatedBooks"]) {
		[appDelegate.booksDetailsArray addObject:myBookDetails];
		[myBookDetails release];
		myBookDetails = nil;
	}
	else if([elementName isEqualToString:@"BookDetail"])
	{
	}
	else
	{
		@try 
		{
		
			if (Str_CurrEle==nil) 
			{
				Str_CurrEle = [NSString stringWithString:@""];
			}
			/*if ([elementName hasPrefix:@"Releated"] ) 
			{
				[relatedBookDeatails setValue:Str_CurrEle forKey:elementName];
			}*/
			if([elementName isEqualToString:@"ReleatedIDValue"])
			{
				relatedBookDeatails.ReleatedIDValue = Str_CurrEle;
			}
			else if([elementName isEqualToString:@"ReleatedName"])
			{
				relatedBookDeatails.ReleatedName = Str_CurrEle;
			}
			else if([elementName isEqualToString:@"ReleatedCoverPhoto"])
			{
				relatedBookDeatails.ReleatedCoverPhoto = Str_CurrEle;
			}			
			else
				[myBookDetails setValue:Str_CurrEle forKey:elementName];
		}
		@catch (NSException* ex) 
		{
		}
	}
	[Str_CurrEle release];
	[currentElementValue release];
	currentElementValue = nil;
}

- (void) dealloc {
	
	[myBookDetails release];
	[currentElementValue release];
	[super dealloc];
}

@end

