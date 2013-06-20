//
//  BannersParser.h
//  Comic Store
//
//  Created by neo on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baners_Class.h"
@class epubstore_svcAppDelegate;

@interface BannersParser : NSObject 
{
	NSMutableString *currentElementValue;
	Baners_Class *Banners_Obj;
	NSMutableArray *Arr_Banners;
	
}
- (BannersParser *) initXMLParser;
@property(nonatomic, retain)NSMutableArray *Arr_Banners;
@end
