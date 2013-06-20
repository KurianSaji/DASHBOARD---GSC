//
//  MusicListController.m
//  MySongsPlayer
//
//  Created by zaah technologies india pvt on 11/13/10.
//  Copyright 2010 zaah. All rights reserved.
//

#import "MusicListController.h"
#import "epubstore_svcAppDelegate.h"

@implementation MusicListController
@synthesize songsTable,_delegate,currentSongURL,previousSongURL;

NSMutableArray *previousPlayList;
//int selectedIpodIndex;
//int previouslySelectedIndex;


NSUserDefaults *prefs;
//NSString *selectedSongName;
//NSString *itemName;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	appDelegate = (epubstore_svcAppDelegate *)[[UIApplication sharedApplication] delegate];
	songsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 768,924) style:UITableViewStylePlain];
	[songsTable setDelegate:self];
	[songsTable setDataSource:self];
	[self.view addSubview:songsTable];
	
	prefs = [NSUserDefaults standardUserDefaults];
	NSString *mySongName = [prefs stringForKey:@"ipodSongTitle"];
	NSLog(@"songz name... %@",mySongName);
	//currentSongTitle = appDelegate.ipodSongTitle;
//	if([mySongName isEqualToString:@"NULL"])
//		currentSongTitle = appDelegate.ipodSongTitle;
//	else
//		currentSongTitle = mySongName;
	
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)]autorelease];
	
    if ([prefs objectForKey:@"currentSong"]) {
        self.previousSongURL=[prefs objectForKey:@"currentSong"];
        self.currentSongURL=[prefs objectForKey:@"currentSong"];
    }
    
	//previouslySelectedIndex =appDelegate.songIndex;
	//[playingItem retain];
	
	
//	for (int k=0;k<[appDelegate.allSongs count]; k++) {
//		MPMediaItem *playItem = [allSongs objectAtIndex:k];
//		NSString *itemName = [playItem valueForProperty:MPMediaItemPropertyTitle];
//		if ([itemName isEqualToString:currentSongTitle]) {
//			MPMediaItemCollection *userMediaItemCollection = [MPMediaItemCollection collectionWithItems:[query items]];
//			[musicPlayer setQueueWithItemCollection:userMediaItemCollection];
//			musicPlayer.nowPlayingItem = playItem;
//			musicPlayer.repeatMode = MPMusicRepeatModeOne;
//			musicPlayer.volume = appDelegate.volumeLevel;
//			[musicPlayer play];
//			
//			selectedIpodIndex =k;
//			k=[allSongs count];
//			
//		}
//	}
	
	
}

