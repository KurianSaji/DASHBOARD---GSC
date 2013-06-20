//
//  UserXMLParser.m
//  epubstore_svc
//
//  Created by zaah technologies india pvt on 10/5/10.
//  Copyright 2010 zaah. All rights reserved.
//

#import "UserXMLParser.h"
#import "epubstore_svcAppDelegate.h"


@implementation UserXMLParser


- (UserXMLParser *) initXMLParser {
	
	[super init];
	
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	return self;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"IsSuccess"]) {
		//Initialize the array.
		//appDelegate.booksDetailsArray = [[NSMutableArray alloc] init];
		
	}
	else if([elementName isEqualToString:@"AuthKey"]) {
		//
	NSLog(@"didStartElement Element: %@", elementName);
	}
	else if([elementName isEqualToString:@"ErrorMessage"]){
		NSLog(@"didStartElement Element: %@", elementName);
	}
	else if([elementName isEqualToString:@"NewPassword"]){
		NSLog(@"didStartElement Element: %@", elementName);
	}
	
		
	//NSLog(@"didStartElement Element: %@", elementName);
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
	//NSLog(@"didEnd Element Name %@",elementName);
	
	if([elementName isEqualToString:@"IsSuccess"]){
		if([currentElementValue isEqualToString:@"0"]){
			appDelegate.isValidLoginOrReg = NO;
		}else {
			appDelegate.isValidLoginOrReg = YES;
		}
		currentElementValue =[NSString stringWithFormat: @""];
	}
	
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
	if([elementName isEqualToString:@"AuthKey"]) {
		//currentElementValue = [currentElementValue stringByReplacingOccurrencesOfString:@"\n\t\t\t\t\t\t" withString:@""];
		appDelegate.userDetails = [NSString stringWithFormat:@"%@", [currentElementValue stringByReplacingOccurrencesOfString:@"\n\t\t\t\t\t\t" withString:@""]];
		NSLog(@"sssssssss Value: %@", appDelegate.userDetails);
	}
	
	else if([elementName isEqualToString:@"ErrorMessage"]){
		//currentElementValue = [currentElementValue stringByReplacingOccurrencesOfString:@"\n\t\t\t\t\t\t" withString:@""];
		appDelegate.errorDetails = [NSString stringWithFormat:@"%@", [currentElementValue stringByReplacingOccurrencesOfString:@"\n\t\t\t\t\t\t" withString:@""]];
	}
	else if([elementName isEqualToString:@"NewPassword"]){
		NSLog(@"didStartElement Element: %@", elementName);
		//currentElementValue = [currentElementValue stringByReplacingOccurrencesOfString:@"\n\t\t\t\t\t\t" withString:@""];
		appDelegate.recoveredPassWord = [NSString stringWithFormat:@"%@", [currentElementValue stringByReplacingOccurrencesOfString:@"\n\t\t\t\t\t\t" withString:@""]];
	}
	//Details About Each and every related book details
	
	// end of whole (book details)

			
		
		
		
		
	//[currentElementValue release];
	currentElementValue = nil;
}

- (void) dealloc {
	
	[currentElementValue release];
	[super dealloc];
}



@end
