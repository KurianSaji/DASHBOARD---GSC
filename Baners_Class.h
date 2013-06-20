//
//  Baners_Class.h
//  Comic Store
//
//  Created by neo on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Baners_Class : NSObject 
{
	NSString *imageURL;
	NSString *BannerURL;
}
@property(nonatomic, retain)NSString *imageURL;
@property(nonatomic, retain)NSString *BannerURL;
@end
