//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import "cocos2d.h"
#import "CCNode.h"
#import "GADBannerView.h"

typedef enum _bannerType
{
    kBanner_Portrait_Top,
    kBanner_Portrait_Bottom,
}CocosBannerType;

#define BANNER_TYPE  kBanner_Portrait_Bottom

@interface MainScene : CCNode <GADBannerViewDelegate, ADBannerViewDelegate>
{
    CCLabelTTF *_titleLabel;
    ADBannerView *_bannerView;
    ADBannerView *_adView;
    
    GADBannerView *mBannerView;
    CocosBannerType mBannerType;
    float on_x, on_y, off_x, off_y;
}
-(void) playGame;
-(void) howTo;
-(void) highScores;

@end
