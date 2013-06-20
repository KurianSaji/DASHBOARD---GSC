//
//  BookDetails.m
//  epubStore
//
//  Created by partha neo on 8/31/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "BookDetails.h"


@implementation BookDetails

@synthesize IsDownloading_Or_Downloaded;
@synthesize IDValue;
@synthesize ItunesProductID;
@synthesize ISBNNumber;
@synthesize AuthorID;
@synthesize Name;
@synthesize SubTitle;
@synthesize CoverPhoto;
@synthesize CatalogImage;
@synthesize CoverPhotoLarge;
@synthesize PopupImage;
@synthesize MagazinePDFFilePath;
@synthesize EpubSampleFileUrl;
@synthesize Description;
@synthesize Author;
@synthesize Purchased;
@synthesize Price;
@synthesize FeaturedBook;
@synthesize NewBook;
@synthesize FreeBook;
@synthesize ReleaseDate;
@synthesize ThumnailImage;




- (id)init
{
	self = [super init];
	if (self) 
	{
		IsDownloading_Or_Downloaded = NO;
		
		IDValue =@"";
		ItunesProductID =@"";
		ISBNNumber =@"";
		AuthorID =@"";
		Name =@"";
		SubTitle =@"";
		CoverPhoto =@"";
		CatalogImage =@"";
		CoverPhotoLarge =@"";
		PopupImage = @"";
		Description =@"";
		Author =@"";
		Purchased =@"";
		Price =@"";
		FeaturedBook =@"";
		NewBook =@"";
		FreeBook =@"";
		ReleaseDate =@"";
		
		
    }
	
    return self;
	
}
- (void)dealloc {
	[IDValue release];
    [ItunesProductID release];
	[ISBNNumber release];
	[AuthorID release];
	[Name release];
	[SubTitle release];
	[CoverPhoto release];
	[CatalogImage release];
	[PopupImage release];
	[CoverPhotoLarge release];
	[Description release];
	[Author release];
	[Purchased release];
	[Price release];
	[FeaturedBook release];
	[NewBook release];
	[FreeBook release];
	[ReleaseDate release];
	[ThumnailImage release];
	[super dealloc];
}
@end
