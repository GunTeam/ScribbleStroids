//
//  Asteroid.h
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/28/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Asteroid : CCSprite {
    CGFloat screenWidth,screenHeight;
}

@property int size;
@property int numberOfAsteroids;

@end
