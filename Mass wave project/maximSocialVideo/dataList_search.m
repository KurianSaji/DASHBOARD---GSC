//
//  dataList_search.m
//  maximSocialVideo
//
//  Created by neo on 10/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "dataList_search.h"

@implementation dataList_search

@synthesize isSingleSelection;
@synthesize searching;
@synthesize aTableView;
@synthesize nameLabel;
@synthesize btnSelectImage, btnUnSelectImage;
@synthesize friendsList;


epubstore_svcAppDelegate *appDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,frame.size.width ,frame.size.height+20)];
        
        backgroundImageView.image = [UIImage imageNamed:@"bg_4.png"];
        [self addSubview:backgroundImageView];
        [self sendSubviewToBack:backgroundImageView];
        
        searching = NO;
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        
        appDelegate.videoTaggedIds = tempArray;
        
        [tempArray release];
        
        [self fetchFriendsList];
        
        
        /**/
        
        UIView *vl_SearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, self.frame.size.width , 35)];
        vl_SearchView.backgroundColor = [UIColor blackColor];
        [self addSubview:vl_SearchView];
        
        
        [vl_SearchView release];
        
        /**/
        
        
        aTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,90, frame.size.width ,frame.size.height)];
        //[aTableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
        [aTableView setBackgroundColor:[UIColor clearColor]];
        [aTableView setShowsVerticalScrollIndicator:NO];
        [aTableView setDelegate:self];
        [aTableView setDataSource:self];
        
        aTableView.separatorColor=[UIColor whiteColor];
        //aTableView.backgroundColor  = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        
        [self addSubview:aTableView];	
        
    }
    return self;
}


-(void)fetchFriendsList
{
    
     NSString *urlString =[NSString stringWithFormat:@"%@media/list",ServerIp];
     
     urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     // setting up the request object now
     NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
     
     [request setURL:[NSURL URLWithString:urlString]];
     
     
     NSString *myParameters = [NSString stringWithFormat:@"method=user.friends&user_id=%@", appDelegate.FBfriendsIds];
     
     
     
     [request setHTTPMethod:@"POST"];
     
     [request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
     
     // now lets make the connection to the web
     NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     
     NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
     
    NSError *error;
    
    
     
    
    if (returnString) 
    {
        
        self.friendsList = [XMLReader  dictionaryForXMLString:returnString error:&error];
        
        //appDelegate.myarray =  self.friendsList;
        
        
        appDelegate.myarray = [[self.friendsList objectForKey:@"Tagged"]objectForKey:@"user"];
        
        
    }
    
    
    
}



-(void)loadTableView
{
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    
    
    if ([ appDelegate.myarray isKindOfClass:[NSDictionary class]])
    {
        return 1;
        
    }
    else
    {
        return [appDelegate.myarray count];
	
    }
	if (searching)
    {    
		//return [aSearchfbtab count];
	}
    else 
    {
		//return [appDelegate.myarray count];
	}
	
	
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [indexPath row] * 20;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        return 36;
        
    }
    else
    {
        return 75;
    }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
    }
	
    /*-------Adding Image to Cell--------Start---- */ 
    photoButton *button;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        button=[[photoButton alloc]initWithFrame:CGRectMake(10, 5, 25, 25)];
        
    }
    else
    {    
        button=[[photoButton alloc]initWithFrame:CGRectMake(12, 8, 56, 54)];
        
    }
    button.userInteractionEnabled=NO;
    
