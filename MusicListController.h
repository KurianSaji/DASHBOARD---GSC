//
//  MusicListController.h
//  MySongsPlayer
//
//  Created by zaah technologies india pvt on 11/13/10.
//  Copyright 2010 zaah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AlarmsViewController.h"

@protocol MusicListDelegate ;

@class epubstore_svcAppDelegate;
@interface MusicListController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	
	epubstore_svcAppDelegate *appDelegate;
	UITableView *songsTable;
	id<MusicListDelegate> _delegate;
    
    NSString *previousSongURL;
    IBOutlet UIBarButtonItem *saveButton;
}

@property (nonatomic,retain)NSString *currentSongURL;
@property (nonatomic,retain)NSString *previousSongURL;
@property (nonatomic,retain) UITableView *songsTable;
@property(nonatomic,assign) id<MusicListDelegate> _delegate; 

-(void)setDelegate:(id<MusicListDelegate>) MLDelegate;
-(IBAction)saveAction;
-(IBAction)cancelAction;

@end

@protocol MusicListDelegate<NSObject>


@optional
-(void)didMusicListcontrollerDismiss;
@end