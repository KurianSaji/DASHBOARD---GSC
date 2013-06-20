// Shelf.m

#import "Shelf.h"
#import "ZipArchive.h"
#import "XMLDigester.h"
#import "XMLDigesterObjectCreateRule.h"
#import "XMLDigesterSetNextRule.h"
#import "XMLDigesterCallMethodWithAttributeRule.h"
#import "NCXNavigationDefinition.h"
#import "NCXNavigationPoint.h"
#import "XMLParser.h"

static Shelf* sSharedShelf = nil;
NSString * opfFileName;

@interface Shelf (Private)
- (void) readBooksDatabase;
- (void) writeBooksDatabase;
@end


@implementation Shelf

@synthesize books = books_;
@synthesize delegate = delegate_;
@synthesize bookIndexArray = bookIndexArray_;


+ (id) sharedShelf
{
	@synchronized (self) {
		if (sSharedShelf == nil) {
			sSharedShelf = [self new];
		}
	}
	return sSharedShelf;
}

- (id) init
{
	if ((self = [super init]) != nil) {
		books_ = [NSMutableArray new];
		bookIndexArray_ =[NSMutableArray new];
		//bookIndexArray =[NSMutableArray alloc];
		[self readBooksDatabase];
	}
	return self;
}

- (void) dealloc
{
	[books_ release];
	[super dealloc];
}

