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
    
    self.isMain = false;
    
    self.physicsBody.collisionGroup = @"AsteroidGroup";
    self.physicsBody.collisionType = @"asteroid";
    self.physicsBody.collisionMask = @[@"bullet",@"ship"];
    
    self.key = true;
    
    destroyed =  [OALSimpleAudio sharedInstance];
    
    int x = arc4random_uniform(5) - 2;
    
    self.physicsBody.angularVelocity = x * .6;
    

}

-(void) update:(CCTime)delta {
    if (!self.isMain) {
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
    
}

-(void) onExit {
    [super onExit];

    int effect = arc4random() % 2;
    if (effect == 0) {
        [destroyed playEffect:@"bulletAsteroid5.mp3"];
    } else if (effect == 1){
        [destroyed playEffect:@"bulletAsteroid6.mp3"];
    }
    
}


@end
