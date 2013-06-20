//
//  inAppPurchaseView.m
//  BlackBook
//
//  Created by zaahtechnologiesindiapvt on 11/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "inAppPurchaseView.h"
#import "epubstore_svcAppDelegate.h"


@implementation inAppPurchaseView
@synthesize _delegate;

- (id)initWithFrame:(CGRect)frame {
	
		NSLog(@"iniT");
    
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if (self) 
	{
        // Initialization code.
		self.backgroundColor=[UIColor blackColor];
		self.alpha = 0.6;
		UIActivityIndicatorView *loader=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
		loader.center=self.center;
		loader.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
		[self addSubview:loader];
		[loader startAnimating];
		//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
		self.exclusiveTouch=TRUE;
    }
    return self;
}
-(void)purchaseSelectedItem:(NSString *)productId
{
		NSLog(@"purchSelITEM");
	kInAppPurchaseProUpgradeProductId=@"FlickFootBall01";
//	[self requestProUpgradeProductData];
	[self loadStore];
///	[self.superview setUserInteractionEnabled:FALSE];
}

//.................In-App purchase Code........Starts here................................

- (void)requestProUpgradeProductData
{
	
	NSLog(@"Requesting %@ Purchase",kInAppPurchaseProUpgradeProductId);
    NSSet *productIdentifiers = [NSSet setWithObject:kInAppPurchaseProUpgradeProductId ];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
		NSLog(@"proReqqq");
    NSArray *products = response.products;
    proUpgradeProduct = [products count] == 1 ? [[products firstObject] retain] : nil;
    if (proUpgradeProduct)
    {
        NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
        NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
        NSLog(@"Product price: %@" , proUpgradeProduct.price);
        NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
		
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"title:%@, desc:%@, price:%@, id:%@",proUpgradeProduct.localizedTitle,proUpgradeProduct.localizedDescription,proUpgradeProduct.price,proUpgradeProduct.productIdentifier] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"ERROR" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		//[alert show]; 
		//[alert release];
		
		if([self canMakePurchases])
			[self purchaseProUpgrade];
		
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
		
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"invalid product id ! : %@",invalidProductId] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"ERROR" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
[alert show]; 
		
		[alert release];
///		[self.superview setUserInteractionEnabled:TRUE];
//		[_delegate deactivatePurchaseMode];
		[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
		[self removeFromSuperview];
		
		
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
////    [productsRequest release];
    
	//[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
		NSLog(@"reqFailed");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"ERROR :1 %@" , [error description] ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
	[alert show]; 
	[alert release];
////	[self.superview setUserInteractionEnabled:TRUE];
//	[_delegate deactivatePurchaseMode];
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
	[self removeFromSuperview];
	
}
- (void)requestDidFinish:(SKRequest *)request
{
	
	
}
#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore
{
		NSLog(@"loadSt");
    // restarts any purchases if they were interrupted last time the app was open

    
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
		NSLog(@"CanMake");
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
		NSLog(@"purchasePro");
	NSLog(@"productId===%@",kInAppPurchaseProUpgradeProductId);
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseProUpgradeProductId];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
	
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
		NSLog(@"recordT");
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
		NSLog(@"ProvidCont");
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"transaction success : %@",productId] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
//	//[alert show]; 
//	[alert release];
	
	epubstore_svcAppDelegate *delg = (epubstore_svcAppDelegate*)[UIApplication sharedApplication].delegate;
	if(delg.gameController.isProVersion == TRUE)return;
	
	
	NSLog(@"Product purchased...");
    if ([productId isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        // enable the pro features
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Successfully Purchased. Thank you!"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
		
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
		//TBONEAppDelegate *delg = (TBONEAppDelegate*)[UIApplication sharedApplication].delegate;
		delg.gameController.isProVersion = TRUE;

		purchasedprd=productId;
////		[self.superview setUserInteractionEnabled:TRUE];
		[_delegate updatePurchasedProduct:kInAppPurchaseProUpgradeProductId];
		
		[delg.gameController hideButton];
    }
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
	[self removeFromSuperview];
	
	
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	
}

- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
	NSLog(@"finishT");
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
   // NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        //[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
		
		//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"transaction success : %@",transaction.payment.productIdentifier ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		//	[alert show]; 
		//[alert release];
    }
    else
    {
        // send out a notification for the failed transaction
		// [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"transaction failed : %@",transaction.payment.productIdentifier ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
		//	[self removeFromSuperview];
    }
	////	[self.superview setUserInteractionEnabled:TRUE];
	///	[_delegate deactivatePurchaseMode];
	//	[self removeFromSuperview];
	
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{	NSLog(@"compleT");
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
	//  [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{	NSLog(@"restT");
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	
	NSLog(@"failedT");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[transaction.error description] ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
		NSLog(@"user Cancelled request....");
    }
	////	[self.superview setUserInteractionEnabled:TRUE];
	//	[_delegate deactivatePurchaseMode];
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
	[self removeFromSuperview];
	
	
	
}

#pragma mark -

#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	NSLog(@"pq-updT");
    for (SKPaymentTransaction *transaction in transactions)
    { 
		
		
		
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
	NSLog(@"pq-rT");
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	NSLog(@"pq-fT");
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue 
{
	NSLog(@"pq-cT");
}



//
// removes the transaction from the queue and posts a notification with the transaction result
//


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
//	[productsRequest release];
//	_delegate=nil;
}


@end
