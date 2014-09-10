//
//  CoinLabel.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CoinLabel.h"

@implementation CoinLabel

-(void) update:(CCTime)delta{
    if (self.opacity == 0) {
        [self removeFromParentAndCleanup:true];
    }
}

@end
