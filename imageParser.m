//
//  imageParser.m
//  imagexml
//
//  Created by Zaah Technologies India PVT on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "imageParser.h"
#import "Videos.h"
//#import "Image.h"


@implementation imageParser

- (imageParser *) initXMLParser {
	[super init];
	NSLog(@"image parser");
	//vid = [[Videos alloc]init];
	//vid.images = [[NSMutableArray alloc] init];

	
	return self;
}

//- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
//  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
//	attributes:(NSDictionary *)attributeDict {
//	
//	if([elementName isEqualToString:@"XML"]) {
//		//Initialize the array.
//		
//		appDelegate.titleName = [[NSMutableArray alloc] init];
//
//		
//	}
//	else if([elementName isEqualToString:@"thumbURL"]) {
//		
//		//Initialize the book.
//		//img = [[Image alloc] init];
//		
//		//Extract the attribute here.
//		//img.imageName = [attributeDict objectForKey:@"id"];
//		
//	}
//	
//	NSLog(@"Processing Element: %@", elementName);
//}
//
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
//	
//	if(!currentElementValue) 
//		currentElementValue = [[NSMutableString alloc] initWithString:string];
//	else
//		[currentElementValue appendString:string];
//	
//	NSLog(@"Processing Value: %@", currentElementValue);
//	
//}
//
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
//  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//	
//	if([elementName isEqualToString:@"XML"])
//		return;
//	
//	//There is nothing to do if we encounter the Books element here.
//	//If we encounter the Book element howevere, we want to add the book object to the array
//	// and release the object.
//	if([elementName isEqualToString:@"thumbURL"]) {
//		[appDelegate.images addObject:currentElementValue];
//		//NSLog(@"appDelegate %@",[appDelegate.images description]);
//		
//		//[img release];
//		//img = nil;
//	}
//	else {
//	//	[img setValue:currentElementValue forKey:elementName];
//
//	}
//
//	
//	// if([elementName isEqualToString:@"PopupImage"])
////	{
////		[appDelegate.titleName addObject:currentElementValue];
////	}
//
//		//
//	
//	[currentElementValue release];
//	currentElementValue = nil;
//}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
