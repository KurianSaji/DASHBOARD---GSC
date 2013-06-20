//
//  AdvertiseParser.m
//  Comic Store
//
//  Created by neo on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdvertiseParser.h"
#import "epubstore_svcAppDelegate.h"

@implementation AdvertiseParser
@synthesize Arr_Advertise;


- (AdvertiseParser *) initXMLParser 
{
	[super init];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"images"]) 
	{
		//Initialize the array.
		Arr_Advertise = [[NSMutableArray alloc] init];
		
	}
	else if([elementName isEqualToString:@"image"]) 
	{
		//Initialize the book.
		Advertise_Obj = [[Advertise_Class alloc] init];
		//Extract the attribute here.
	}
	//NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:attributeDict];
	
	
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
	if([elementName isEqualToString:@"images"])
		return;
	if([elementName isEqualToString:@"image"]) 
	{
		[Arr_Advertise addObject:Advertise_Obj];
		[Advertise_Obj release];
		Advertise_Obj = nil;
	}
	else 
	{
		if([elementName isEqualToString:@"imageURL"])
		{
			NSString *str_current = currentElementValue;
			str_current = [str_current stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			//NSString *str_temp = [[NSString alloc] initWithFormat:@"%@",str_current];
			Advertise_Obj.imageURL = str_current;
			//[str_temp release];
		}
		else if([elementName isEqualToString:@"link"])
		{
			NSString *str_current = currentElementValue;
			str_current = [str_current stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			//NSString *str_temp = [[NSString alloc] initWithFormat:@"%@",str_current];
			Advertise_Obj.link = str_current;
			//[str_temp release];
		}

	}
	[currentElementValue release];
	currentElementValue = nil;
}




- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to Parsing %@ (Error code %i )", parseError,[parseError code]];
	
	
	//UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Network error" message:@"Network Connection failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[errorAlert show];
}



- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
	
	
	
}


@end
