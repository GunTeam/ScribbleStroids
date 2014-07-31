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
//    CCSprite *flames = (CCSprite *)[CCBReader load:@"Flames"];
    animationManager = _flames.userObject;
//    flames.scale = 4;
//    flames.rotation = -90;
//    flames.position = CGPointMake(5, 25);
//    [self addChild:flames z:1];
    [self schedule:@selector(runFlames:) interval:1./3.];
    [self hideFlames];
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
    CCLOG(@"Ship has fired");
    CCSprite *bullet = (CCSprite *)[CCBReader load:@"Bullet"];
    bullet.position = self.position;
    bullet.physicsBody.velocity = self.physicsBody.velocity;
    
    bullet.physicsBody.velocity = self.physicsBody.velocity;
    [self.parent addChild:bullet];
    [bullet.physicsBody applyImpulse: CGPointMake(bulletLaunchImpulse*cos((self.rotation-90)*M_PI/180),
                                                    bulletLaunchImpulse*-sin((self.rotation-90)*M_PI/180))];
    
}

@end
