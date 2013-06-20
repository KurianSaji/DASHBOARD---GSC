//
//  StoreXMLParser.m
//  epubstore_svc
//
//  Created by Zaah Technologies India PVT on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StoreXMLParser.h"
#import "epubstore_svcAppDelegate.h"

int firstTime=0;

@implementation StoreXMLParser
- (StoreXMLParser *) initXMLParser {
	
	[super init];
	
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"Books"]) 
	{
		//Initialize the array.
		appDelegate.bookListArray = [[NSMutableArray alloc] init];
		
	}
	else if([elementName isEqualToString:@"Book"]) 
	{
		//Initialize the book.
		allBookDetail = [[BookDetails alloc] init];
		//Extract the attribute here.
	}
	
	NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{ 
	
	NSLog(@"Processing Value: %@", currentElementValue);
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
	if([elementName isEqualToString:@"Books"])
		return;
	if([elementName isEqualToString:@"Book"]) 
	{
		
		//if(firstTime==0)
		[appDelegate.bookListArray addObject:allBookDetail];
		//firstTime=1;
		[allBookDetail release];
		allBookDetail = nil;
	}
	else 
	{
		NSString *str_CurrentElementVal = currentElementValue;
		str_CurrentElementVal = [str_CurrentElementVal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
				
		if ([elementName isEqualToString:@"IDValue"]) 
		{
			allBookDetail.IDValue = str_CurrentElementVal;
		}
		else if([elementName isEqualToString:@"Name"])
		{	
			allBookDetail.Name = str_CurrentElementVal;
		}
		else if([elementName isEqualToString:@"SubTitle"])
		{
			allBookDetail.SubTitle = str_CurrentElementVal;
		}
		else if([elementName isEqualToString:@"CatalogImage"])
		{
			NSMutableString *Str = [[NSMutableString alloc] initWithFormat:@"%@",str_CurrentElementVal];
			allBookDetail.CatalogImage = Str;
			[Str release];
		}
		else if([elementName isEqualToString:@"Purchase"])
		{
			allBookDetail.Purchased = str_CurrentElementVal;
		}
		else if([elementName isEqualToString:@"Price"])
		{
			allBookDetail.Price = str_CurrentElementVal;
		}
		else if([elementName isEqualToString:@"ProductCode"])
		{
			allBookDetail.ItunesProductID = str_CurrentElementVal;
		}
		else if([elementName isEqualToString:@"PopupImage"])
		{
			NSString *str_CurrentElementVal = currentElementValue;
			str_CurrentElementVal = [str_CurrentElementVal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NSString *Str = [[NSString alloc] initWithFormat:@"%@",str_CurrentElementVal];
			allBookDetail.PopupImage = Str;
			[Str release];
		}
		else if([elementName isEqualToString:@"MagazinePDFFilePath"])
		{
			NSString *str_CurrentElementVal = currentElementValue;
			str_CurrentElementVal = [str_CurrentElementVal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NSString *Str = [[NSString alloc] initWithFormat:@"%@",str_CurrentElementVal];
			allBookDetail.MagazinePDFFilePath = Str;
			[Str release];			
		}
		else if([elementName isEqualToString:@"Description"])
		{
			allBookDetail.Description = str_CurrentElementVal;
		}
		else if([elementName isEqualToString:@"ReleaseDate"])
		{
			allBookDetail.ReleaseDate = str_CurrentElementVal;
		}
		
		/*
		@try 
		{
			if (currentElementValue==nil) 
			{
				currentElementValue = [NSString stringWithString:@""];
			}
			[allBookDetail setValue:currentElementValue forKey:elementName];
		}
		@catch (NSException* ex) 
		{
		}
		 */
	}
	[currentElementValue release];
	currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to Parsing %@ (Error code %i )", parseError,[parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	/*Commented by karpaga UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];*/
	//UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Network error" message:@"Network connection failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[errorAlert show];
	
}

- (void) dealloc {
	
	[allBookDetail release];
	[currentElementValue release];
	[super dealloc];
}

@end
