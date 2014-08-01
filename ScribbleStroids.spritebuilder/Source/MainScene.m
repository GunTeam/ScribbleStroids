//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameScene.h"

@implementation MainScene

-(void) didLoadFromCCB{
    //any custom initialization needed goes here
    
}

-(void) playGame{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameScene"]];

    [_adView removeFromSuperview];
}

-(void) howTo{
    
}

-(void) highScores{
    
}

# pragma mark - iAd code

-(id)init
{
    if( (self= [super init]) )
    {
        // On iOS 6 ADBannerView introduces a new initializer, use it when available.
        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
            _adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
            
        } else {
            _adView = [[ADBannerView alloc] init];
        }
        _adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        _adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        [[[CCDirector sharedDirector]view]addSubview:_adView];
        [_adView setBackgroundColor:[UIColor clearColor]];
        [[[CCDirector sharedDirector]view]addSubview:_adView];
        _adView.delegate = self;
    }
    [self layoutAnimated:YES];
    return self;
}


- (void)layoutAnimated:(BOOL)animated
{
    // As of iOS 6.0, the banner will automatically resize itself based on its width.
    // To support iOS 5.0 however, we continue to set the currentContentSizeIdentifier appropriately.
    CGRect contentFrame = [CCDirector sharedDirector].view.bounds;
    if (contentFrame.size.width < contentFrame.size.height) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        contentFrame.size.height -= _bannerView.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        _bannerView.frame = bannerFrame;
    }];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self layoutAnimated:YES];
}




@end
