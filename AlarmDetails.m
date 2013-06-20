//
//  AlarmDetails.m
//  Alarm
//
//  Created by usha on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmDetails.h"
#import "epubstore_svcAppDelegate.h"
#import "MusicListController.h"
#import "RepeatAlarm.h"
#import "PlaySound.h"
#import "AlarmSettings.h"
#import "AlarmsViewController.h"

int alarmHour;
int alarmMinute;
BOOL isAlarm;
NSString *repeatStr;//alertBody = @"0";

NSTimeInterval timeDiff;
//NSMutableArray *totalAlarmArray;

@implementation AlarmDetails


@synthesize timePicker,myDateString,slider,EditIndex,localArrayIndex;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewWillAppear:(BOOL)animated  {
	
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = NO;
	thisApp.idleTimerDisabled = YES;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	 
	[self.view setBackgroundColor:[UIColor blackColor]];
	appdelegate = (epubstore_svcAppDelegate*)[[UIApplication sharedApplication]delegate];
	if(appdelegate.screenHeight1 == 1024)
	{
		[[NSBundle mainBundle] loadNibNamed:@"AlarmDetails" owner:self options:nil];
		
	}
	else								 
		[[NSBundle mainBundle] loadNibNamed:@"AlarmDetailsiphone" owner:self options:nil];
	
	timePicker.datePickerMode = UIDatePickerModeTime;
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)]autorelease];
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
	
	//[formatter setDateFormat:@"EEEE yyyy/MM/dd hh:mm a"];
	[formatter setDateFormat:@"hh:mm a"];
	
	NSDate *myDate = [NSDate date];
	
	
	NSRange end = [myDateString rangeOfString: @"$$$"];
	NSRange end1 = [myDateString rangeOfString: @"###"];
	int lenght =  [myDateString length];
	
	if (end.location !=NSNotFound) {
		lenght = lenght -(end1.location+end1.length);
		
		NSString *dateString = [myDateString substringWithRange: NSMakeRange (0,end.location)];
		
		
		myDate = [formatter dateFromString:dateString];
	}
	else {
		
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDate *scheduled = [NSDate date] ;
		unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
		NSDateComponents *schu = [calendar components:unitFlags fromDate:scheduled];
		int day = [schu day];
		int month = [schu month];
		int year = [schu year];
		NSString *dateString = [NSString stringWithFormat:@"%d/%d/%d %@",year,month,day,myDateString];
		NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
		
		//[formatter setDateFormat:@"EEEE yyyy/MM/dd hh:mm a"];
		[formatter setDateFormat:@"yyyy/MM/dd hh:mm a"];
		myDate = [formatter dateFromString:dateString];
		timePicker.date = myDate;
		
	}
	timePicker.timeZone = [NSTimeZone localTimeZone];
	
	if (EditIndex==-1 &&localArrayIndex ==-1) {
		
		NSDate *date	= [NSDate date];
		
		[timePicker setDate:date animated:YES];
		
	}
	else if(EditIndex ==-1 &&localArrayIndex!=-1)
	{
		AlarmSettings *alarmSetting = (AlarmSettings *)[appdelegate.alarmTimeArray objectAtIndex:localArrayIndex];
		[timePicker setDate: alarmSetting.alarmFireDate animated:YES];
		timePicker.timeZone = [NSTimeZone localTimeZone];
	}
	else {
		[timePicker setDate: myDate animated:YES];
		timePicker.timeZone = [NSTimeZone localTimeZone];
	}

	
	
	alarmItems = [[NSMutableArray alloc]init];
	
	[alarmItems addObject:@"Enable alarm"];
	[alarmItems addObject:@"Repeat Daily"];
	
	
	//[alarmItems addObject:@"Music/Sound"];
	//[alarmItems addObject:@"Volume"];
	
	
}
-(IBAction)BackAction
{
	
	[self dismissModalViewControllerAnimated:YES];
	[alarm viewLoadMethod];
	
}

