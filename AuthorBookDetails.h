//
//  AuthorBookDetails.h
//  Comic Store
//
//  Created by Zaah Technologies India PVT on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AuthorBookDetails : NSObject {
	NSString * IDValue;
	NSString * ISBNNumber;
	NSString * Name;
	NSString * Description;
	NSString * CoverPhoto;
}

@property (nonatomic,retain) NSString * IDValue;
@property (nonatomic,retain) NSString * ISBNNumber;
@property (nonatomic,retain) NSString * Name;
@property (nonatomic,retain) NSString * Description;
@property (nonatomic,retain) NSString * CoverPhoto;
@end
