//
//  contributeViewController.h
//  maximSocialVideo
//
//  Created by Palani on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "epubstore_svcAppDelegate.h"
#import "photoButton.h"
#import "avloader.h"

#import <MobileCoreServices/UTCoreTypes.h>

@interface contributeViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    
    
    IBOutlet UIButton *btnProfile;
    IBOutlet UILabel *lblName;
    
    IBOutlet UITextField *titleTextField;
    IBOutlet UITextView *contentTextView;
    
    NSString *pageUserId;
    
    NSString *userName;
    
    IBOutlet UILabel *lblContribute;
    
    IBOutlet UILabel *lblTagOthers;
    
    UITableView *aTableView;
    
    NSDictionary *friendsList;
    
    UILabel *nameLabel;
    
    UIButton *btnCancel, *btnStartRecord, *btnLibrary, *btnFlipCam, *btnStopRecord;
    
    UIImagePickerController *imagePickerController;
    
    avloader *_avloader;

    NSString *strType;
    
    UIImage * outputImage;
    
    
    IBOutlet UIImageView *imgView1;
    
    IBOutlet UIImageView *imgView2;
    
    IBOutlet UIImageView *imgView3;
    
    IBOutlet UIImageView *imgView4;
    
    int photo_count;
    
    IBOutlet UIButton *btn1;
    
    IBOutlet UIButton *btn2;
    
    IBOutlet UIButton *btn3;
    
    IBOutlet UIButton *btn4;
    
    NSMutableDictionary *imageDict;
    
    NSString *orientationStr;
    
    IBOutlet UIButton *btnUpload;
    
    //BOOL mediaPosted;
    
    NSMutableArray *tagArray;
}

@property (nonatomic,retain) NSMutableDictionary *imageDict;

@property (nonatomic,retain) NSString *orientationStr;

@property (nonatomic,retain) NSString *strType;

@property(nonatomic,retain)NSDictionary *friendsList;

@property (nonatomic,retain) NSString *pageUserId;
@property (nonatomic,retain) NSString *userName;

-(IBAction)btnBack:(id)sender;
- (void)animateView:(NSUInteger)tag;
-(void)fetchFriendsList;

-(IBAction)btnUpload;
-(void)presentVideoMode;
-(void)presentPhotoMode;

-(IBAction)btnSubmit;

-(IBAction)btnDelete:(id)sender;
-(void)presentPhotoLibrary;

@end
