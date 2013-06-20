// Shelf.h

#import <Foundation/Foundation.h>
#import "CatalogEntry.h"
#import "Book.h"

@class Shelf;
@class NCXNavigationDefinition;

@protocol ShelfDelegate
- (void) shelfDidChange: (Shelf*) shelf;
@end

@interface Shelf : NSObject {
  @private
	NSMutableArray* books_;
	id<ShelfDelegate> delegate_;
	
	//This is for fixing urgent Fix 
	NSMutableArray *bookIndexArray_;
	
	
}

+ (id) sharedShelf;

@property (nonatomic,readonly) NSArray* books;
@property (nonatomic,assign) id<ShelfDelegate> delegate;
@property (nonatomic,retain) NSMutableArray *bookIndexArray;
- (void) createBookFromCatalogEntry: (NSData*) data Name:(NSString *)name;

- (void) removeBookAtIndex: (NSUInteger) index;

- (NCXNavigationDefinition*) parseNavigationDefinitionWithBook: (Book*) book;

@end