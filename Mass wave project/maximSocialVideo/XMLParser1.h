//
//  XMLParser.h
//  maximSocialVideo
//
//  Created by neo on 13/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser1 : NSObject <NSXMLParserDelegate>
{

    NSString *currentKey, *currentStringValue;
    
}

@property(nonatomic, retain)NSString *currentKey, *currentStringValue;

- (void)parseXMLFile:(NSString *)data;

@end
