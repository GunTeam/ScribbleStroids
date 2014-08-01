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

@interface MainScene : CCNode <ADBannerViewDelegate>
{
    CCLabelTTF *_titleLabel;
    ADBannerView *_bannerView;
    ADBannerView *_adView;
}
-(void) playGame;
-(void) howTo;
-(void) highScores;

@end
