////
////  SSCameraViewController.m
////  Snapsta
////
////  Created by Kevin Bui on 7/15/11.
////  Copyright 2011 Snapsta. All rights reserved.
////
//
//#import "SSCameraViewController.h"
////#import "SSAppDelegate.h"
////#import "SSFacebook.h"
////#import "UIImage+Resize.h"
////#import "UIImage+Effects.h"
//
//
//@implementation SSCameraViewController
//
//
//- (id)initWithAlbum:(NSDictionary *)album {
//    if ((self = [super init])) {
//        _album = [album retain];
//
//        self.sourceType = UIImagePickerControllerSourceTypeCamera;
//        self.allowsEditing = NO;
//        self.showsCameraControls = NO;
//        self.delegate = self;
//        
//        _filterName = @"None";
//        _borderName = @"None";
//    }
//
//    return self;
//}
//
//- (void)dealloc {
//    [_filterName release];
//    [_borderName release];
//
//	[_activeRequests release];
//    [_cameraBar release];
//    [_cameraToolbar release];
//    [_borderOverlay release];
//	[_album release];
//
//	[super dealloc];
//}
//
//#pragma mark - View lifetime cycle
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//   
//    UIView * view = self.view;
//    UIImage * cameraBar = [UIImage imageNamed:@"CameraBar"];
//    
//    _borderOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height - cameraBar.size.height)];
//    _borderOverlay.backgroundColor = [UIColor clearColor];
//    _borderOverlay.contentMode = UIViewContentModeScaleToFill;
//    [view addSubview:_borderOverlay];
//
//    _cameraBar = [[SSCameraBar alloc] initWithFrame:CGRectMake(0, view.height - cameraBar.size.height, view.width, cameraBar.size.height)];
//    _cameraBar.delegate = self;
//    [view addSubview:_cameraBar];
//    
//    _cameraToolbar = [[SSCameraToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0)];
//    _cameraToolbar.delegate = self;
//    [view addSubview:_cameraToolbar];
//    
//    // Camera flip button
//    UIImage * flipButtonImage = [UIImage imageNamed:@"CameraFlipButton"];
//    UIButton * flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [flipButton setImage:flipButtonImage forState:UIControlStateNormal];
//    [flipButton addTarget:self action:@selector(flipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    flipButton.frame = CGRectMake(view.width - flipButtonImage.size.width - 8.0, _cameraBar.minY - flipButtonImage.size.height - 8.0, flipButtonImage.size.width, flipButtonImage.size.height);
//    [view addSubview:flipButton];
//    
//    _activeRequests = [[NSMutableSet alloc] initWithCapacity:2];
//    
//    _cameraToolbar.title = [_album objectForKey:@"name"];
//    self.navigationBarHidden = YES;
//}
//
//- (void)viewDidUnload {
//    [super viewDidUnload];
//    
//    [_filterName release], _filterName = nil;
//    [_borderName release], _borderName = nil;
//
//    [_borderOverlay release], _borderOverlay = nil;
//    [_cameraBar release], _cameraBar = nil;
//    [_cameraToolbar release], _cameraToolbar = nil;
//    [_activeRequests release], _activeRequests = nil;
//}
//
//#pragma mark - Camera delegates
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    _cameraBar.cameraButtonEnabled = YES;
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
//        UIImage * resizedImage = [[info objectForKey:UIImagePickerControllerOriginalImage] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(720.0, 720.0) interpolationQuality:kCGInterpolationMedium];
//
//        UIImage * transformedImage = [resizedImage imageWithFilter:_filterName border:_borderName];
//        
//        // Always write to local camera library
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            UIImageWriteToSavedPhotosAlbum(transformedImage, nil, nil, nil);
//        });
//
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:transformedImage, @"picture", nil];
//            
//            if (_backgroundTask == 0) {
//                [self retain];
//                _backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//                    [[UIApplication sharedApplication] endBackgroundTask:_backgroundTask];
//                    _backgroundTask = UIBackgroundTaskInvalid;
//                }];
//            }
//
//            [[SSFacebook sharedInstance] requestWithGraphPath:[NSString stringWithFormat:@"%@/photos", [_album objectForKey:@"id"]] andParams:params andHttpMethod:@"POST" andDelegate:self];
//
//            if (!_activeRequests.count) {
//                _totalExpectedContentLength = _totalReceivedContentLength = 0;
//                _cameraToolbar.progress = 0;
//                _cameraToolbar.progressViewHidden = NO;
//            }
//        });
//    });
//}
//
//- (void)cameraBar:(SSCameraBar *)bar cameraButtonPressed:(id)sender {
//    UIView * flashView = [[UIView alloc] initWithFrame:self.view.bounds];
//    flashView.backgroundColor = [UIColor whiteColor];
//    flashView.layer.opacity = 0;
//    [self.view addSubview:flashView];
//    [flashView release];
//    
//    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^(void) {
//        flashView.layer.opacity = 1.0;
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^(void) {
//                flashView.layer.opacity = 0;
//            } completion:^(BOOL finished) {
//                if (finished) {
//                    [flashView removeFromSuperview];
//                }
//            }];
//        }
//    }];
//    
//	_cameraBar.cameraButtonEnabled = NO;
//
//	[self takePicture];
//}
//
//- (void)cameraBar:(SSCameraBar *)bar flashModeChanged:(UIImagePickerControllerCameraFlashMode)flashMode {
//	self.cameraFlashMode = flashMode;
//}
//
//- (void)cameraBar:(SSCameraBar *)bar effectsSelectedFilter:(NSString *)filterName border:(NSString *)borderName {
//    [_filterName release];
//    _filterName = [filterName copy];
//    
//    [_borderName release];
//    _borderName = [borderName copy];
//    
//    // Hack the border name and prefix with correct image file name
//    NSString * imageName = [NSString stringWithFormat:@"Border%@", [borderName stringByReplacingOccurrencesOfString:@" " withString:@""]];
//    _borderOverlay.image = [UIImage imageNamed:imageName];
//}
//
//- (void)flipButtonPressed:(id)sender {
//    self.cameraDevice = (self.cameraDevice == UIImagePickerControllerCameraDeviceFront) ? UIImagePickerControllerCameraDeviceRear : UIImagePickerControllerCameraDeviceFront;
//}
//
//- (void)cameraToolbar:(SSCameraToolbar *)toolbar doneButtonPressed:(id)sender {
//    [self.parentViewController dismissModalViewControllerAnimated:YES];
//}
//
//#pragma mark - Facebook delegates
//
//- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
//	[_activeRequests removeObject:[request.params objectForKey:@"picture"]];
//    
//	if (!_activeRequests.count) {
//		_cameraToolbar.progressViewHidden = YES;
//	}
//    
//    [self release];
//
//	NSLog(@"%@", [error description]);
//	[UIAlertView showWithTitle:@"Upload Error" message:@"Your photo could not be uploaded at this time. Please try again later."];
//}
//
//- (void)request:(FBRequest *)request didLoad:(id)result {
//	[_activeRequests removeObject:[request.params objectForKey:@"picture"]];
//	
//	if (!_activeRequests.count) {
//		_cameraToolbar.progressViewHidden = YES;
//        
//        [[UIApplication sharedApplication] endBackgroundTask:_backgroundTask];
//        _backgroundTask = 0;
//	}
//    
//    [self release];
//}
//
//- (void)request:(FBRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
//	UIImage * image = [request.params objectForKey:@"picture"];
//	
//	if (![_activeRequests containsObject:image]) {
//		[_activeRequests addObject:image];
//		_totalExpectedContentLength += totalBytesExpectedToWrite;
//	}
//	
//	_totalReceivedContentLength += bytesWritten;
//	[_cameraToolbar setProgress:_totalReceivedContentLength / _totalExpectedContentLength animated:YES];
//}
//
//@end
