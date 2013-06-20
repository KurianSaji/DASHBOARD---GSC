//
//  RelatedBookDeatails.h
//  epubstore_svc
//
//  Created by Zaah Technologies India PVT on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RelatedBookDeatails : NSObject {

	NSString *ReleatedIDValue;
	NSString *ReleatedName;
	NSString *ReleatedCoverPhoto;
	
}
@property(nonatomic,retain) NSString *ReleatedIDValue;
@property(nonatomic,retain) NSString *ReleatedName;
@property(nonatomic,retain) NSString *ReleatedCoverPhoto;

@end
