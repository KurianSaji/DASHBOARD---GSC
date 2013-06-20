//
//  BannersParser.m
//  Comic Store
//
//  Created by neo on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BannersParser.h"


@implementation BannersParser
@synthesize Arr_Banners;


- (BannersParser *) initXMLParser 
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
		Arr_Banners = [[NSMutableArray alloc] init];
		
	}
	else if([elementName isEqualToString:@"image"]) 
	{
		//Initialize the book.
		Banners_Obj = [[Baners_Class alloc] init];
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
		[Arr_Banners addObject:Banners_Obj];
		[Banners_Obj release];
		Banners_Obj = nil;
	}
	else 
	{
		if([elementName isEqualToString:@"imageURL"])
		{
			NSString *str_current = currentElementValue;
			str_current = [str_current stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			//NSString *str_temp = [[NSString alloc] initWithFormat:@"%@",str_current];
			Banners_Obj.imageURL = str_current;
			//[str_temp release];
		}
		else if([elementName isEqualToString:@"bannerLink"])
		{
			NSString *str_current1 = currentElementValue;
			str_current1 = [str_current1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NSString *str_temp1 = [[NSString alloc] initWithFormat:@"%@",str_current1];
			Banners_Obj.BannerURL = str_temp1;
			[str_temp1 release];
		}
	}
	[currentElementValue release];
	currentElementValue = nil;
}




- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to Parsing %@ (Error code %i )", parseError,[parseError code]];
	
	
	/*Commented by karpaga  UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	 [errorAlert show];*/
	//UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Network error" message:@"Network connection failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[errorAlert show];
	
}



- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
	
	
	
}


@end
