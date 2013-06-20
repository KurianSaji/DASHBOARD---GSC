//
//  facebookdetailtable.m
//  maximSocialVideo
//
//  Created by neo on 10/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "facebookdetailtable.h"

@implementation facebookdetailtable

@synthesize _delegate;

epubstore_svcAppDelegate *appDelegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    
    
    
    int curSW = [[UIScreen mainScreen] bounds].size.width;
    int curSH = [[UIScreen mainScreen] bounds].size.height;
    //self.view.backgroundColor  = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1];
    
     self.view.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
       //_dataList_search =[[dataList_search alloc]initWithFrame:CGRectMake(0,35, 320,480)];
        
        
    }
    else
    {
        //_dataList_search =[[dataList_search alloc]initWithFrame:CGRectMake(0,50, 768 ,1024)];
        
    }

    _dataList_search =[[dataList_search alloc]initWithFrame:CGRectMake(0,(0.0/480)*curSH , (320.0/320)*curSW,(480.0/480)*curSH)];
    
    
    //[_dataList_search setDelegate:self];
    
    [self.view addSubview:_dataList_search];
    
    
    
    
    
    
    
    
    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake((10.0/320)*curSW, 35, (20.0/320)*curSW , (20.0/480)*curSH )];
    
    
    
    
 
    
    
    
    [button1 addTarget:self action:@selector(backtoHome) forControlEvents:UIControlEventTouchUpInside]; 
    
    //[button1 setImage:[UIImage imageNamed:@"videoDetailsback.png"] forState:UIControlStateNormal];
    
    [button1 setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:button1];
    //[button1 release];
    
    
    
    
    
    UIButton *btnTag=[UIButton buttonWithType:UIButtonTypeCustom];
    btnTag.frame = CGRectMake((258.0/320)*curSW, 25, (80.0/320)*curSW , (33.0/480)*curSH );
    [btnTag addTarget:self action:@selector(postMedia) forControlEvents:UIControlEventTouchUpInside]; 
    
    
    
    [btnTag setTitle:@"Post" forState:UIControlStateNormal];
    (btnTag).titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:20];
    [btnTag setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    
    [self.view addSubview:btnTag];
      
    
    _avloader  = [[avloader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height+20)]; 
    _avloader.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    [self.view addSubview:_avloader];
    [self.view bringSubviewToFront:_avloader];
    [_avloader initLoaderWithSize:CGSizeMake(100, 100)];
    
    _avloader.hidden = YES;
}

-(void)startAnimatingAV
{

    _avloader.hidden = NO;

}

-(void)postMedia
{

    [self performSelectorInBackground:@selector(startAnimatingAV) withObject:nil];

    NSString *postTagedIds1, *postTagedIds2;
    
    if ([appDelegate.videoTaggedIds count]>0) {
        postTagedIds1 = [NSString stringWithFormat:@"%@",[appDelegate.videoTaggedIds description]];
        //postTagedIds2 = [NSString stringWithFormat:@"%@",appDelegate.videoTaggedIds];

    }
    else
    {
        postTagedIds1 = postTagedIds2 = @"";
    }
    
       
    NSString *urlString =[NSString stringWithFormat:@"%@media/list?user_id=%@&method=media.video-add&title=%@&desc=%@&location=chennai&tagids=%@&orentation=%d",ServerIp, appDelegate.userID,appDelegate.postTitle, appDelegate.postDescription ,postTagedIds1,appDelegate.captureOrientation];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
    [request setURL:[NSURL URLWithString:urlString]]; 
    
    NSLog(@"urlString----%@",urlString);
	
    //NSString *myParameters = [NSString stringWithFormat:@"user_id=%@&method=media.video-add&title=maxim&desc=testing-video&location=chennai&tagids=%@",appDelegate.userID,postTagedIds1];
    
    //NSLog(@"%@",myParameters);
    
    NSLog(@"postvideourl-->%@",appDelegate.postVideoUrl);

    NSData *mediaData = [[NSData alloc] initWithContentsOfURL:appDelegate.postVideoUrl];
    
    
    NSString *mediaFileName =  [appDelegate.postVideoUrl lastPathComponent];
    
    
    [request setHTTPMethod:@"POST"];
    
    //[request setHTTPBody:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
     
    /*
     add some header info now
     we always need a boundary when we post a file
     also we need to set the content type
     ‰
     You might want to generate a random boundary.. this is just the same
     as my output from wireshark on a valid html post
     */
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
   [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
     
    
   NSMutableData *body = [NSMutableData data];
     
     
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=%@\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media_data\"; filename=\"%@\"\r\n", mediaFileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:mediaData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         // setting the body of the post to the reqeust
    
    //[body appendData:[myParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"%@",returnString);
    
    /**/
    
    
    _avloader.hidden = YES;
    [_avloader release];
    [_avloader removeFromSuperview];
    
    /**/
    if (returnString) 
    {
        
        
        NSString  *success    = [self GetValueInXML:returnString SearchStr:@"success"];
        
        NSString  *message    = [self GetValueInXML:returnString SearchStr:@"message"]; 

        
        if ([success isEqualToString:@"1"]) 
        {
        
            [[[[UIAlertView alloc] initWithTitle:@"Result" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];
            
            
            appDelegate.redirectToRoot  =TRUE;
            
            [self dismissModalViewControllerAnimated:YES]; 
            
        }
        else
        {
            [[[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease] show];

        }

        
    }   


}


-(void)backToParentView
{
    [self.presentedViewController dismissModalViewControllerAnimated:YES];
}


-(void)backtoHome
{

    [self dismissModalViewControllerAnimated:YES];

}


-(NSString *) GetValueInXML:(NSString *)xmlString SearchStr:(NSString *)SearchStr
{
    NSString *str2;
    NSArray *arr=[xmlString componentsSeparatedByString:[NSString stringWithFormat:@"<%@>",SearchStr]];
    if ([arr count]>0)
    {
        NSString *str1=[arr objectAtIndex:1];
        NSArray *arr1=[str1 componentsSeparatedByString:[NSString stringWithFormat:@"</%@>",SearchStr]];
        if ([arr1 count]>0)
        {
            str2=[arr1 objectAtIndex:0];
            
        }
    }	
    return str2;
}
 
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
