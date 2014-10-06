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
    
    if (screenWidth == 768 && screenHeight == 1024) {
        screenWidth = screenWidth/2;
        screenHeight = screenHeight/2;
    }
    
    fireRate = 0;
    
    
    int shieldLevel = [[NSUserDefaults standardUserDefaults]integerForKey:@"shieldLevel"];
    
    if (shieldLevel == 1) {
        [_greenShield removeFromParent];
        [_orangeShield removeFromParent];
        [_purpleShield removeFromParent];
        [_redShield removeFromParent];
        _shield = _blueShield;
        shieldDuration = 1;
    } else if (shieldLevel == 2) {
        [_blueShield removeFromParent];
        [_orangeShield removeFromParent];
        [_purpleShield removeFromParent];
        [_redShield removeFromParent];
        _shield = _greenShield;
        shieldDuration = 2;
    } else if (shieldLevel == 3) {
        [_greenShield removeFromParent];
        [_blueShield removeFromParent];
        [_purpleShield removeFromParent];
        [_redShield removeFromParent];
        _shield = _orangeShield;
        shieldDuration = 3;
    } else if (shieldLevel == 4) {
        [_greenShield removeFromParent];
        [_orangeShield removeFromParent];
        [_blueShield removeFromParent];
        [_redShield removeFromParent];
        _shield = _purpleShield;
        shieldDuration = 4;
    } else if (shieldLevel == 5) {
        [_greenShield removeFromParent];
        [_orangeShield removeFromParent];
        [_purpleShield removeFromParent];
        [_blueShield removeFromParent];
        _shield = _redShield;
        shieldDuration = 5;
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
    
    self.flamesVisible = _flames.visible;
    
    self.immune = false;
    
    self.rateOfFire = 1./20;
    
    shipfiresound =  [OALSimpleAudio sharedInstance];
    thrustsound = [OALSimpleAudio sharedInstance];
    shipdestroyed = [OALSimpleAudio sharedInstance];


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
        self.immune = true;
    } else {
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
    self.flamesVisible = false;
    [self unschedule:@selector(makeThrustSound:)];
    [thrustsound stopAllEffects];
}

-(void) showFlames{
    _flames.visible = true;
    self.flamesVisible = true;
    if (!self.inMain) {
        [self schedule:@selector(makeThrustSound:) interval:1.6 repeat:10 delay:0];
    }
}

-(void) makeThrustSound:(CCTime)dt{
    CCLOG(@"sound made");
    [thrustsound playEffect:@"rocketBlubber.mp3"];
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
    fireRate = 1;
    // access audio object
    // play sound effect
    int effect = arc4random() % 6;
    if (effect == 0) {
        [shipfiresound playEffect:@"pew4.mp3"];
    } else if (effect == 1){
        [shipfiresound playEffect:@"ping1.mp3"];
    }else if (effect == 2){
        [shipfiresound playEffect:@"pew3.mp3"];
    } else if (effect == 3) {
        [shipfiresound playEffect:@"pew5.mp3"];
    } else if (effect == 4){
        [shipfiresound playEffect:@"pew6.mp3"];
    } else {
        [shipfiresound playEffect:@"ping2.mp3"];
    }
}

-(void) onExit {
    [super onExit];
//    [[OALSimpleAudio sharedInstance] playEffect:@"shipAsteroid.mp3"];
}

@end
