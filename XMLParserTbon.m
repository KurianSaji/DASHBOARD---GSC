//
//  XMLParser.m
//  FreeRideHome
//
//  Created by Partha on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XMLParserTbon.h"
//#import "TBONEAppDelegate.h"

//TBONEAppDelegate *appDelegate;

@implementation XMLParserTbon
@synthesize xmlIndex;

- (XMLParserTbon *) initXMLParserwithIndex:(NSInteger)index{
	
	[super init];
	xmlIndex = index;
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (xmlIndex == 1) {
        appDelegate.gameController.serverResponseDict = [[NSMutableDictionary alloc] init];
    }
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	if (xmlIndex ==1) {
     	if ([elementName isEqualToString:@"Response"])
        {
        }
        
        if([elementName isEqualToString:@"FBAppId"])
        {
        }
        
        if([elementName isEqualToString:@"FBAppSecret"])
        {
        }
        
        if([elementName isEqualToString:@"contestCloseDate"])
        {
        }
        
        if([elementName isEqualToString:@"contestText1"])
        {
        }
        if([elementName isEqualToString:@"contestText2"])
        {
        }
		if([elementName isEqualToString:@"termsURL"])
        {
        }
		if([elementName isEqualToString:@"contestValid"])
		{
		}
		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	if(!currentElementValueNew) 
		currentElementValueNew = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValueNew appendString:string];
	
	//NSLog(@"Processing Value: %@", currentElementValueNew);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (xmlIndex ==1) {
		
		if ([elementName isEqualToString:@"FBAppId"])
        {
			NSMutableString *tempString = [[NSMutableString alloc] initWithString:currentElementValueNew];
            NSInteger r = [tempString replaceOccurrencesOfString:@"\n" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"\t" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"\r" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"  " withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"XXX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"XX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            
            [appDelegate.gameController.serverResponseDict setObject:tempString forKey:@"APPID"];
			
        }
        
		
        
        if([elementName isEqualToString:@"FBAppSecret"])
        {
			
			NSMutableString *tempString = [[NSMutableString alloc] initWithString:currentElementValueNew];
            NSInteger r = [tempString replaceOccurrencesOfString:@"\n" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"\t" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"\r" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"  " withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"XXX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"XX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            
            [appDelegate.gameController.serverResponseDict setObject:tempString forKey:@"APPSECRET"];
			
        }
        
        if([elementName isEqualToString:@"contestCloseDate"])
        {
			NSMutableString *tempString = [[NSMutableString alloc] initWithString:currentElementValueNew];
            NSInteger r = [tempString replaceOccurrencesOfString:@"\n" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"\t" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"\r" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"  " withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"XXX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"XX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            
            [appDelegate.gameController.serverResponseDict setObject:tempString forKey:@"CONTESTCLOSEDATE"];
        }
        
        if([elementName isEqualToString:@"contestText1"])
        {
			NSMutableString *tempString = [[NSMutableString alloc] initWithString:currentElementValueNew];
          //  NSInteger r = [tempString replaceOccurrencesOfString:@"\n" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
         //   r = [tempString replaceOccurrencesOfString:@"\t" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
         //   r = [tempString replaceOccurrencesOfString:@"\r" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
         //   r = [tempString replaceOccurrencesOfString:@"  " withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
         //   r = [tempString replaceOccurrencesOfString:@"XXX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
         //   r = [tempString replaceOccurrencesOfString:@"XX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            
            [appDelegate.gameController.serverResponseDict setObject:tempString forKey:@"CONTESTTEXT1"];
        }
        if([elementName isEqualToString:@"contestText2"])
        {
			
			NSMutableString *tempString = [[NSMutableString alloc] initWithString:currentElementValueNew];
        //    NSInteger r = [tempString replaceOccurrencesOfString:@"\n" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
        //    r = [tempString replaceOccurrencesOfString:@"\t" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
         //   r = [tempString replaceOccurrencesOfString:@"\r" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
        //    r = [tempString replaceOccurrencesOfString:@"  " withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
        //    r = [tempString replaceOccurrencesOfString:@"XXX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
        //     r = [tempString replaceOccurrencesOfString:@"XX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            
            [appDelegate.gameController.serverResponseDict setObject:tempString forKey:@"CONTESTTEXT2"];
        }
		
		if([elementName isEqualToString:@"termsURL"])
        {
			NSMutableString *tempString = [[NSMutableString alloc] initWithString:currentElementValueNew];
            NSInteger r = [tempString replaceOccurrencesOfString:@"\n" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"\t" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"\r" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"  " withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"XXX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"XX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            
            [appDelegate.gameController.serverResponseDict setObject:tempString forKey:@"TERMSURL"];
        }
		
		if([elementName isEqualToString:@"contestValid"])
        {
			NSMutableString *tempString = [[NSMutableString alloc] initWithString:currentElementValueNew];
            NSInteger r = [tempString replaceOccurrencesOfString:@"\n" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"\t" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"\r" withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"  " withString:@"" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"XXX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            r = [tempString replaceOccurrencesOfString:@"XX" withString:@"\n" options:NSASCIIStringEncoding range:NSMakeRange(0, [tempString length]-1)];
            
            [appDelegate.gameController.serverResponseDict setObject:tempString forKey:@"CONTESTVALID"];
        }
		
		
		
		
        if([elementName isEqualToString:@"Response"]){
		}
		
		[currentElementValueNew release];
		currentElementValueNew = nil;
		[currentElementValueNew release];
	}
	
	
}
	
	
	/*
	 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
	 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	 // Custom initialization
	 }
	 return self;
	 }
	 */
	
	/*
	 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
	 - (void)viewDidLoad {
	 [super viewDidLoad];
	 }
	 */
	
	/*
	 // Override to allow orientations other than the default portrait orientation.
	 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	 // Return YES for supported orientations
	 return (interfaceOrientation == UIInterfaceOrientationPortrait);
	 }
	 */
	
	- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
		[super didReceiveMemoryWarning];
		
		// Release any cached data, images, etc that aren't in use.
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
