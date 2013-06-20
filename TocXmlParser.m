//
//  TocXmlParser.m
//  Comic Store
//
//  Created by neo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TocXmlParser.h"


@implementation TocXmlParser
@synthesize Arr_Toc;
- (TocXmlParser *) initXMLParser 
{
	[super init];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"BookTOC"]) 
	{
		//Initialize the array.
		Arr_Toc = [[NSMutableArray alloc] init];
		
	}
	else if([elementName isEqualToString:@"TOC"]) 
	{
		//Initialize the book.
		TocB_Obj = [[TocOfBook_Class alloc] init];
		//Extract the attribute here.
	}
	//NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:attributeDict];

	NSLog(@"Processing Element: #####%@######", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	NSLog(@"Processing Value: %@", currentElementValue);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
	if([elementName isEqualToString:@"BookTOC"])
		return;
	NSString *str_Curent = [[NSString alloc] initWithFormat:@"%@",currentElementValue];
	str_Curent = [str_Curent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if([elementName isEqualToString:@"TOC"]) 
	{
		[Arr_Toc addObject:TocB_Obj];
		[TocB_Obj release];
		TocB_Obj = nil;
	}
	else 
	{
		@try 
		{
			if (currentElementValue==nil) 
			{
				currentElementValue = [NSString stringWithString:@""];
			}
			[TocB_Obj setValue:str_Curent forKey:elementName];
		}
		@catch (NSException* ex) 
		{
		}	
	}
	//[str_Curent release];
	[currentElementValue release];
	currentElementValue = nil;
}




- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to Parsing %@ (Error code %i )", parseError,[parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	/*Commented by karpaga UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show]; */
	//Added by karpaga
	//UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Network error" message:@"Network connection failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[errorAlert show];
	//End of addition
}



- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
	
	NSLog(@"all done!XML");
	
}




- (void) dealloc {
	
	[TocB_Obj release];
	[currentElementValue release];
	[Arr_Toc release];
	[super dealloc];
}
@end
