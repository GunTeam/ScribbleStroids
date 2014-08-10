//
//  Settings.h
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/10/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Stars.h"

@interface Settings : CCNode {
    //start background
    NSMutableArray *smallStarsArray,*mediumStarsArray,*largeStarsArray;
    CGFloat screenWidth,screenHeight;
    double smallStarSpeedX,smallStarSpeedY,mediumStarSpeedX,mediumStarSpeedY,largeStarSpeedX,largeStarSpeedY;
    //end background
    
    //start code connections
    CCLabelTTF *_SFXToggle,*_musicToggle,*_tutorialToggle;
    
    CCColor *green,*red,*gold;
    
}

@property bool sfx;
@property bool music;
@property int tutorial;

@end
