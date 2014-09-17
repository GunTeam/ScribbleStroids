//

//  InAppPurchaseScene.m

//  ScribbleStroids

//

//  Created by Jorrie Brettin on 9/16/14.

//  Copyright 2014 Apportable. All rights reserved.

//

#define k_Save @"Saveitem"



#import "InAppPurchaseScene.h"





@implementation InAppPurchaseScene



-(void) didLoadFromCCB{
    
    SSS = .03;
    
    MSS = .05;
    
    LSS = .08;
    
    
    
    //start load background
    
    int randX = 0;
    
    int randY = 0;
    
    while (randX == 0 || randY == 0) {
        
        randX = arc4random() % 10 - 5;
        
        randY = arc4random() % 10 - 5;
        
        
        
    }
    
    smallStarSpeedX = randX * SSS;
    
    smallStarSpeedY = randY * SSS;
    
    
    
    mediumStarSpeedX = randX * MSS;
    
    mediumStarSpeedY = randY * MSS;
    
    
    
    largeStarSpeedX = randX * LSS;
    
    largeStarSpeedY = randY * LSS;
    
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    CGSize screenSize = screenBound.size;
    
    screenWidth = screenSize.width;
    
    screenHeight = screenSize.height;
    
    
    
    //start load background
    
    smallStarsArray = [[NSMutableArray alloc]init];
    
    mediumStarsArray = [[NSMutableArray alloc]init];
    
    largeStarsArray = [[NSMutableArray alloc]init];
    
    
    
    for (int i = 0; i <= 2; i++) {
        
        for (int j = 0; j <= 2; j++) {
            
            
            
            Stars *small = (Stars *)[CCBReader load:@"SmallStars"];
            
            small.position = CGPointMake(i*160, j*284);
            
            [self addChild:small z:-5];
            
            [smallStarsArray addObject:small];
            
            
            
            Stars *medium = (Stars *) [CCBReader load:@"MediumStars"];
            
            medium.position = CGPointMake(i*160, j*284);
            
            [self addChild:medium z:-5];
            
            [mediumStarsArray addObject:medium];
            
            
            
            Stars *large = (Stars *) [CCBReader load:@"LargeStars"];
            
            large.position = CGPointMake(i*160, j*284);
            
            [self addChild:large z:-5];
            
            [largeStarsArray addObject:large];
            
            
            
        }
        
    }
    
    
    
    CCSprite *background = (CCSprite *)[CCBReader load:@"Background"];
    
    [self addChild:background z:-6];
    
    //end load background
    
}





-(void) update:(CCTime)delta{
    
    for (Stars *star in smallStarsArray) {
        
        star.position = CGPointMake(star.position.x - smallStarSpeedX,star.position.y - smallStarSpeedY);
        
    }
    
    for (Stars *star in mediumStarsArray) {
        
        star.position = CGPointMake(star.position.x - mediumStarSpeedX,star.position.y - mediumStarSpeedY);
        
    }
    
    for (Stars *star in largeStarsArray) {
        
        star.position = CGPointMake(star.position.x - largeStarSpeedX,star.position.y - largeStarSpeedY);
        
    }
    
}



-(void) GoBack{
    
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
    
}



//purchase button selectors

//**********************************************************************************************

-(void) iAd{
    
    CCLOG(@"iad");
    
    
    
    self.productID = @"com.ScribbleStroids.RemoveAds";
    
    
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    
    
    [self getProductInfo:self];
    
}



-(void) SmallCoin{
    
    CCLOG(@"small");
    
    numberOfAdditionalCoins = 5000;
    
    
    
    self.productID = @"com.ScribbleStroids.Tier1coins";
    
    
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    
    
    [self getProductInfo:self];
    
}



-(void) MediumCoin{
    
    CCLOG(@"medium");
    
    numberOfAdditionalCoins = 25000;
    
    
    
    self.productID = @"com.ScribbleStroids.Tier3coins";
    
    
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    
    
    [self getProductInfo:self];
    
}



-(void) LargeCoin{
    
    CCLOG(@"large");
    
    numberOfAdditionalCoins = 50000;
    
    
    
    self.productID = @"com.ScribbleStroids.Tier5coins";
    
    
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    
    
    [self getProductInfo:self];
    
}

//**********************************************************************************************









//**********************************************************************************************

-(void)Purchased

{
    
    if ([self.productID isEqualToString:@"com.ScribbleStroids.RemoveAds"]) {
        
        NSUserDefaults *saveapp = [NSUserDefaults standardUserDefaults];
        
        [saveapp setBool:TRUE forKey:k_Save];
        
        
        
        [saveapp synchronize];
        
    }
    
    else {
        
        [[NSUserDefaults standardUserDefaults]setInteger:[[NSUserDefaults standardUserDefaults]integerForKey:@"bank"]+ numberOfAdditionalCoins forKey:@"bank"];
        
    }
    
}



-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue

{
    
    [self unlockFeature];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Restored" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    
}



-(void)unlockFeature

{
    
    [self Purchased];
    
}



-(void) getProductInfo:(InAppPurchaseScene *)viewController

{
    
    if ([SKPaymentQueue canMakePayments]) {
        
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.productID]];
        
        
        
        request.delegate = self;
        
        
        
        [request start];
        
    }
    
    else {
        
    }
    
}

//**********************************************************************************************





//Displaying the in-app purchase on the screen

//**********************************************************************************************

#pragma mark -

#pragma mark SKProductsRequestDelegate



-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response

{
    
    NSArray *products = response.products;
    
    
    
    if (products.count != 0) {
        
        _product = products[0];
        
        
        
        //Initial alertview displaying product info and asking to buy, restore, or cancel
        
        if ([_productID isEqualToString:@"com.ScribbleStroids.RemoveAds"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_product.localizedTitle message:_product.localizedDescription delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Purchase", @"Restore Previous Purchase", nil];
            
            [alert show];
            
        }
        
        else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_product.localizedTitle message:_product.localizedDescription delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Purchase", nil];
            
            [alert show];
            
        }
        
    }
    
    else {
        
        //Error message if product cannot be found
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product not found" message:@"Are you connected to the internet?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
    
    
    products = response.invalidProductIdentifiers;
    
    
    
    for (SKProduct *product in products)
    
    {
        
        NSLog(@"Product Not found: %@", product);
        
    }
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    //Cancel
    
    if (buttonIndex == 0) {
        
        NSLog(@"button at 0 clicked");
        
    }
    
    //Purchase
    
    else if (buttonIndex == 1) {
        
        SKPayment *payment = [SKPayment paymentWithProduct:_product];
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
    }
    
    //Restore
    
    else if (buttonIndex == 2) {
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        
    }
    
}



#pragma mark -

#pragma mark SKPaymentTransactionObserver



//Confirms whether the payment goes through or not

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions

{
    
    for (SKPaymentTransaction *transaction in transactions)
    
    {
        
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchased:
                
            {
                
                [self unlockFeature];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
                
            }
                
                
                
            case SKPaymentTransactionStateFailed:
                
            {
                
                NSLog(@"Transaction Failed");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Try again or restore purchase if you have already bought it. You will not be charged twice." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
                
            }
                
                
                
            default:
                
                break;
                
        }
        
    }
    
}

//**********************************************************************************************





@end