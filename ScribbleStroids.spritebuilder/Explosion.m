//
//  Explosion.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Explosion.h"


@implementation Explosion

-(void) didLoadFromCCB{
//    [self.userObject runAnimationsForSequenceNamed:@"Explosion"];
    timer = 0;
    self.scale = .1;
    [self.userObject runAnimationsForSequenceNamed:@"Animation"];
}

-(void) update:(CCTime)delta{
    timer +=1;
    self.scale+=.04;
    if (timer>7) {
        [self removeFromParent];
    }
}

@end