-(IBAction)saveAlarmActiom{
	
	if(isAlarm == NO)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ALARM" message:@"Enable Alarm Should Be On"delegate:self cancelButtonTitle:@"ok"otherButtonTitles: nil];
		[alert show];
		[alert release];
		return ;
	}
	
	alarm.onoff=TRUE;
	
	if(appdelegate.musicPlayer){
		
		[appdelegate.musicPlayer stop];
	}
	
	
	if(appdelegate.audioPlayer){
		
		[appdelegate.audioPlayer stop];
	}
	
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"hh:mm a"];
	
	
	appdelegate.totalTime=[NSString stringWithFormat:@"%@",[timeFormat stringFromDate:timePicker.date]];
	

	if (EditIndex!=-1) {
		//[totalAlarmArray removeObjectAtIndex:EditIndex];
		NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
		
		NSMutableArray *myArray = [notificationArray mutableCopy];
		UILocalNotification *localNotif = [myArray objectAtIndex:EditIndex];
		[[UIApplication sharedApplication] cancelLocalNotification:localNotif];
		[appdelegate.alarmTimeArray removeObjectAtIndex:localArrayIndex];
				
	}
	else if(EditIndex ==-1 &&localArrayIndex !=-1) {
		[appdelegate.alarmTimeArray removeObjectAtIndex:localArrayIndex];
	}


	
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	
	// Get the current date
	NSDate *pickerDate = [timePicker date];
	NSDate *now = [NSDate date];
	NSTimeInterval difference = [pickerDate timeIntervalSinceDate:now];
	if (difference<=0) {
		NSString * editedTime = [timeFormat stringFromDate:timePicker.date];
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDate *scheduled = [NSDate date] ;
		unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
		NSDateComponents *schu = [calendar components:unitFlags fromDate:scheduled];
		int day = [schu day];
		int month = [schu month];
		int year = [schu year];
		NSString *dateString = [NSString stringWithFormat:@"%d/%d/%d %@",year,month,day,editedTime];
		NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
		
		//[formatter setDateFormat:@"EEEE yyyy/MM/dd hh:mm a"];
		[formatter setDateFormat:@"yyyy/MM/dd hh:mm a"];
		pickerDate = [formatter dateFromString:dateString];
	}
	
	// Break the date up into components
	NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) 
												   fromDate:pickerDate];
	NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) 
												   fromDate:pickerDate];
	
	// Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
	// Notification will fire in one minute
    [dateComps setMinute:[timeComponents minute]];
	
	//[dateComps setSecond:[timeComponents second]];
    NSDate *itemDate = pickerDate ;//[calendar dateFromComponents:dateComps];
	NSTimeInterval secondsPerDay = 24 * 60 * 60;
	
	NSDate *TomorrowDate = [itemDate addTimeInterval:secondsPerDay];
    [dateComps release];
	
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
	//NSMutableArray *notificationArray =(NSMutableArray *) [[UIApplication sharedApplication] scheduledLocalNotifications];
	
	
	
    
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
	
	// Notification details

    localNotif.alertBody = @"Snooze for 2 minutes ";
	// Set the action button
    localNotif.alertAction = @"Snooze";

    //localNotif.soundName = UILocalNotificationDefaultSoundName;
	    localNotif.soundName = @"apple_alarm.mp3";
	
    localNotif.applicationIconBadgeNumber = 0;
	NSDate *myDate =itemDate;
	//localNotif.repeatInterval =0;
	if ([repeatSwitch isOn]==TRUE) {
		localNotif.repeatInterval = NSDayCalendarUnit;	
		repeatStr = @"Y";
		
	}
	else {
		repeatStr = @"N";
		NSDate *now = [NSDate date];
		NSTimeInterval difference = [itemDate timeIntervalSinceDate:now];
		if (difference<=0) {
			//[repeatSwitch setOn:TRUE];
			//localNotif.repeatInterval = NSDayCalendarUnit;
			//repeatStr = @"Y";
			
			myDate = TomorrowDate;
		}
	}
	
	for (int k =0;k<[appdelegate.alarmTimeArray count];k++) {
		AlarmSettings *alarmSettings  = [appdelegate.alarmTimeArray objectAtIndex:k];
		[alarmSettings retain];
		NSDate *savedDate = alarmSettings.alarmFireDate;
		NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
		[timeFormat setDateFormat:@"hh:mm a"];
		
		NSString *savedTime = [timeFormat stringFromDate:savedDate] ;
		NSString *  myTime =	[timeFormat stringFromDate:myDate];
		
		if ([savedTime isEqualToString:myTime]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"you already have an alarm in the same time"
														   delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
			[alert show];
			[alert release];
			return;
		}
	}
	
	
	localNotif.fireDate = myDate;

	// Specify custom data for the notification
	int i =arc4random();
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@$$$%d",repeatStr,i] forKey:@"AlarmID"];
    localNotif.userInfo = infoDict;
	
	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
	
	AlarmSettings *alarmSettings = [[AlarmSettings alloc]init];
	alarmSettings.ID =i;
	alarmSettings.alarmFireDate = myDate;
	alarmSettings.repeat = [repeatSwitch isOn];
	
	[appdelegate.alarmTimeArray addObject:alarmSettings];
	
	
	//NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//	[prefs setObject:appdelegate.alarmTimeArray forKey:@"AlarmTimeArray"];
