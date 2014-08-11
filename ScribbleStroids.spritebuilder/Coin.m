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

-(void) onExit {
    [super onExit];
    CCLOG(@"Coin was destroyed!");
    CoinLabel *plusOne = [CoinLabel labelWithString:[NSString stringWithFormat:@"$%d",self.value] fontName:@"Chalkduster" fontSize:22];
    plusOne.position = self.position;
    plusOne.color = self.labelColor;
    CCAction *rise = [CCActionMoveBy actionWithDuration:.5 position:CGPointMake(0, 20)];
    CCAction *fade = [CCActionFadeOut actionWithDuration:.2];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[rise,fade]];
    [self.parent addChild:plusOne];
    [plusOne runAction:sequence];
    
}

@end
