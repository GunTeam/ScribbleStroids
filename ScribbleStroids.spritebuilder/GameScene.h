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
    CCButton *_buyLife;
    CCButton *_buyNuke;
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
}

@property int numberOfAsteroidsRemaingingInLevel;
@property int level;
@property int score;
@property int lives;
@property int numBombs;
@property bool paused;
@property int bankRoll;

@end
