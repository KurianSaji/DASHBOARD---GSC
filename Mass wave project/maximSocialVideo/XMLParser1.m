//
//  XMLParser.m
//  maximSocialVideo
//
//  Created by neo on 13/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLParser1.h"

@implementation XMLParser1

@synthesize currentKey, currentStringValue;

- (void)parseXMLFile:(NSString *)data
{
//
    
    BOOL success;
    
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[data dataUsingEncoding: NSUTF8StringEncoding]];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:YES];
    success = [parser parse];
    
}
 
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict 
    {
    
        NSLog(@"didStartElement ----- %@",elementName); 
        
        
        currentKey = nil;
        [currentStringValue release];
        currentStringValue = nil;
        if([elementName isEqualToString:@"popular"])
        {
            //alloc some object to parse value into
            if([elementName isEqualToString:@"total"]){
                currentKey = @"total";
                return;
            }
        }

        
        
        if ([elementName isEqualToString:@"popular"]) 
        {
            //
        }
        else if ([elementName isEqualToString:@"recent"]) 
        {
            //
        }
        
        
    
    }


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"total"] && [currentStringValue intValue] == 804){
        [currentStringValue intValue];
        return;
    }
}


@end
