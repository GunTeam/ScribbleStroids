//
//  Asteroid.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/28/14.
//  Copyright 2014 Apportable. All rights reserved.
//
// This class takes care of all the asteroids

#import "Asteroid.h"


@implementation Asteroid

-(void) didLoadFromCCB {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    self.physicsBody.collisionGroup = @"AsteroidGroup";
    self.physicsBody.collisionType = @"asteroid";
}

-(void) update:(CCTime)delta {
    
    if (self.position.x > screenWidth) {
        self.position = CGPointMake(0, self.position.y);
    } else if (self.position.x < 0) {
        self.position = CGPointMake(screenWidth, self.position.y);
    }
    
    if (self.position.y > screenHeight) {
        self.position = CGPointMake(self.position.x, 0);
    } else if (self.position.y < 0) {
        self.position = CGPointMake(self.position.x, screenHeight);
    }
}


@end
