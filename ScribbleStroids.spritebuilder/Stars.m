//
//  Stars.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/6/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Stars.h"


@implementation Stars

-(void) update:(CCTime) dt {
    if (self.position.x < -80) {
        self.position = CGPointMake(self.position.x + 480, self.position.y);
    } else if (self.position.x > 400) {
        self.position = CGPointMake(self.position.x - 480, self.position.y);
    }
    
    if (self.position.y < -142) {
        self.position = CGPointMake(self.position.x, self.position.y + 852);
    } else if (self.position.y > 710) {
        self.position = CGPointMake(self.position.x, self.position.y - 852);
    }
}

@end
