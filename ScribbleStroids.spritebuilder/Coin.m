//
//  Coin.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/10/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Coin.h"

@implementation Coin

-(void) didLoadFromCCB {
    //custom init stuff here
//    self.physicsBody.collisionGroup = @"AsteroidGroup";
    self.physicsBody.collisionCategories = @[@"coin"];
    self.physicsBody.collisionType = @"coin";
    self.physicsBody.collisionMask = @[@"shield"];
    coinSpin = 0;
}

-(void) update:(CCTime)dt{
    _coin.scaleX = cos(coinSpin);
    coinSpin+= 1./15.;
}

@end
