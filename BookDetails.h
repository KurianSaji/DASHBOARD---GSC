//
//  BookDetails.h
//  epubStore
//
//  Created by partha neo on 8/31/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookDetails : NSObject
{
	NSString *IDValue;
	NSString *ItunesProductID;
	NSString *ISBNNumber;
	NSString *AuthorID;
	NSString *Name;
	NSString *SubTitle;
	NSString *CoverPhoto;
	NSString *CatalogImage;
	NSString *CoverPhotoLarge;
	NSString *PopupImage;
	NSString *MagazinePDFFilePath;
	NSString *EpubSampleFileUrl;
	NSString *Description;
	NSString *Author;
	NSString *Purchased;
	NSString *Price;
	NSString *FeaturedBook;
	NSString *NewBook;
	NSString *FreeBook;
	NSString *ReleaseDate;
	UIImage  *ThumnailImage;	
	
	
	BOOL IsDownloading_Or_Downloaded;
}

@property(nonatomic)BOOL IsDownloading_Or_Downloaded;

@property (nonatomic,retain) NSString *IDValue;
@property (nonatomic,retain) NSString *ItunesProductID;
@property (nonatomic,retain) NSString *ISBNNumber;
@property (nonatomic, retain) NSString * AuthorID;
@property (nonatomic,retain) NSString *Name;
@property (nonatomic,retain) NSString *SubTitle;
@property (nonatomic,retain) NSString *CoverPhoto;
@property (nonatomic,retain) NSString *CatalogImage;
@property (nonatomic,retain) NSString *CoverPhotoLarge;
@property (nonatomic,retain) NSString *PopupImage;
@property (nonatomic,retain) NSString *MagazinePDFFilePath;
@property (nonatomic,retain) NSString *EpubSampleFileUrl;
@property (nonatomic,retain) NSString *Description;
@property (nonatomic,retain) NSString *Author;
@property (nonatomic,retain) NSString *Purchased;
@property (nonatomic,retain) NSString *Price;
@property (nonatomic,retain) NSString *FeaturedBook;
@property (nonatomic,retain) NSString *NewBook;
@property (nonatomic,retain) NSString *FreeBook;
@property (nonatomic,retain) NSString *ReleaseDate;
@property (nonatomic,retain)UIImage  *ThumnailImage;
@end
