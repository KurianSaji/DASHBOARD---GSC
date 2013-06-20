//
//  TocOfBook_Class.m
//  Comic Store
//
//  Created by neo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TocOfBook_Class.h"


@implementation TocOfBook_Class
@synthesize title,pageno;
- (id)init
{
	self = [super init];
	if (self) 
	{
		title = @"";
		pageno = @"";
	}
	return self;
}
- (void)dealloc 
{
	[title release];
	[pageno release];
	[super dealloc];
}
@end

