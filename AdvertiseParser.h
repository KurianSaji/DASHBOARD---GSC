//
//  AdvertiseParser.h
//  Comic Store
//
//  Created by neo on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Advertise_Class.h"

@class epubstore_svcAppDelegate;

@interface AdvertiseParser : NSObject 
{

	NSMutableString *currentElementValue;
	Advertise_Class *Advertise_Obj;
	NSMutableArray *Arr_Advertise;
	
}
- (AdvertiseParser *) initXMLParser;
@property(nonatomic, retain)NSMutableArray *Arr_Advertise;

@end
