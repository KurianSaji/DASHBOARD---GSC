//
//  BookDetails.m
//  epubStore
//
//  Created by partha neo on 8/31/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "OneBookDetails.h"


@implementation OneBookDetails

@synthesize IDValue;
@synthesize ItunesProductID;
@synthesize Purchased;
@synthesize ISBNNumber;

@synthesize Name;
@synthesize SubTitle;
@synthesize Author;
@synthesize CoverPhoto;
@synthesize Price;
@synthesize Description;
@synthesize RealatedBookArray;

- (void)dealloc {
	[super dealloc];
	[IDValue release];
	[ItunesProductID release];
	[Purchased release];
	[ISBNNumber release];
	
	[Name release];
	[SubTitle release];
	[Author release];
	[CoverPhoto release];
	[Price release];
	[Description release];
	[RealatedBookArray release];
}

@end
