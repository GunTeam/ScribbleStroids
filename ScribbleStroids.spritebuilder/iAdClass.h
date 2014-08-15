//
//  iAdClass.h
//  ScribbleStroids
//
//  Created by Adam Birdsall on 8/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface iAdClass : NSObject <ADBannerViewDelegate>
{
    ADBannerView *BannerView;
    BOOL _adBannerViewIsVisible;
    UIView *_contentView;
}

@property (nonatomic, assign) ADBannerView *adBannerView;
@property (nonatomic) BOOL adBannerViewIsVisible;

-(void)RemoveiAd ;
- (void)createAdBannerView ;

@end
