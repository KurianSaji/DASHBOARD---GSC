//
//  TocXmlParser.h
//  Comic Store
//
//  Created by neo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TocOfBook_Class.h"
@class epubstore_svcAppDelegate;
@interface TocXmlParser : NSObject 
{
	NSMutableString *currentElementValue;
	TocOfBook_Class *TocB_Obj;
	NSMutableArray *Arr_Toc;
}
@property(nonatomic, retain)NSMutableArray *Arr_Toc;
- (TocXmlParser *) initXMLParser;
@end

