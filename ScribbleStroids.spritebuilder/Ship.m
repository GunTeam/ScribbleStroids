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
double shieldDuration;
double shieldTimeCounter;

@implementation Ship

-(void) didLoadFromCCB {
    bulletScale = 1.2;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    fireRate = 0;
    
    
    int shieldLevel = [[NSUserDefaults standardUserDefaults]integerForKey:@"shieldLevel"];
    
    if (shieldLevel == 1) {
        [_greenShield removeFromParent];
        [_orangeShield removeFromParent];
        [_purpleShield removeFromParent];
        [_redShield removeFromParent];
        _shield = _blueShield;
        shieldDuration = 5;
    } else if (shieldLevel == 2) {
        [_blueShield removeFromParent];
        [_orangeShield removeFromParent];
        [_purpleShield removeFromParent];
        [_redShield removeFromParent];
        _shield = _greenShield;
        shieldDuration = 8;
    } else if (shieldLevel == 3) {
        [_greenShield removeFromParent];
        [_blueShield removeFromParent];
        [_purpleShield removeFromParent];
        [_redShield removeFromParent];
        _shield = _orangeShield;
        shieldDuration = 11;
    } else if (shieldLevel == 4) {
        [_greenShield removeFromParent];
        [_orangeShield removeFromParent];
        [_blueShield removeFromParent];
        [_redShield removeFromParent];
        _shield = _purpleShield;
        shieldDuration = 15;
    } else if (shieldLevel == 5) {
        [_greenShield removeFromParent];
        [_orangeShield removeFromParent];
        [_purpleShield removeFromParent];
        [_blueShield removeFromParent];
        _shield = _redShield;
        shieldDuration = 20;
    }
    
    self.physicsBody.collisionType = @"ship";
    self.physicsBody.collisionCategories = @[@"ship"];
    self.physicsBody.collisionMask = @[@"asteroid"];
    _shield.physicsBody.collisionType = @"shield";
    _shield.physicsBody.collisionCategories = @[@"shield"];
    _shield.physicsBody.collisionMask = @[@"coin",@"shield",@"bomb"];
    _shield.visible = false;
    _shield.physicsBody.angularVelocity = 1;
    animationManager = _flames.userObject;
    [self schedule:@selector(runFlames:) interval:1./3.];
    [self hideFlames];
    
    
    self.immune = false;
}

-(void) sustainShield:(CCTime) dt {
    CCLOG(@"Shield is sustained");
    if (shieldTimeCounter < shieldDuration) {
        shieldTimeCounter+=1;
        CCLOG(@"shield time increased by one");
    } else {
        [self unschedule:@selector(sustainShield:)];
        _shield.visible = false;
    }
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
    } else {
        _shield.visible = false;
    }
    

}

-(void) takeDownShield {
    [_greenShield removeFromParent];
    [_orangeShield removeFromParent];
    [_purpleShield removeFromParent];
    [_blueShield removeFromParent];
    [_redShield removeFromParent];
}

-(void) hideFlames{
    _flames.visible = false;
}

-(void) showFlames{
    _flames.visible = true;
}

-(void) dimShield: (double)opacity {
    _shield.opacity = opacity;
}

-(void) brightenShield:(double)opacity {
    _shield.opacity = opacity;
}

-(void) runFlames:(CCTime)dt{
    [animationManager runAnimationsForSequenceNamed:@"Animation1"];
}

-(void) raiseShield {
    _shield.visible = true;
    shieldTimeCounter = 0;
    [self schedule:@selector(sustainShield:) interval:1.];
}

-(void) fire {
}

@end