- (void) createBookFromCatalogEntry: (NSData*)data Name:(NSString *)name
{
	// Store the EPUB data to disk
	name = [name stringByReplacingOccurrencesOfString:@".epub" withString:@""];
	
	//NSString* identifier = [NSString stringWithFormat: @"%d-%d", time(NULL), random()]; // For the sake of this demo we use some random number. Better would be a UUID.
	NSString* identifier = name; 
	NSString* filePath = [NSString stringWithFormat: @"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], identifier];
	[data writeToFile: filePath atomically: YES];
	
	// Create a directory and then unzip it
    [bookIndexArray_ addObject:name];
	NSString* directoryPath = [NSString stringWithFormat: @"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], identifier];
	[[NSFileManager defaultManager] createDirectoryAtPath: @"" attributes: nil];
	NSLog(@"UN_ZIPPEDFILEPATH %@",directoryPath);
	ZipArchive* za = [ZipArchive new];
	[za UnzipOpenFile: filePath];
	[za UnzipFileTo: directoryPath overWrite: YES];
	[za release];
	
	 //Add the book to the shelf and then archive it

	Book* book = [[Book new] autorelease];
	//book.title = catalogEntry.title;
//	book.author = catalogEntry.author;
	
	book.title  = name;
	book.author = @"John Dickson";
	book.fileName = identifier;
	
	[books_ addObject: book];
	
	[self writeBooksDatabase];

	if (delegate_ != nil) {
		[delegate_ shelfDidChange: self];
	}
	
	
}

- (void) removeBookAtIndex: (NSUInteger) index
{
	Book* book = [books_ objectAtIndex: index];
	if (book != nil)
	{
		NSString* path = [NSString stringWithFormat: @"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
		[[NSFileManager defaultManager] removeItemAtPath: path error: NULL];
		
		[books_ removeObjectAtIndex: index];
		[self writeBooksDatabase];
		
		if (delegate_ != nil) {
			[delegate_ shelfDidChange: self];
		}
	}
}

- (NCXNavigationDefinition*) parseNavigationDefinitionWithBook:(Book *)book
{
//	// Parse the container
//
//	NSString* containerPath = [NSString stringWithFormat: @"%@/%@/META-INF/container.xml", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
//	NSData* containerData = [NSData dataWithContentsOfFile: containerPath];
//	
//	XMLDigester* digester = [XMLDigester digesterWithData: containerData];
//	
//	[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [OCFContainer class]] forPattern: @"container"];
//	[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [OCFRootFile class]] forPattern: @"container/rootfiles/rootfile"];
//	[digester addRule: [XMLDigesterSetNextRule setNextRuleWithDigester: digester selector: @selector(addRootFile:)] forPattern: @"container/rootfiles/rootfile"];
//	
//	OCFContainer* container = [digester digest];
//	
//	// Dump the container
//	
//	NSLog(@"Container = %@", container);
//	for (OCFRootFile* rootFile in container.rootFiles) {
//		NSLog(@" RootFile = %@", rootFile);
//	}
	
	// Parse the navigation definition

	// TODO: We should really take the location of the toc from the OEPBSPackage - For a demo this works
	
	NSString* ncxPath = [NSString stringWithFormat: @"%@/%@/OPS/Toc.ncx", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
	NSString* htmlFilePath = [NSString stringWithFormat: @"%@/%@/OPS/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:ncxPath];
	if(!fileExists)
	{
		ncxPath = [NSString stringWithFormat: @"%@/%@/OPS/toc.ncx", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
		
		fileExists = [[NSFileManager defaultManager] fileExistsAtPath:ncxPath];
		
	}
	if (!fileExists) {
		ncxPath = [NSString stringWithFormat: @"%@/%@/OEBPS/Toc.ncx", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
		htmlFilePath = [NSString stringWithFormat: @"%@/%@/OEBPS/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
		fileExists = [[NSFileManager defaultManager] fileExistsAtPath:ncxPath];
		if (!fileExists) {
			ncxPath = [NSString stringWithFormat: @"%@/%@/OEBPS/toc.ncx", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
			fileExists = [[NSFileManager defaultManager] fileExistsAtPath:ncxPath];
		}
	}
	if(!fileExists)
	{
		ncxPath = [NSString stringWithFormat: @"%@/%@/Toc.ncx", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
		htmlFilePath = [NSString stringWithFormat: @"%@/%@/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
		fileExists = [[NSFileManager defaultManager] fileExistsAtPath:ncxPath];
		if (!fileExists) {
			ncxPath = [NSString stringWithFormat: @"%@/%@/toc.ncx", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
			
		}
	}
	
	
	NSData* ncxData = [NSData dataWithContentsOfFile: ncxPath];
	if(ncxData==nil)
	{
		
		ncxData = [NSData dataWithContentsOfFile: ncxPath];
	}
	
		
	if(ncxData!=nil)
	{

		XMLDigester* digester = [XMLDigester digesterWithData: ncxData];
	
		[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [NCXNavigationDefinition class]] forPattern: @"ncx"];

		[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [NCXNavigationPoint class]] forPattern: @"ncx/navMap/navPoint"];
		[digester addCallMethodWithElementBodyRuleWithSelector: @selector(setLabel:) forPattern: @"ncx/navMap/navPoint/navLabel/text"];
		[digester addRule: [XMLDigesterCallMethodWithAttributeRule callMethodWithAttributeRuleWithDigester: digester selector: @selector(setContent:) attribute: @"src"] forPattern: @"ncx/navMap/navPoint/content"];
		[digester addRule: [XMLDigesterSetNextRule setNextRuleWithDigester: digester selector: @selector(addNavigationPoint:)] forPattern: @"ncx/navMap/navPoint"];
	
		NCXNavigationDefinition* navigationDefinition = [digester digest];
	
		NSString* content = [[NSString alloc] initWithData:ncxData encoding:NSASCIIStringEncoding];
	
	
		if([content rangeOfString:@"</docTitle>"].location!=NSNotFound)
		{
			NSRange end = [content rangeOfString: @"</docTitle>"];
		
			NSRange start = [content rangeOfString: @"<docTitle>"];
		
			int i =  end.location-(start.location+start.length);
			NSString *textTag = [content substringWithRange: NSMakeRange (start.location+start.length,i)];
			NSLog(@"%@",textTag);
		
			end = [content rangeOfString: @"</text>"];
		
			start = [content rangeOfString: @"<text>"];
		
			i =  end.location-(start.location+start.length);
			textTag = [content substringWithRange: NSMakeRange (start.location+start.length,i)];
			NSLog(@"%@",textTag);
		
			if ([textTag rangeOfString:@"&#8217;"].location!=NSNotFound) 
			{
				textTag = [textTag stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
			}
			navigationDefinition.bookName = textTag;
		
		//NSRange match2 = [mat1 rangeOfString: @"\""];
//		NSString * link = [mat1 substringWithRange: NSMakeRange (0,match2.location)]; 
//		NSLog(@"%@",link);
//		NSString *imageTag = [NSString stringWithFormat:@"<img align=\"center\" width=\"100%%\" height=\"100%%\" src=\"%@\"/>",link];
//		NSLog(@"%@",imageTag);
//		int betweenLength =  end.location+end.length-start.location;
//		
//		content = [content stringByReplacingCharactersInRange: NSMakeRange(start.location, betweenLength) withString:imageTag];
//		NSLog(@"%@",content);
//		NSData* databuffer=[content dataUsingEncoding:NSUTF8StringEncoding];
//		NSFileManager *filemgr;
//		
//		filemgr = [NSFileManager defaultManager];
//		
//		[filemgr createFileAtPath:path contents: databuffer attributes: nil];
		
		
		
	}
	
    /*
	 To Retrive the file names in a folder
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager directoryContentsAtPath:documentsDirectory];
    for (NSString *s in fileList){
        NSLog(s);
    }
	 */
	
	//Get The Html File Names 	
	NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager directoryContentsAtPath:htmlFilePath];
    for (NSString *htmlName in fileList){
		
		//NSRange match = [htmlName rangeOfString: @".html"];
//		if (match.location != NSNotFound)
//		{
//			htmlName = [htmlName substringWithRange: NSMakeRange (0,match.location+5)];
//			//[navigationDefinition.HTML_NamesArray addObject:htmlName];
//		}	
//		
//		else if([htmlName rangeOfString:@".htm"].location!=NSNotFound){
//				match = [htmlName rangeOfString: @".htm"];
//				htmlName = [htmlName substringWithRange: NSMakeRange (0,match.location+4)];
//				//[navigationDefinition.HTML_NamesArray addObject:htmlName];
//			
//		}
		//else if([htmlName rangeOfString:@".opf"].location!=NSNotFound)
		
		if([htmlName rangeOfString:@".opf"].location!=NSNotFound)
		{
			NSRange match = [htmlName rangeOfString: @".opf"];
			opfFileName =[htmlName substringWithRange: NSMakeRange (0,match.location+4)];
		}
		
    }
	
	
	//Get File name From Opf File Name
	
	NSString *filePath = [NSString stringWithFormat:@"%@%@",htmlFilePath,opfFileName];
	//NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Gamexml" ofType:@"xml"]; 

	NSLog(@"File Path  For OPF %@",filePath);
	NSData * xmlData;
	if (filePath) { 
		NSString *myText = [NSString stringWithContentsOfFile:filePath];
		if (myText) { 
			xmlData=[myText dataUsingEncoding:NSUTF8StringEncoding];
			//NSLog(@"Read String: %@",myText);
			NSLog(@"Read String: %@",xmlData);
		} 
		
	}
	if(xmlData!=nil)
	{
		NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
	
	

		//NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
		//Initialize the delegate.
		XMLParser *parser = [[XMLParser alloc] initXMLParser];	
	
		//Set delegate
		[xmlParser setDelegate:parser];
	
		//Start parsing the XML file.
	
		BOOL success = [xmlParser parse];
		[xmlParser release];
		xmlParser=nil;
	
		if(success)
		{
			navigationDefinition.HTML_NamesArray =parser.HtmlNameParsedArray;
			//NSLog([navigationDefinition.HTML_NamesArray description]);
			NSLog(@"No Errors");
		}
		else
			NSLog(@"Error Error Error!!!");
		}
		return navigationDefinition;
	}
	
}

@end

@implementation Shelf (Private)

- (NSString*) booksDatabasePath
{
	NSString *url = [NSString stringWithFormat: @"%@/Books.archive", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0]]; 
	NSLog(@"My - url %@",url);
	//BOOL exists = [self checkFileExist:url];
	return [NSString stringWithFormat: @"%@/Books.archive", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0]];
}
-(BOOL) checkFileExist:(NSString*)filename
{
	
	
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filename];
	return fileExists;
}
- (void) readBooksDatabase
{
	[books_ setArray: [NSKeyedUnarchiver unarchiveObjectWithFile: [self booksDatabasePath]]];
}

- (void) writeBooksDatabase
{
	[NSKeyedArchiver archiveRootObject: books_ toFile: [self booksDatabasePath]];
}

@end