//
//  Store.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/10/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Store.h"

double jorrie = .03;
double adam = .05;
double lexi = .08;

@implementation Store

-(void) didLoadFromCCB{
    int randX = 0;
    int randY = 0;
    while (randX == 0 || randY == 0) {
        randX = arc4random() % 10 - 5;
        randY = arc4random() % 10 - 5;
        
    }
    smallStarSpeedX = randX * jorrie;
    smallStarSpeedY = randY * jorrie;
    
    mediumStarSpeedX = randX * adam;
    mediumStarSpeedY = randY * adam;
    
    largeStarSpeedX = randX * lexi;
    largeStarSpeedY = randY * lexi;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    //start load background
    smallStarsArray = [[NSMutableArray alloc]init];
    mediumStarsArray = [[NSMutableArray alloc]init];
    largeStarsArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 2; i++) {
        for (int j = 0; j <= 2; j++) {
            
            Stars *small = (Stars *)[CCBReader load:@"SmallStars"];
            small.position = CGPointMake(i*160, j*284);
            [self addChild:small z:-5];
            [smallStarsArray addObject:small];
            
            Stars *medium = (Stars *) [CCBReader load:@"MediumStars"];
            medium.position = CGPointMake(i*160, j*284);
            [self addChild:medium z:-5];
            [mediumStarsArray addObject:medium];
            
            Stars *large = (Stars *) [CCBReader load:@"LargeStars"];
            large.position = CGPointMake(i*160, j*284);
            [self addChild:large z:-5];
            [largeStarsArray addObject:large];
            
        }
    }
    
    CCSprite *background = (CCSprite *)[CCBReader load:@"Background"];
    [self addChild:background z:-6];
    //end load background
    
}

-(void) update:(CCTime)delta{
    for (Stars *star in smallStarsArray) {
        star.position = CGPointMake(star.position.x - smallStarSpeedX,star.position.y - smallStarSpeedY);
    }
    for (Stars *star in mediumStarsArray) {
        star.position = CGPointMake(star.position.x - mediumStarSpeedX,star.position.y - mediumStarSpeedY);
    }
    for (Stars *star in largeStarsArray) {
        star.position = CGPointMake(star.position.x - largeStarSpeedX,star.position.y - largeStarSpeedY);
    }
}

-(void) GoBack {
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
}

@end
