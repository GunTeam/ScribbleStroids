//
//  Level5.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/14/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Level5.h"


@implementation Level5

-(void) didLoadFromCCB{
    [super didLoadFromCCB];
//    self.rateOfFire = 1./8.;
}

-(void) fire {
    fireRate = 1;
    int bulletLaunchImpulse = 3;
    int positionBoost = 17;
    int topBoost = 25;
    
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
    bullet3.position = CGPointMake(self.position.x + topBoost*sin(self.rotation*M_PI/180), self.position.y + topBoost*cos(self.rotation*M_PI/180));
    bullet3.physicsBody.velocity = self.physicsBody.velocity;
    bullet3.scale = bulletScale;
    [self.parent addChild:bullet3 z:-2];
    [bullet3.physicsBody applyImpulse: CGPointMake(bulletLaunchImpulse*cos((self.rotation-90)*M_PI/180),
                                                   bulletLaunchImpulse*-sin((self.rotation-90)*M_PI/180))];
    
    CCSprite *bullet4 = (CCSprite *)[CCBReader load:@"Bullet"];
    bullet4.position = CGPointMake(self.position.x, self.position.y);
    bullet4.physicsBody.velocity = CGPointMake(-self.physicsBody.velocity.x,-self.physicsBody.velocity.y);
    bullet4.scale = bulletScale;
    [self.parent addChild:bullet4 z:-2];
    [bullet4.physicsBody applyImpulse: CGPointMake(-bulletLaunchImpulse*cos((self.rotation-90)*M_PI/180),
                                                   bulletLaunchImpulse*sin((self.rotation-90)*M_PI/180))];
    
    CCSprite *bullet5 = (CCSprite *)[CCBReader load:@"Bullet"];
    bullet5.position = CGPointMake(self.position.x, self.position.y);
    bullet5.physicsBody.velocity = CGPointMake(self.physicsBody.velocity.x,self.physicsBody.velocity.y);
    bullet5.scale = bulletScale;
    [self.parent addChild:bullet5 z:-2];
    [bullet5.physicsBody applyImpulse: CGPointMake(bulletLaunchImpulse*cos((self.rotation-75)*M_PI/180),
                                                   -bulletLaunchImpulse*sin((self.rotation-75)*M_PI/180))];
    
    CCSprite *bullet6= (CCSprite *)[CCBReader load:@"Bullet"];
    bullet6.position = CGPointMake(self.position.x, self.position.y);
    bullet6.physicsBody.velocity = CGPointMake(self.physicsBody.velocity.x,self.physicsBody.velocity.y);
    bullet6.scale = bulletScale;
    [self.parent addChild:bullet6 z:-2];
    [bullet6.physicsBody applyImpulse: CGPointMake(bulletLaunchImpulse*cos((self.rotation-105)*M_PI/180),
                                                   -bulletLaunchImpulse*sin((self.rotation-105)*M_PI/180))];
    
    
}

@end
