//
//  GameScene.h
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCNode {
    //SB code connections
    CCButton *_leftButton;
    CCButton *_rightButton;
    CCButton *_boostButton;
    CCButton *_shootButton;
    CCLabelTTF *_scoreLabel;
    //end SB code connections
    
    CCSprite *mainShip;
}

@end
