//
//  GameScene.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

-(void) didLoadFromCCB {
    mainShip = (CCSprite *) [CCBReader load:@"Ship"];
    mainShip.position = CGPointMake(100, 100);
    mainShip.scale = .2;
    [self addChild:mainShip];
}

-(void) TurnLeft{
    CCLOG(@"Left Button Pressed");
}

-(void) TurnRight{
    
    CCLOG(@"Right Button Pressed");
}

-(void) Boost{
    CCLOG(@"Boost Button Pressed");
}

-(void) Shoot{
    CCLOG(@"Shoot Button Pressed");
}

@end
