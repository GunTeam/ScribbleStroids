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
    
    self.shipCost = [[NSUserDefaults standardUserDefaults]integerForKey:@"shipCost"];
    self.gunCost = [[NSUserDefaults standardUserDefaults]integerForKey:@"gunCost"];
    self.shieldCost = [[NSUserDefaults standardUserDefaults]integerForKey:@"shieldGun"];
    
    bankRoll = 1000000/*[[NSUserDefaults standardUserDefaults]integerForKey:@"bank"]*/;
    _bankLabel.string = [NSString stringWithFormat:@"$%d",bankRoll];
    
    [self shieldAttributes:[[NSUserDefaults standardUserDefaults]integerForKey:@"shieldLevel"]];
    
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

-(void) UpgradeShip {
    if (bankRoll >= self.shipCost) {
        //set the new ship attributes
        
    }
}

-(void) UpgradeGun {
    if (bankRoll >= self.gunCost) {
        bankRoll -= self.gunCost;
        [[NSUserDefaults standardUserDefaults]setInteger:bankRoll forKey:@"bank"];
        _bankLabel.string = [NSString stringWithFormat:@"$%d",bankRoll];
        //change the gun to match which one the player just bought
        //change the button to match the next cost of the gun
    }
}

-(void) UpgradeShield {
    if (bankRoll >= self.shieldCost) {
        bankRoll -= self.shieldCost;
        [[NSUserDefaults standardUserDefaults]setInteger:bankRoll forKey:@"bank"];
        _bankLabel.string = [NSString stringWithFormat:@"$%d",bankRoll];
        [[NSUserDefaults standardUserDefaults]setInteger:([[NSUserDefaults standardUserDefaults]integerForKey:@"shieldLevel"]+1) forKey:@"shieldLevel"];
        [self shieldAttributes:[[NSUserDefaults standardUserDefaults]integerForKey:@"shieldLevel"]];
    }
}

-(void) shipAttributes:(int)level {
    
}

-(void) gunAttributes:(int)level {
    
}

-(void) shieldAttributes:(int)level {
    if (level==1) {
        _blueShield.visible = true;
        _greenShield.visible = false;
        _orangeShield.visible = false;
        _purpleShield.visible = false;
        _redShield.visible = false;
        self.shieldCost = 100;
        _shieldButton.title = [NSString stringWithFormat:@"$%d",self.shieldCost];
    } else if (level==2){
        _blueShield.visible = false;
        _greenShield.visible = true;
        _orangeShield.visible = false;
        _purpleShield.visible = false;
        _redShield.visible = false;
        self.shieldCost = 500;
        _shieldButton.title = [NSString stringWithFormat:@"$%d",self.shieldCost];
    } else if (level==3){
        _blueShield.visible = false;
        _greenShield.visible = false;
        _orangeShield.visible = true;
        _purpleShield.visible = false;
        _redShield.visible = false;
        self.shieldCost = 1000;
        _shieldButton.title = [NSString stringWithFormat:@"$%d",self.shieldCost];
    } else if (level==4){
        _blueShield.visible = false;
        _greenShield.visible = false;
        _orangeShield.visible = false;
        _purpleShield.visible = true;
        _redShield.visible = false;
        self.shieldCost = 5000;
        _shieldButton.title = [NSString stringWithFormat:@"$%d",self.shieldCost];
    } else if (level==5) {
        _blueShield.visible = false;
        _greenShield.visible = false;
        _orangeShield.visible = false;
        _purpleShield.visible = false;
        _redShield.visible = true;
        self.shieldCost = 999999999;
        _shieldButton.title = @"MAX";
        _shieldButton.enabled = false;
    }
}

@end
