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

-(void) fire {
    CCLOG(@"Ship has fired");
    CCSprite *bullet = (CCSprite *)[CCBReader load:@"Bullet"];
    bullet.physicsBody.velocity = self.physicsBody.velocity;
    
    bullet.physicsBody.velocity = self.physicsBody.velocity;
    [bullet.physicsBody applyImpulse: CGPointMake(bulletLaunchImpulse*cos(self.rotation*M_PI/180),
                                                    bulletLaunchImpulse*-sin(self.rotation*M_PI/180))];
    [self.parent addChild:bullet];
}

@end
