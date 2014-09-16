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
    
//    self.physicsBody.collisionGroup = @"AsteroidGroup";
    self.physicsBody.collisionType = @"pickupShield";
    self.physicsBody.collisionCategories = @[@"shield"];
    self.physicsBody.collisionMask = @[@"shield"];
    
    timeToGo = false;
    self.displayShield = false;
    
}

-(void) update:(CCTime)delta{
    if (!self.displayShield) {
        if (self.opacity == 0 && timeToGo) {
            [self removeFromParent];
        }
        timeLimit+=1./60;
        if (timeLimit > 8) {
            timeLimit = 0;
            [self fadeOut];
            timeToGo = true;
        }
    }
    
    
}

-(void) fadeOut{
    [self runAction:[CCActionFadeOut actionWithDuration:3]];
}

@end
