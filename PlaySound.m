//
//  PlaySound.m
//  Alarm
//
//  Created by usha on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlaySound.h"
#import "MusicListController.h"
#import "epubstore_svcAppDelegate.h"
#import "AlarmsViewController.h"

int previouslySelectedindex;
int previousSongSection;
int ipadScreenWidth2=768;
int ipadScreenHeight2=1024;
@implementation PlaySound

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	ratioWidth=ipadScreenWidth2/[UIScreen mainScreen].bounds.size.width;
	ratioHeight=ipadScreenHeight2/[UIScreen mainScreen].bounds.size.height;

	appDelegate = (epubstore_svcAppDelegate*)[[UIApplication sharedApplication]delegate];
	if (appDelegate.screenHeight1!=1024) {
		self.view.frame=CGRectMake(self.view.frame.origin.x/ratioWidth, self.view.frame.origin.y/ratioHeight, self.view.frame.size.width/ratioWidth, self.view.frame.size.height/ratioHeight);
		[playListTableView setFrame:CGRectMake(playListTableView.frame.origin.x/ratioWidth, (playListTableView.frame.origin.y/ratioHeight)+15, 768/ratioWidth, 980/ratioHeight)];
	}
	//appDelegate.playList = [[NSMutableArray alloc]init];
	//[appDelegate.playList addObject:@"Zombie_Horde_by_Wolfsinger"];
//	[appDelegate.playList addObject:@"Zombie_News_01_by_parabolix"];
//	[appDelegate.playList addObject:@"Zombie_News_02_by_Corsica_S"];
	//[appDelegate.playList addObject:@"LikeARainbow"];
	//[appDelegate.playList addObject:@"SeaOfLove"];
	//[appDelegate.playList addObject:@"MenuSong"];
    [super viewDidLoad];
}



-(IBAction)saveAction{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *IndexString = [NSString stringWithFormat:@"%d$$$%d###%f",appDelegate.newSection,appDelegate.songIndex,appDelegate.volumeLevel];
	[prefs setObject:IndexString forKey:@"AlarmIndex"];
	
	[appDelegate.audioPlayer stop];
	[appDelegate.musicPlayer stop];
	
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

-(IBAction)BackAction{
	appDelegate.songIndex =previouslySelectedindex;
	appDelegate.newSection = previousSongSection;
	[appDelegate.audioPlayer stop];
	[appDelegate.musicPlayer stop];
	
	for (UIView *vi=self.view.superview; vi; vi=vi.superview) {
		UIResponder *nextResponder=[vi nextResponder];
		if ([nextResponder isKindOfClass:[AlarmsViewController class]]) {
			[self.view removeFromSuperview];
			[(AlarmsViewController *)nextResponder viewWillAppear:NO];
			return;
		
		}
	}
	
	//[self dismissModalViewControllerAnimated:YES];
	
	
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
			break;
		case 1:
			return 1;//[appDelegate.playList count];
			break;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = [NSString stringWithFormat:@"Ipod Songs",indexPath.row];
			
			if (appDelegate.newSection ==0) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}

			break;
			
		case 1:
			
			 
			//cell.textLabel.text = [appDelegate.playList objectAtIndex:indexPath.row];
			if (appDelegate.newSection ==1 && appDelegate.songIndex ==indexPath.row ) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}

			
			break;
	}
	
	//if(indexPath.section == 1)
//	{
//		if (appDelegate.songIndex == indexPath.row ) {
//			cell.accessoryType = UITableViewCellAccessoryCheckmark;
//		}else {
//			cell.accessoryType = UITableViewCellAccessoryNone;
//		}
//		
//	}
	
	
//	else {
//		
//	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
		
	if(indexPath.section == 0){
		//appDelegate.newSection = 0;
		
		MusicListController *music = [[MusicListController alloc]initWithNibName:@"MusicListController" bundle:nil];
		[self presentModalViewController:music animated:YES];
		//[music release];
	}else{
		
		
			appDelegate.newSection = 1;
			//NSString *index = [NSString stringWithFormat:@"%d",indexPath.row];
			
			appDelegate.songIndex = indexPath.row;
		
		[appDelegate playAlarm];
			/*NSString *urlstring = [[NSBundle mainBundle] pathForResource:[appDelegate.playList objectAtIndex:appDelegate.songIndex ] ofType:@"mp3"];
			NSURL *url = [NSURL fileURLWithPath:urlstring];
			NSError *error;
		if(appDelegate.audioPlayer!=nil)
			
		{
			
			[appDelegate.audioPlayer release];
			appDelegate.audioPlayer = nil;
			
		}
		appDelegate.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
				//[appDelegate.audioPlayer set]
			if (appDelegate.audioPlayer == nil)
				NSLog([error description]);
			else
			{
				appDelegate.audioPlayer.volume = appDelegate.volumeLevel;
				[appDelegate.audioPlayer play];
			}
			 */
				
		//[tableView reloadData];
				
		
	}
	
	[tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}



//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//	
//	//return UITableViewCellAccessoryDetailDisclosureButton;
//	return UITableViewCellAccessoryDisclosureIndicator;
//}
//
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
//	
//	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
//}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated; 
{
	
		UIApplication *thisApp = [UIApplication sharedApplication];
		thisApp.idleTimerDisabled = NO;
		thisApp.idleTimerDisabled = YES;
	previousSongSection = appDelegate.newSection;
	previouslySelectedindex = appDelegate.songIndex;
	[playListTableView reloadData];
}

@end
