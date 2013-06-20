//
//  SSCameraViewController.m
//  Snapsta
//
//  Created by Kevin Bui on 7/15/11.
//  Copyright 2011 Snapsta. All rights reserved.
//

#import "SSCameraViewController.h"
//#import "SSAppDelegate.h"
//#import "SSFacebook.h"
//#import "UIImage+Resize.h"
//#import "UIImage+Effects.h"



@implementation SSCameraViewController

@synthesize _mdelegate;

epubstore_svcAppDelegate*appDelegate;

- (id)initWithAlbum:(NSDictionary *)album {
    if ((self = [super init])) {
        

        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.allowsEditing = NO;
        self.showsCameraControls = NO;
        self.delegate = _mdelegate;
        
          
    }

    return self;
}

- (void)dealloc {
    

	[super dealloc];
}

#pragma mark - View lifetime cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate.boolFlag =1;
    UIView * view = self.view;
    //UIImage * cameraBar = [UIImage imageNamed:@"CameraBar"];
    //int curSW = [[UIScreen mainScreen] bounds].size.width;
    int curSH = [[UIScreen mainScreen] bounds].size.height;

 
    // Camera flip button
    UIImage * flipButtonImage = [UIImage imageNamed:@"CameraFlipButton"];
    UIButton * flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flipButton setImage:flipButtonImage forState:UIControlStateNormal];
    [flipButton addTarget:self action:@selector(flipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //flipButton.frame = CGRectMake(view.width - flipButtonImage.size.width - 8.0, _cameraBar.minY - flipButtonImage.size.height - 8.0, flipButtonImage.size.width, flipButtonImage.size.height);
    [view addSubview:flipButton];
    
    _activeRequests = [[NSMutableSet alloc] initWithCapacity:2];
    
    
    ///self.navigationBarHidden = YES;
    
    
    
    vl_BottomTabView = [[UIView alloc] initWithFrame:CGRectMake(0,(430.0/480)*curSH, view.frame.size.width ,(54.0/480)*curSH )];
    vl_BottomTabView.backgroundColor = [UIColor blackColor];
    [view addSubview:vl_BottomTabView];
    
    
    
    UIImage *tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_cancelRecord_iphone" ofType:@"png"]];
    
    UIButton *btnCancel;
    btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(5, 5, 60, 45);
    [btnCancel setImage:tempImage forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(goToLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    [vl_BottomTabView  addSubview:btnCancel];
    
    
    [tempImage release];
    
    
    tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ing_startRecord_iphone" ofType:@"png"]];
    
   
    btnStartRecord=[UIButton buttonWithType:UIButtonTypeCustom];
    btnStartRecord.frame = CGRectMake(130, 5, 60, 45);
    [btnStartRecord setImage:tempImage forState:UIControlStateNormal];
    [btnStartRecord addTarget:self action:@selector(startVideoRecording) forControlEvents:UIControlEventTouchUpInside];
    
    [vl_BottomTabView  addSubview:btnStartRecord];
    
    
    [tempImage release];
    
    
    
    
    
    tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ing_startRecord_iphone" ofType:@"png"]];
   
    btnStopRecord=[UIButton buttonWithType:UIButtonTypeCustom];
    btnStopRecord.frame = CGRectMake(130, 5, 60, 45);
    [btnStopRecord setImage:tempImage forState:UIControlStateNormal];
    [btnStopRecord addTarget:self action:@selector(StopVideoRecording) forControlEvents:UIControlEventTouchUpInside];
    btnStopRecord.hidden = YES;
    [vl_BottomTabView  addSubview:btnStopRecord];
    
    
    [tempImage release];
    
    
    
    
    tempImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"img_library_iphone" ofType:@"png"]];
    
    UIButton *btnLibrary;
    btnLibrary=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLibrary.frame = CGRectMake(265, 5, 60, 45);
    [btnLibrary setImage:tempImage forState:UIControlStateNormal];
    [btnLibrary addTarget:self action:@selector(goToLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    [vl_BottomTabView  addSubview:btnLibrary];

    
    [tempImage release];
    
    
    
}

-(void)cancelCameraController
{

 

}


-(void)startVideoRecording
{

    btnStartRecord.hidden = YES;
    btnStopRecord.hidden = NO;

    [self startVideoCapture];
}


-(void)StopVideoRecording
{
    
    btnStartRecord.hidden = NO;
    btnStopRecord.hidden = YES;
    
    [self stopVideoCapture];

}



-(void)goToLibrary
{

 [_mdelegate goToLibrary];

}




- (void)viewDidUnload {
    [super viewDidUnload];
    
 }

#pragma mark - Camera delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
     
    
   /* UIImage * resizedImage = [[info objectForKey:UIImagePickerControllerOriginalImage] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(720.0, 720.0) interpolationQuality:kCGInterpolationMedium];

    */            
        
    }


- (void)flipButtonPressed:(id)sender {
    self.cameraDevice = (self.cameraDevice == UIImagePickerControllerCameraDeviceFront) ? UIImagePickerControllerCameraDeviceRear : UIImagePickerControllerCameraDeviceFront;
}



@end
