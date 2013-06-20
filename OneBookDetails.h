//
//  OneBookDetails.h
//  epubStore
//
//  Created by partha neo on 8/31/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OneBookDetails : NSObject
{
	NSString * IDValue;
	NSString * ItunesProductID;
	NSString * Purchased;
	NSString * ISBNNumber;
	
	NSString * Name;
	NSString * SubTitle;
	NSString * Author;
	NSString * CoverPhoto;
	NSString * Price;
	NSString * Description;
	NSMutableArray *RealatedBookArray;
}

@property (nonatomic, retain) NSString * IDValue;
@property (nonatomic, retain) NSString * ItunesProductID;
@property (nonatomic, retain) NSString * Purchased;
@property (nonatomic, retain) NSString * ISBNNumber;

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * SubTitle;
@property (nonatomic, retain) NSString * Author;
@property (nonatomic, retain) NSString * CoverPhoto;
@property (nonatomic, retain) NSString * Price;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSMutableArray *RealatedBookArray;

@end
