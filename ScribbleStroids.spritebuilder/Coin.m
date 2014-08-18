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
    self.physicsBody.collisionCategories = @[@"coin"];
    self.physicsBody.collisionType = @"coin";
    self.physicsBody.collisionMask = @[@"shield"];
    coinSpin = 0;
    self.wasPickedUp = false;
    fadeTime = 5;
    timePassed = 0;
    [self schedule:@selector(stableState:) interval:1];
}

-(void) stableState:(CCTime)dt{
    if (timePassed < fadeTime) {
        timePassed += 1;
    } else {
        [self removeFromParentAndCleanup:true];
    }
}

-(void) update:(CCTime)dt{
    _coin.scaleX = cos(coinSpin);
    coinSpin+= 1./15.;
}

-(void) onExit {
    [super onExit];
    if (self.wasPickedUp) {
        CoinLabel *plusOne = [CoinLabel labelWithString:[NSString stringWithFormat:@"$%d",self.value] fontName:@"Chalkduster" fontSize:22];
        plusOne.position = self.position;
        plusOne.color = self.labelColor;
        CCAction *rise = [CCActionMoveBy actionWithDuration:.5 position:CGPointMake(0, 20)];
        CCAction *fade = [CCActionFadeOut actionWithDuration:.2];
        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[rise,fade]];
        [self.parent addChild:plusOne];
        [plusOne runAction:sequence];
    }
    CCLOG(@"Coin was destroyed!");
    
    
}

@end
