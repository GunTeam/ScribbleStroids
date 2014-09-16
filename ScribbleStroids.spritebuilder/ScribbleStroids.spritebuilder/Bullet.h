//
//  Bullet.h
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/29/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Explosion.h"

@interface Bullet : CCSprite {
    CGFloat screenWidth,screenHeight;
    CCSprite *_explosion;
    CCAnimationManager *animationManager;
}

@end
