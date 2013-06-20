//
//  comments.m
//  maximSocialVideo
//
//  Created by neo on 20/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "comments.h"

@implementation comments
@synthesize commentArray, commentCount;
@synthesize aTableView;
@synthesize _delegate;
@synthesize searchPath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}


-(void)initcommentsView
{

    
    
    if (aTableView) {
        [aTableView release];
        aTableView = nil;
        [aTableView removeFromSuperview];
    }
    
    
    self.searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    aTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,0, 
                                                             self.frame.size.width ,self.frame.size.height)];
    //[aTableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
    [aTableView setBackgroundColor:[UIColor clearColor]];
    [aTableView setShowsVerticalScrollIndicator:NO];
    self.backgroundColor = [UIColor blackColor];
    
    [aTableView setDelegate:self];
    [aTableView setDataSource:self];
    
    aTableView.separatorColor=[UIColor whiteColor];
    aTableView.backgroundColor  = [UIColor clearColor];
    
    //aTableView.layer.borderColor = [UIColor redColor].CGColor;
    //aTableView.layer.borderWidth = 1;
    
    [self addSubview:aTableView];
    
    
    
    
    

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.commentCount;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [indexPath row] * 20;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        return 30;
        
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    /*-------Adding Image to Cell--------Start---- */ 
    photoButton *button;
    
    
    button=[[photoButton alloc]initWithFrame:CGRectMake(0, 2, 24, 25)];
    
    
    NSString *videoUserId;
    if (self.commentCount == 1) 
    {
        NSDictionary *tempDict = (NSDictionary*)commentArray;
        
        videoUserId=[[tempDict objectForKey:@"cmt_userid"] objectForKey:@"text"];
        
    }
    else
    {   
        
        videoUserId =  [[[commentArray objectAtIndex:indexPath.row] objectForKey:@"cmt_userid"] valueForKey:@"text"];
    }  
    
    
    button.videoUserId = videoUserId;
    
    
    
    [button addTarget:self action:@selector(gotoUser:) forControlEvents:UIControlEventTouchUpInside];
    
    //button.layer.borderColor = [UIColor greenColor].CGColor;
    //button.layer.borderWidth = 1;
    //button.userInteractionEnabled=NO;
    
    //[[[commentArray objectAtIndex:indexPath.row] objectForKey:@"cmt_img"] objectForKey:@"text"];
    
    NSString *userImgPath;
    if (self.commentCount>1) 
    {
        userImgPath = [[[commentArray objectAtIndex:indexPath.row] objectForKey:@"cmt_img"] objectForKey:@"text"];
    }
    else
    {
        NSDictionary *tempDict = (NSDictionary*)commentArray;
        userImgPath = [[tempDict objectForKey:@"cmt_img"] objectForKey:@"text"];
    }
    
    
    /*URL CACHE  CHECK*/
    
    NSString* lastComponent = [NSString stringWithFormat:@"%@.jpg",videoUserId];
    NSString *path = [[self.searchPath objectAtIndex:0]  stringByAppendingString:[NSString stringWithFormat:@"/thumbData/%@",lastComponent]];
    
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) 
    {
        path = [NSString stringWithFormat:@"file://localhost/private%@",path];
        NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        [(photoButton*)button setBackgroundImage:[UIImage imageWithData:dataImage] forState:UIControlStateNormal];
    }else
    {
        [(photoButton*)button loadImage:userImgPath isLast:TRUE]; 
    }
    
    
    
    
    
    
    //[button addTarget:self action:@selector(goToUserVideos) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:button]; 
    //[button release];
    /*-------Adding Image to Cell--------END----*/
    
    
    /*-------Adding Title to Cell--------Start---- */ 
    int lblFontSize;
    UILabel *nameLabel1;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        nameLabel1=[[UILabel alloc]initWithFrame:CGRectMake(35,0,120,30)];
        lblFontSize = 18;
    }
    else
    {    
        nameLabel1=[[UILabel alloc]initWithFrame:CGRectMake(80,0,200,75)];
        lblFontSize = 25;
    }
	//nameLabel1.font = [UIFont boldSystemFontOfSize:lblFontSize];
   // nameLabel1.textColor=[UIColor redColor];
    
    nameLabel1.font = [UIFont fontWithName:@"BigNoodleTitling" size:lblFontSize];
	nameLabel1.backgroundColor=[UIColor clearColor];
    
   
    if (self.commentCount>1) {

        
        nameLabel1.text=[[[commentArray objectAtIndex:indexPath.row] objectForKey:@"cmt_uname"] objectForKey:@"text"];

    }
    else
    {
    
        NSDictionary *tempDict = (NSDictionary*)commentArray;
        
        nameLabel1.text=[[tempDict objectForKey:@"cmt_uname"] objectForKey:@"text"];

    
    
    }
    
	[cell addSubview:nameLabel1];
    
