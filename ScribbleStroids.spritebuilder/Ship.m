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
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    fireRate = 0;
    
    self.physicsBody.collisionType = @"ship";
    self.physicsBody.collisionGroup = @"ShipGroup";
//    CCSprite *flames = (CCSprite *)[CCBReader load:@"Flames"];
    animationManager = _flames.userObject;
//    flames.scale = 4;
//    flames.rotation = -90;
//    flames.position = CGPointMake(5, 25);
//    [self addChild:flames z:1];
    [self schedule:@selector(runFlames:) interval:1./3.];
    [self hideFlames];
}

-(void)update:(CCTime)delta{
    
    if (fireRate > 0) {
        self.readyToFire = false;
        fireRate -= self.rateOfFire;
    } else{
        self.readyToFire = true;
    }
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

-(void) hideFlames{
    _flames.visible = false;
}

-(void) showFlames{
    _flames.visible = true;
}

-(void) runFlames:(CCTime)dt{
    [animationManager runAnimationsForSequenceNamed:@"Animation1"];
}

-(void) fire {
    fireRate = 1;
    
    CCLOG(@"Ship has fired");
    CCSprite *bullet = (CCSprite *)[CCBReader load:@"Bullet"];
    bullet.position = self.position;
    bullet.physicsBody.velocity = self.physicsBody.velocity;
    bullet.scale = 2;
    bullet.physicsBody.velocity = self.physicsBody.velocity;
    [self.parent addChild:bullet z:-2];
    [bullet.physicsBody applyImpulse: CGPointMake(bulletLaunchImpulse*cos((self.rotation-90)*M_PI/180),
                                                    bulletLaunchImpulse*-sin((self.rotation-90)*M_PI/180))];
    
}

@end
