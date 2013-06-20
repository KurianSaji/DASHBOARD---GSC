//
//  AuthorBookDetails.m
//  Comic Store
//
//  Created by Zaah Technologies India PVT on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AuthorBookDetails.h"


@implementation AuthorBookDetails
@synthesize IDValue;
@synthesize ISBNNumber;
@synthesize Name;
@synthesize Description;
@synthesize CoverPhoto;

- (void)dealloc {
	[super dealloc];
	[IDValue release];
	[ISBNNumber release];
	[Name release];
	[Description release];
	[CoverPhoto release];
}
@end
