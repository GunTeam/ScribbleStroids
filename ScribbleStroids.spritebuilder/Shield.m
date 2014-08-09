//
//  Shield.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/9/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Shield.h"


@implementation Shield

-(void) didLoadFromCCB {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    self.physicsBody.collisionGroup = @"AsteroidGroup";
    self.physicsBody.collisionType = @"pickupShield";
}

-(void) update:(CCTime)delta{
    if (self.position.x > screenWidth || self.position.x < 0 || self.position.y > screenHeight || self.position.y < 0){
        [self removeFromParent];
    }
}

@end
