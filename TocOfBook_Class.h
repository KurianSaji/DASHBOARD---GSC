//
//  TocOfBook_Class.h
//  Comic Store
//
//  Created by neo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TocOfBook_Class : NSObject 
{
	NSString *title;
	NSString *pageno;
}
@property(nonatomic, retain)NSString *title;
@property(nonatomic, retain)NSString *pageno;

@end
