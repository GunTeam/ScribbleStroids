//
//  Bomb.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/7/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Bomb.h"


@implementation Bomb

-(void) didLoadFromCCB{
    self.physicsBody.collisionType = @"bomb";
    self.physicsBody.collisionGroup = @"AsteroidGroup";
}

@end
