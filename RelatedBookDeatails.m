//
//  RelatedBookDeatails.m
//  epubstore_svc
//
//  Created by Zaah Technologies India PVT on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RelatedBookDeatails.h"


@implementation RelatedBookDeatails
@synthesize ReleatedIDValue;
@synthesize ReleatedName;
@synthesize ReleatedCoverPhoto;

-(id)init
{
	self = [super init];
	if(self)
	{
		ReleatedIDValue = @"NULL";
		ReleatedName = @"NULL";
		ReleatedCoverPhoto  = @"NULL";
	}
	return self;
}

- (void)dealloc 
{
	[super dealloc];
	[ReleatedIDValue release];
	[ReleatedName release];
	[ReleatedCoverPhoto release];
}
@end
