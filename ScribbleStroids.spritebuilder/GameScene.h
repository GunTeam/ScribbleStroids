//
//  GameScene.h
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Ship.h"
#import "Asteroid.h"
#import "Stars.h"
#import "Bullet.h"
#import "Bomb.h"
#import "Shield.h"
#import "Coin.h"
#import "CoinLabel.h"
#import "Level1.h"
#import "Level2.h"
#import "Level3.h"
#import "Level4.h"
#import "Level5.h"
#import "Explosion.h"
#import "ShipExplosion.h"

@interface GameScene : CCNode <CCPhysicsCollisionDelegate>
{
    //SB code connections
    CCButton *_pauseButton;
    CCButton *_boostButton;
    CCButton *_shootButton;
    CCButton *_storeButton;
    CCButton *_settingsButton;
    CCSprite *_joystickCenter;
    CCSprite *_joystickArrow;
    CCSprite *_pauseMenu;
    CCLabelTTF *_extraLifeCostLabel;
    CCLabelTTF *_extraNukeCostLabel;
    CCLabelTTF *_pauseBankLabel;
    CCLabelTTF *_pauseBankBalance;
    CCButton *_buyLife;
    CCButton *_buyShield;
    CCLabelTTF *_tutLabel11,*_tutLabel12,*_tutLabel21,*_tutLabel22,*_tutLabel23,*_tutLabel24,*_tutLabel31,*_tutLabel41,*_tutLabel42,*_tutLabel43,*_tutLabel44,*_tutLabel51;
    CCSprite *_tutSprite,*_tutStroid1,*_tutStroid2,*_tutStroid3;
    Coin *_tutCoin1,*_tutCoin2,*_tutCoin3;
    //end SB code connections
    
    //background sprites
    NSMutableArray *smallStarsArray,*mediumStarsArray,*largeStarsArray;
    NSMutableArray *asteroidArray;
    
    CCLabelTTF *levelLabel;
    CCLabelTTF *scoreLabel;
    
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    CCPhysicsNode *_physicsNode;
    
    Ship *mainShip;
    
    int tutorialStep;
}

@property int numberOfAsteroidsRemaingingInLevel;
@property int level;
@property int score;
@property int lives;
@property int numShields;
@property bool paused;
@property int bankRoll;
@property int extraShieldCost;
@property int extraLifeCost;
@property bool tutorial;

@end
