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
    CCAnimationManager *animationManager;
    CCSprite *_flames;
    CCSprite *_shield,*_orangeShield,*_redShield,*_blueShield,*_greenShield,*_purpleShield;
    double shieldTimer;
    double bulletScale;
    OALSimpleAudio *shipfiresound, *thrustsound,*shipdestroyed;
    
    int thrustSoundTimer;
    
    
    double fireRate;
}

@property bool flamesVisible;
@property double rateOfFire;
@property bool readyToFire;
@property bool immune;
@property bool inMain;

//-(void) fire;
-(void) hideFlames;
-(void) showFlames;
-(void) raiseShield;
-(void) didLoadFromCCB;
-(void) fire;
-(void) takeDownShield;

@end
