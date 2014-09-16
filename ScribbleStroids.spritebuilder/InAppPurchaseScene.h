//
//  InAppPurchaseScene.h
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 9/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Stars.h"

@interface InAppPurchaseScene : CCNode {
    double SSS,MSS,LSS;
    NSMutableArray *smallStarsArray,*mediumStarsArray,*largeStarsArray;
    double smallStarSpeedX,smallStarSpeedY,mediumStarSpeedX,mediumStarSpeedY,largeStarSpeedX,largeStarSpeedY;
    CGFloat screenWidth,screenHeight;
    
}

@end
