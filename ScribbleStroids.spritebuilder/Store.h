//
//  Store.h
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/10/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Stars.h"

@interface Store : CCNode {
    NSMutableArray *smallStarsArray,*mediumStarsArray,*largeStarsArray;
    CGFloat screenWidth,screenHeight;
    double smallStarSpeedX,smallStarSpeedY,mediumStarSpeedX,mediumStarSpeedY,largeStarSpeedX,largeStarSpeedY;
    int bankRoll;
    
    //start code connections
    CCSprite *_ship,*_orangeShield,*_purpleShield,*_blueShield,*_greenShield,*_redShield;
    CCButton *_shipButton,*_gunButton,*_shieldButton;
    CCLabelTTF *_bankLabel;
    CCSprite *_Level1,*_Level2,*_Level3,*_Level4,*_Level5;
    CCSprite *_heart1,*_heart2,*_heart3,*_heart4,*_heart5;
    CCSprite *_star1,*_star2,*_star3,*_star4,*_star5;
    CCSprite *_clock1,*_clock2,*_clock3,*_clock4,*_clock5;
    //end code connections
    
}

@property int shipCost;
@property int gunCost;
@property int shieldCost;

@end
