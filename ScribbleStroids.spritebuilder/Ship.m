//
//  Ship.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/28/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Ship.h"

double bulletLaunchImpulse = 3;

@implementation Ship

-(void) didLoadFromCCB {
    self.physicsBody.collisionType = @"ship";
    self.physicsBody.collisionGroup = @"ShipGroup";
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
}

-(void) update:(CCTime)delta{
    //The ship knows where it is on screen and can roll over to the other side accordingly
    if (self.position.x > screenWidth){
        self.position = CGPointMake(0, self.position.y);
    } else if (self.position.x < 0){
        self.position = CGPointMake(screenWidth, self.position.y);
    }
    
    if (self.position.y > screenHeight){
        self.position = CGPointMake(self.position.x, 0);
    } else if (self.position.y < 0) {
        self.position = CGPointMake(self.position.x, screenHeight);
    }
}

//This is the method that fires the bullets.
-(void) fire {
    CCLOG(@"Ship has fired");
    CCSprite *bullet = (CCSprite *)[CCBReader load:@"Bullet"];
    bullet.position = self.position;
    bullet.physicsBody.velocity = self.physicsBody.velocity;
    
    bullet.physicsBody.velocity = self.physicsBody.velocity;
    [self.parent addChild:bullet];
    [bullet.physicsBody applyImpulse: CGPointMake(bulletLaunchImpulse*cos(self.rotation*M_PI/180),
                                                    bulletLaunchImpulse*-sin(self.rotation*M_PI/180))];
    
}

@end