//    if ([ appDelegate.myarray isKindOfClass:[NSDictionary class]])
//    {
//        [(photoButton*)button loadImage:[[appDelegate.myarray valueForKey:@"uimg"]objectForKey:@"text"] isLast:TRUE];
//    }
//    else
//    {
//        [(photoButton*)button loadImage:[[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"uimg"]objectForKey:@"text"] isLast:TRUE]; 
//    }  
    
    
    
    /////////////////////////////////////////////////////////////
    
    /*URL CACHE  CHECK*/
    NSString *tempStr ;
    if ([ appDelegate.myarray isKindOfClass:[NSDictionary class]])
    {
        tempStr = [[appDelegate.myarray valueForKey:@"uimg"]objectForKey:@"text"] ;
    }
    else
    {
       tempStr = [[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"uimg"]objectForKey:@"text"]; 
    }  
    
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* lastComponent = tempStr;
    NSString *path = [[searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
    
    
    
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) 
    {
        //path = [NSString stringWithFormat:@"file://localhost/private%@",path];
        NSData *dataImage = [NSData dataWithContentsOfFile:path];
        [(photoButton*)button setBackgroundImage:[UIImage imageWithData:dataImage] forState:UIControlStateNormal];
        
        
    }else
    {
        [(photoButton*)button loadImage:tempStr isLast:TRUE]; 
        
    }

    
    
    /////////////////////////////////////////////////////////////
    [cell.contentView addSubview:button]; 
    [button release];
    /*-------Adding Image to Cell--------END----*/
    
    
    /*-------Adding Title to Cell--------Start---- */ 
    int lblFontSize;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(52,0,212,36)];
        lblFontSize = 15;
    }
    else
    {    
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(100,0,500,75)];
        lblFontSize = 40;
    }
	nameLabel.font = [UIFont boldSystemFontOfSize:lblFontSize];
    nameLabel.textColor=[UIColor yellowColor];
	nameLabel.backgroundColor=[UIColor clearColor];
    
    
    if ([ appDelegate.myarray isKindOfClass:[NSDictionary class]])
    {
        nameLabel.text=[NSString stringWithFormat:@"%@ %@",[[appDelegate.myarray valueForKey:@"fname"]objectForKey:@"text"] , [[appDelegate.myarray valueForKey:@"lname"]objectForKey:@"text"]];
    }
    else
    {
    
        nameLabel.text=[NSString stringWithFormat:@"%@ %@",[[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"fname"]objectForKey:@"text"] , [[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"lname"]objectForKey:@"text"]];

	}
    
    	[cell addSubview:nameLabel];
   // nameLabel.layer.borderColor = [UIColor greenColor].CGColor;
    
   // nameLabel.layer.borderWidth = 1.0;
    
    [nameLabel release];
    /*-------Adding Title to Cell--------END---- */
    
    
    
    
    
    
    /*-------Adding CheckList Button to Cell--------Start---- */ 
        
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        button=[[photoButton alloc]initWithFrame:CGRectMake(263, 0, 60, 37)];
         
        
    }
    else
    {    
        button=[[photoButton alloc]initWithFrame:CGRectMake(600, 8, 56, 54)];
        
        
    }
    //[button addTarget:self action:@selector(tagging) forControlEvents:UIControlEventTouchUpInside]; 
    
    
    
    [button setTitle:@"Tag" forState:UIControlStateNormal];
    (button).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:15];
    
    button.tag = [indexPath row]+1;
    
    
    if ([ appDelegate.myarray isKindOfClass:[NSDictionary class]])
    {
        button.videoUserId  = [[appDelegate.myarray valueForKey:@"uid"]objectForKey:@"text"]; }
    else
    {
        button.videoUserId  = [[[appDelegate.myarray objectAtIndex:[indexPath row]]objectForKey:@"uid"]objectForKey:@"text"];
    }
    [button setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    //button.layer.borderColor = [UIColor greenColor].CGColor;
    //button.layer.borderWidth = 1.0;
    [button addTarget:self action:@selector(addRemoveTag:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [cell.contentView addSubview:button]; 
    [button release];
    
    
    /*-------Adding CheckList Button--------END----*/
    
    
	
	return cell;
}



-(void)addRemoveTag:(photoButton*)sender
{

    
   
    
    
    NSString *UserId = sender.videoUserId;
    int userTab = [sender tag];
    
    
    if ([appDelegate.videoTaggedIds containsObject:UserId] ) 
    {
    
        [appDelegate.videoTaggedIds removeObject:UserId];
        UIButton *tempButton = (UIButton *)[self viewWithTag:userTab];
        [tempButton setTitle:@"Tag" forState:UIControlStateNormal];
        //[tempButton release];
        
     
    }
    else
    {
    
        [appDelegate.videoTaggedIds addObject:UserId];
        UIButton *tempButton = (UIButton *)[self viewWithTag:userTab];
        [tempButton setTitle:@"UnTag" forState:UIControlStateNormal];
        //[tempButton release];

    
    }

}


-(void)dealloc
{

    if (aTableView) 
    {
        [aTableView release];
    }


}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
