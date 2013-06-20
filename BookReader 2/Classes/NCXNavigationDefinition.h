// NCXNavigationDefinition.h

#import <Foundation/Foundation.h>
#import "NCXNavigationPoint.h"

@interface NCXNavigationDefinition : NSObject {
	NSMutableArray* navigationPoints_;
	NSMutableArray* HTML_NamesArray;
	NSString* bookName;
}

@property (nonatomic,retain) NSMutableArray* navigationPoints;
@property (nonatomic,retain) NSMutableArray* HTML_NamesArray;
@property (nonatomic,retain) NSString* bookName;

- (void) addNavigationPoint: (NCXNavigationPoint*) navigationPoint;

@end