//
//  Explosion.h
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Explosion : CCSprite {
    CCAnimationManager *animationManager;
    double timer;
}

@end
