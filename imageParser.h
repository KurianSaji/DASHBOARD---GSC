//
//  imageParser.h
//  imagexml
//
//  Created by Zaah Technologies India PVT on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Videos;
@interface imageParser : UIViewController {
	
	NSMutableString *currentElementValue;
	Videos *vid;
}
- (imageParser *) initXMLParser;

@end
