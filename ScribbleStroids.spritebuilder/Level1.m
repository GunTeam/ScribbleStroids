//
//  Level1.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/14/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Level1.h"


@implementation Level1

-(void) didLoadFromCCB{
    [super didLoadFromCCB];
    self.rateOfFire = 1./20;
}

-(void) fire {
    fireRate = 1;
    
    int bulletLaunchImpulse = 3;
    int positionBoost = 23;
    
    CCSprite *bullet = (CCSprite *)[CCBReader load:@"Bullet"];
    bullet.position = CGPointMake(self.position.x + positionBoost*sin(self.rotation*M_PI/180), self.position.y + positionBoost*cos(self.rotation*M_PI/180));
    bullet.physicsBody.velocity = self.physicsBody.velocity;
    bullet.scale = 2;
    [self.parent addChild:bullet z:-2];
    [bullet.physicsBody applyImpulse: CGPointMake(bulletLaunchImpulse*cos((self.rotation-90)*M_PI/180),
                                                  bulletLaunchImpulse*-sin((self.rotation-90)*M_PI/180))];
}

@end