-(void)setDelegate:(id<MusicListDelegate>) MLDelegate{
	self._delegate = MLDelegate;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(IBAction)saveAction{
	
	[appDelegate.audioPlayer stop];
	[appDelegate.musicPlayer stop];
	//appDelegate.newSection = 0;
	//appDelegate.newSection = 0;
    [prefs setObject:@"ipodSongs" forKey:@"alaramSong"];
	[prefs setObject:self.currentSongURL forKey:@"currentSong"];
    [prefs synchronize];
//	NSString *IndexString = [NSString stringWithFormat:@"%d$$$%d###%f",appDelegate.newSection,appDelegate.songIndex,appDelegate.volumeLevel];
//	[prefs setObject:IndexString forKey:@"AlarmIndex"];
//	
//	if(appDelegate.songIndex < 0)
//	{
//		UIAlertView *alert = [[UIAlertView alloc] 
//							  initWithTitle:@"Empty Song List" 
//							  message:@"" 
//							  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		alert.delegate=self;
//		[alert show];
//		[alert release];
//	}
//	else 
//	{
//		MPMediaItem *anItem = (MPMediaItem *)[appDelegate.allSongs objectAtIndex:appDelegate.songIndex];
//		itemName = [anItem valueForProperty:MPMediaItemPropertyTitle];
//		if ([anItem isKindOfClass:[MPMediaItem class]] && ![itemName isEqualToString:@"fromValue"])
//			[prefs setObject:itemName forKey:@"ipodSongTitle"];	
//		//NSLog(@"pref song name -->> %@",prefs);
//	}
//	
//	
//	[prefs synchronize];
	
	//if (prefs) 
	//        selectedSongName = [prefs objectForKey:@"AlarmIndex"];
	//	NSLog(@"songz name %@",itemName);
	
	//appDelegate.ipodSongTitle = currentSongTitle;
	//	
	//	[prefs setObject:appDelegate.ipodSongTitle forKey:@"ipodSongTitle"];
	
	//[self dismissModalViewControllerAnimated:YES];
    for (UIView *vi=self.view.superview; vi; vi=vi.superview) {
		UIResponder *nextResponder=[vi nextResponder];
		if ([nextResponder isKindOfClass:[AlarmsViewController class]]) {
			[self.view removeFromSuperview];
			[(AlarmsViewController *)nextResponder viewWillAppear:NO];
			return;
            
		}
	}
}

-(IBAction)cancelAction{
	//appDelegate.songIndex = previouslySelectedIndex;
	
	//appDelegate.newSection = 1;
    if (![self.currentSongURL isEqualToString:self.previousSongURL]) {
        [prefs setObject:self.currentSongURL forKey:@"currentSong"];
    }
	[appDelegate.audioPlayer stop];
	[appDelegate.musicPlayer stop];
//	prefs = [NSUserDefaults standardUserDefaults];
//	NSString *IndexString = [NSString stringWithFormat:@"%d$$$%d###%f",appDelegate.newSection,appDelegate.songIndex,appDelegate.volumeLevel];
//	[prefs setObject:IndexString forKey:@"AlarmIndex"];
//	NSLog(@"cancel song %@ ",appDelegate.ipodSongTitle);
	
	//[prefs setObject:appDelegate.ipodSongTitle forKey:@"ipodSongTitle"];
	
	//[self dismissModalViewControllerAnimated:YES];
    for (UIView *vi=self.view.superview; vi; vi=vi.superview) {
		UIResponder *nextResponder=[vi nextResponder];
		if ([nextResponder isKindOfClass:[AlarmsViewController class]]) {
			[self.view removeFromSuperview];
			[(AlarmsViewController *)nextResponder viewWillAppear:NO];
			return;
            
		}
	}
	
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [appDelegate.allSongs count];
}
- (void)viewWillAppear:(BOOL)animated  {
	
	
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = NO;
	thisApp.idleTimerDisabled = YES;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	}
	
	MPMediaItem *anItem = (MPMediaItem *)[appDelegate.allSongs objectAtIndex:indexPath.row];
	NSString *cellText;
	NSString *itemName = [anItem valueForProperty:MPMediaItemPropertyTitle];
    NSLog(@"current %@ %@",self.currentSongURL,[[anItem valueForProperty:MPMediaItemPropertyAssetURL] absoluteString]);
    if ([self.currentSongURL isEqualToString:[[anItem valueForProperty:MPMediaItemPropertyAssetURL] absoluteString]] ) {
        
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	if ([anItem isKindOfClass:[MPMediaItem class]] && ![itemName isEqualToString:@"fromValue"]) {
        if ([anItem valueForProperty:MPMediaItemPropertyArtist]) {
            cellText = [NSString stringWithFormat:@"%@-%@",[anItem valueForProperty:MPMediaItemPropertyArtist],itemName];
        }
        else{
            cellText = [NSString stringWithFormat:@"UNKNOWN-%@",itemName];
        }
		
		
		
		
		//NSLog(@"%@ %@",[anItem description],itemName);
		
		
	}else{
		cellText = @"novalue";
	}
	
	cell.textLabel.text = cellText;
  
	
	
	
	
	
	return cell;
	
}


-(IBAction)backAction{
	[self dismissModalViewControllerAnimated:YES];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}



/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	///NSString *index = [NSString stringWithFormat:@"%d",indexPath.row];
	
	//appDelegate.songIndex = indexPath.row;
    
	MPMediaQuery *query = [[[MPMediaQuery alloc] init] autorelease];
	appDelegate.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
	MPMediaItem *playItem = [appDelegate.allSongs objectAtIndex:indexPath.row];
	MPMediaItemCollection *userMediaItemCollection = [MPMediaItemCollection collectionWithItems:[query items]];
	[appDelegate.musicPlayer setQueueWithItemCollection:userMediaItemCollection];
	appDelegate.musicPlayer.nowPlayingItem = playItem;
	appDelegate.musicPlayer.repeatMode = MPMusicRepeatModeOne;
	//appDelegate.musicPlayer.volume = appDelegate.volumeLevel;
	[appDelegate.musicPlayer play];
    self.currentSongURL=[[playItem valueForProperty:MPMediaItemPropertyAssetURL] absoluteString] ;
    if (!self.previousSongURL) {
        NSLog(@"check");
        saveButton.enabled=YES;
        [songsTable reloadData];
        return;
    }
    if (![self.currentSongURL isEqualToString:self.previousSongURL]) {
        saveButton.enabled=YES;
    }
    
	[songsTable reloadData];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */



//Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	// return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	
	//	UIAlertView *alert = [[UIAlertView alloc] 
	//						  initWithTitle:@"Warning" 
	//						  message:@"You are running out of memory" 
	//						  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//	[alert show];
	//	[alert release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	//[allSongs release];
    [super dealloc];
}


@end
