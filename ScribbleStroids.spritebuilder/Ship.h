//
//  Ship.h
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/28/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Ship : CCSprite {
    CGFloat screenWidth,screenHeight;
    CCBAnimationManager *animationManager;
    CCSprite *_flames;
    CCSprite *_shield;
    
    double fireRate;
}

@property CCSprite* flames;
@property double rateOfFire;
@property bool readyToFire;
@property bool immune;
@property int numShields;
@property bool inMain;

-(void) fire;
-(void) hideFlames;
-(void) showFlames;
-(void) shieldUp:(CCTime)dt;
-(void) touchShield;
@end
