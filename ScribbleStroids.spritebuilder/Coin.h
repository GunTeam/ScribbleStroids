//
//  Coin.h
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/10/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CoinLabel.h"

@interface Coin : CCSprite {
    double coinSpin;
    CCSprite *_coin;
    double fadeTime,timePassed;
}

@property int value;
@property CCColor *labelColor;
@property bool wasPickedUp;

@end
