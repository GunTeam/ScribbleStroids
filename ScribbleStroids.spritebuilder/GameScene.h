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

@interface GameScene : CCNode <CCPhysicsCollisionDelegate>
{
    //SB code connections
    CCButton *_leftButton;
    CCButton *_rightButton;
    CCButton *_boostButton;
    CCButton *_shootButton;
    CCSprite *_joystickCenter;
    CCSprite *_joystickArrow;
    //end SB code connections
    
    //background sprites
    NSMutableArray *smallStarsArray,*mediumStarsArray,*largeStarsArray;
    
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

@end
