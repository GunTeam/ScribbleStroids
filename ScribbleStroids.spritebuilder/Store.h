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
    
    //end code connections
    
}

@property int shipCost;
@property int gunCost;
@property int shieldCost;

@end
