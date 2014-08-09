//
//  Ship.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/28/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Ship.h"

double bulletLaunchImpulse = 3;
double crashShieldTime = 5;
double touchShieldTime = 5;

@implementation Ship

-(void) didLoadFromCCB {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    fireRate = 0;
    
    self.physicsBody.collisionType = @"ship";
    self.physicsBody.collisionGroup = @"ShipGroup";
    _shield.physicsBody.collisionType = @"shield";
    _shield.physicsBody.collisionGroup = @"ShipGroup";
    _shield.visible = false;
    _shield.physicsBody.angularVelocity = 1;
    animationManager = _flames.userObject;
    [self schedule:@selector(runFlames:) interval:1./3.];
    [self hideFlames];
    
    self.immune = false;
}

-(void)update:(CCTime)delta{
    _shield.position = CGPointMake(.46, .45);
    if (fireRate > 0) {
        self.readyToFire = false;
        fireRate -= self.rateOfFire;
    } else{
        self.readyToFire = true;
    }
    if (_shield.visible) {
        _shield.physicsBody.density = 5;
        self.immune = true;
    } else {
        _shield.physicsBody.density = .01;
        self.immune = false;
    }
    if (!self.inMain) {
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

-(void) shieldUp:(CCTime)dt{
    _shield.visible = true;
    CCAction *delay = [CCActionDelay actionWithDuration:crashShieldTime];
    CCAction *toggle = [CCActionToggleVisibility action];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay,toggle]];
    [_shield runAction:sequence];
}

-(void) touchShield {
    _shield.visible = true;
    CCAction *delay = [CCActionDelay actionWithDuration:touchShieldTime];
    CCAction *toggle = [CCActionToggleVisibility action];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay,toggle]];
    [_shield runAction:sequence];
}

-(void) fire {
    fireRate = 1;
    
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