/*    photoButton *nameButton1;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        nameButton1=[[photoButton alloc]initWithFrame:CGRectMake(35,0,68,30)];
        lblFontSize = 10;
    }
    else
    {    
        nameButton1=[[photoButton alloc]initWithFrame:CGRectMake(80,0,200,75)];
        lblFontSize = 25;
    }
	
    nameButton1.font = [UIFont boldSystemFontOfSize:lblFontSize];
   
 	
    [nameButton1 setTitleColor:[UIColor colorWithRed:255.0/255.0 green:111.0/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    
    nameButton1.backgroundColor=[UIColor clearColor];
    
    
    if (self.commentCount>1) {
        
        
        
        [nameButton1 setTitle:[[[commentArray objectAtIndex:indexPath.row] objectForKey:@"cmt_uname"] objectForKey:@"text"] forState:UIControlStateNormal];
        
         
    }
    else
    {
        
        NSDictionary *tempDict = (NSDictionary*)commentArray;
        [nameButton1 setTitle:[[tempDict objectForKey:@"cmt_uname"] objectForKey:@"text"] forState:UIControlStateNormal];
        
        
        
    }
    
    [nameButton1 addTarget:self action:@selector(goToUserVideos) forControlEvents:UIControlEventTouchUpInside];
    
    nameButton1.layer.borderColor = [UIColor greenColor].CGColor;
    
    nameButton1.layer.borderWidth = 1.0;
    
	[cell addSubview:nameButton1];
    
    
	
    
    
    [nameButton1 release];
*/ 
    /*-------Adding Title to Cell--------END---- */
    
    
    
    
    
    /*-------Adding Description to Cell--------Start---- */ 
    int lbl2X =(nameLabel1.frame.origin.x+nameLabel1.frame.size.width+3);
    
    UILabel *nameLabel2;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        nameLabel2=[[UILabel alloc]initWithFrame:CGRectMake(lbl2X,0,193,30)];
        lblFontSize = 13;
    }
    else
    {    
        nameLabel2=[[UILabel alloc]initWithFrame:CGRectMake(lbl2X,0,420,75)];
        lblFontSize = 25;
    }
	//nameLabel2.font = [UIFont boldSystemFontOfSize:lblFontSize];
    nameLabel2.font = [UIFont fontWithName:@"Helvetica" size:lblFontSize];
    nameLabel2.textColor=[UIColor whiteColor];
	nameLabel2.backgroundColor=[UIColor clearColor];
    
    if (self.commentCount>1) {
        
        
         nameLabel2.text=[[[commentArray objectAtIndex:indexPath.row] objectForKey:@"cmt_desc"] objectForKey:@"text"];

    }
    else
    {
        
        NSDictionary *tempDict = (NSDictionary*)commentArray;
        
        nameLabel2.text=[[tempDict objectForKey:@"cmt_desc"] objectForKey:@"text"];
        
        
        
    }

    if (indexPath.row%2==0) 
    {
        nameLabel1.textColor=[UIColor redColor];

        [cell.contentView setBackgroundColor:[UIColor blackColor]];

    }
    else
    {
        
        nameLabel1.textColor=[UIColor yellowColor];

        [cell.contentView setBackgroundColor:[UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]];

    }
    
    
    tableView.separatorColor = [UIColor clearColor];
    
    [cell addSubview:nameLabel2];
	
    //nameLabel2.layer.borderColor = [UIColor greenColor].CGColor;
    
   // nameLabel2.layer.borderWidth = 1.0;
    
    [nameLabel2 release];
    /*-------Adding Title to Cell--------END---- */

    
    
    
    return cell;
    
}   
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *videoUserId;
    if (self.commentCount == 1) 
    {
        NSDictionary *tempDict = (NSDictionary*)commentArray;
        
        videoUserId=[[tempDict objectForKey:@"cmt_userid"] objectForKey:@"text"];
        
    }
    else
    {   

        videoUserId =  [[[commentArray objectAtIndex:indexPath.row] objectForKey:@"cmt_userid"] valueForKey:@"text"];
    }  
    
    [_delegate goToUserVideos:videoUserId];     

}

-(void)gotoUser:(photoButton*)sender
{

     [_delegate goToUserVideos:[sender videoUserId]];     

}


-(void)reloadTableView
{

    [aTableView reloadData];

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
