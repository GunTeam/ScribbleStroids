//
//  Level4.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/14/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Level4.h"


@implementation Level4

-(void) didLoadFromCCB{
    [super didLoadFromCCB];
//    self.rateOfFire = 1./10.;
}

-(void) fire {
    fireRate = 1;
    int bulletLaunchImpulse = 3;
    int positionBoost = 17;
    
    CCSprite *bullet1 = (CCSprite *)[CCBReader load:@"Bullet"];
    bullet1.position = CGPointMake(self.position.x - positionBoost*cos(self.rotation*M_PI/180), self.position.y + positionBoost*sin(self.rotation*M_PI/180));
    bullet1.physicsBody.velocity = self.physicsBody.velocity;
    bullet1.scale = bulletScale;
    [self.parent addChild:bullet1 z:-2];
    [bullet1.physicsBody applyImpulse: CGPointMake(bulletLaunchImpulse*cos((self.rotation-90)*M_PI/180),
                                                   bulletLaunchImpulse*-sin((self.rotation-90)*M_PI/180))];
    
    CCSprite *bullet2 = (CCSprite *)[CCBReader load:@"Bullet"];
    bullet2.position = CGPointMake(self.position.x + positionBoost*cos(self.rotation*M_PI/180), self.position.y - positionBoost*sin(self.rotation*M_PI/180));
    bullet2.physicsBody.velocity = self.physicsBody.velocity;
    bullet2.scale = bulletScale;
    [self.parent addChild:bullet2 z:-2];
    [bullet2.physicsBody applyImpulse: CGPointMake(bulletLaunchImpulse*cos((self.rotation-90)*M_PI/180),
                                                   bulletLaunchImpulse*-sin((self.rotation-90)*M_PI/180))];
    
    CCSprite *bullet3 = (CCSprite *)[CCBReader load:@"Bullet"];
    bullet3.position = CGPointMake(self.position.x, self.position.y);
    bullet3.physicsBody.velocity = self.physicsBody.velocity;
    bullet3.scale = bulletScale;
    [self.parent addChild:bullet3 z:-2];
    [bullet3.physicsBody applyImpulse: CGPointMake(bulletLaunchImpulse*cos((self.rotation-90)*M_PI/180),
                                                   bulletLaunchImpulse*-sin((self.rotation-90)*M_PI/180))];
    
    CCSprite *bullet4 = (CCSprite *)[CCBReader load:@"Bullet"];
    bullet4.position = CGPointMake(self.position.x + positionBoost*sin(self.rotation*M_PI/180), self.position.y + positionBoost*cos(self.rotation*M_PI/180));
    bullet4.physicsBody.velocity = CGPointMake(-self.physicsBody.velocity.x,-self.physicsBody.velocity.y);
    bullet4.scale = bulletScale;
    [self.parent addChild:bullet4 z:-2];
    [bullet4.physicsBody applyImpulse: CGPointMake(-bulletLaunchImpulse*cos((self.rotation-90)*M_PI/180),
                                                   bulletLaunchImpulse*sin((self.rotation-90)*M_PI/180))];
}

@end