//	
//	
//	[prefs synchronize];
	
	[appdelegate saveArray:appdelegate.alarmTimeArray];
	[alarmSettings release];
	
	
	[self dismissModalViewControllerAnimated:YES];
	
	
	[alarm viewLoadMethod];
	
}






-(IBAction)pickerTimeAction
{
	
	NSDateFormatter *hTimeFormat = [[NSDateFormatter alloc] init];
	[hTimeFormat setDateFormat:@"HH"];
	NSString *date2 = [hTimeFormat stringFromDate:timePicker.date];
	[hTimeFormat setDateFormat:@"mm"];
	NSString *date1 = [hTimeFormat stringFromDate:timePicker.date];
	
	
	alarmHour = [date2 integerValue];
	alarmMinute = [date1 integerValue];
	
	appdelegate.totalTime = [NSString stringWithFormat:@"%d %d",alarmHour ,alarmMinute];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [alarmItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
	NSString *cellValue = [alarmItems objectAtIndex:indexPath.row];
	cell.textLabel.text = cellValue;
	
	if(indexPath.row == 0){
		almSwitch = [[UISwitch alloc] initWithFrame: CGRectMake(200,5,100, 40)];
		[almSwitch addTarget: self action: @selector(switchAction) forControlEvents:UIControlEventValueChanged];
		[almSwitch setOn:TRUE];
		isAlarm = YES;
		[cell.contentView addSubview: almSwitch];
		
		
	}
	if(indexPath.row == 1){
		repeatSwitch = [[UISwitch alloc] initWithFrame: CGRectMake(200,5,100, 40)];
		[repeatSwitch setOn:FALSE];
		if (EditIndex!=-1 ) {
			NSMutableArray *notificationArray =(NSMutableArray *) [[UIApplication sharedApplication] scheduledLocalNotifications];
			UILocalNotification *localNotif = [notificationArray objectAtIndex:EditIndex];
			
			NSString *str = [localNotif.userInfo objectForKey:@"AlarmID"];
			
			
			NSRange end = [str rangeOfString: @"$$$"];
					
			if (end.location !=NSNotFound) {
				
				
				NSString *newSection = [str substringWithRange: NSMakeRange (0,end.location)];
				if ([newSection isEqualToString:@"Y"]) {
					[repeatSwitch setOn:TRUE];
				}
				else {
					[repeatSwitch setOn:FALSE];
				}

				
			}
		}
		else if (localArrayIndex !=-1) {
			AlarmSettings *alarmSetting = (AlarmSettings *)[appdelegate.alarmTimeArray objectAtIndex:localArrayIndex];
			if(alarmSetting.repeat == TRUE)
			[repeatSwitch setOn:TRUE];	
		}
		
		
		//[repeatSwitch addTarget: self action: @selector(switchAction) forControlEvents:UIControlEventValueChanged];
		[cell.contentView addSubview: repeatSwitch];
		
		
	}
	
	
	
	//if(indexPath.row == 3){
//		slider = [[UISlider alloc] initWithFrame:CGRectMake(185, 3, 100, 40) ];
//		slider.minimumValue = 0.00;
//		slider.maximumValue = 100.00;
//		[slider addTarget:self action:@selector(volumeChanged) forControlEvents:UIControlEventValueChanged];
//		slider.continuous = YES;
//		slider.value = 0.5;
//		[cell.contentView addSubview:slider];
//	}
	
	
	    return cell;
}


-(void)switchAction{
	
	if(almSwitch.on){
		isAlarm = YES;
		
	}
	else {
		isAlarm = NO;
		
	}
	
}




//-(void)volumeChanged{
//	
//	if(appdelegate.musicPlayer)
//	appdelegate.musicPlayer.volume = slider.value;
//	else {
//		appdelegate.audioPlayer.volume = slider.value;
//	}
//
//	
//	
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	
	//if(indexPath.row == 1)
//	{
//		RepeatAlarm *repeatalarm = [[RepeatAlarm alloc]initWithNibName:@"RepeatAlarm" bundle:nil];
//		[self presentModalViewController:repeatalarm animated:YES];
//	}
	//if(indexPath.row == 2)
//	{
//		PlaySound *sound = [[PlaySound alloc]initWithNibName:@"PlaySound" bundle:nil];
//		
//		[self presentModalViewController:sound animated:YES];
//
//		
//	}
	
	
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	//return UITableViewCellAccessoryDetailDisclosureButton;
	//if(indexPath.row==1)
//	return UITableViewCellAccessoryDisclosureIndicator;
//	else {
	return UITableViewCellAccessoryNone;	
	//}

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
	//return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ;
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
