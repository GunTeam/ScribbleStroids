//
//  Bullet.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/29/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Bullet.h"


@implementation Bullet

-(void) didLoadFromCCB{
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    if (screenWidth == 768 && screenHeight == 1024) {
        screenWidth = screenWidth/2;
        screenHeight = screenHeight/2;
    }
    
    CCLOG(@"bullet has been spawned");
    self.physicsBody.collisionType = @"bullet";
//    self.physicsBody.collisionGroup = @"ShipGroup";
    self.physicsBody.collisionMask = @[@"asteroid"];
    self.physicsBody.collisionCategories = @[@"bullet"];
    _explosion.visible = false;
    animationManager = self.userObject;

    
}

-(void) update:(CCTime)delta{
    if (self.position.y > screenHeight || self.position.y < 0 || self.position.x > screenWidth ||self.position.x < 0) {
        [self removeFromParentAndCleanup:true];
    }
    
}

@end
