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
    CCBAnimationManager *animationManager;
    CCSprite *_flames;
}

@property CCSprite* flames;

-(void) fire;
-(void) hideFlames;
-(void) showFlames;

@end
