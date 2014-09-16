//
//  HighScores.h
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/25/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Stars.h"

@interface HighScores : CCNode {
    double SSS,MSS,LSS;
    NSMutableArray *smallStarsArray,*mediumStarsArray,*largeStarsArray;
    double smallStarSpeedX,smallStarSpeedY,mediumStarSpeedX,mediumStarSpeedY,largeStarSpeedX,largeStarSpeedY;
    CGFloat screenWidth,screenHeight;
    CCLabelTTF *_highScoreLabel,*_asteroidsDestroyedLabel,*_deathsLabel,*_bulletsFiredLabel,*_highestLevelLabel;
}

@end
