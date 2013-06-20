//
//  inAppPurchaseView.h
//  BlackBook
//
//  Created by zaahtechnologiesindiapvt on 11/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>

@protocol inAppPurchaseViewDelegate

-(void)deactivatePurchaseMode;
-(void)updatePurchasedProduct:(NSString*)productId;
@end


@interface inAppPurchaseView : UIView <SKProductsRequestDelegate,SKRequestDelegate>
{
	NSString *purchasedprd;	
	SKProduct *proUpgradeProduct;
	SKProductsRequest *productsRequest;
	SKPaymentQueue *purchaseSk;
	NSString *kInAppPurchaseProUpgradeProductId;
}
@property(nonatomic,assign)id<inAppPurchaseViewDelegate>_delegate;

@end
