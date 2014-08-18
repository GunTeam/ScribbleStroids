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
        
    self.shipCost = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"shipCost"];
    self.gunCost = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"gunCost"];
    self.shieldCost = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"shieldGun"];
    
    bankRoll = [[NSUserDefaults standardUserDefaults]integerForKey:@"bank"];
    _bankLabel.string = [NSString stringWithFormat:@"$%d",bankRoll];
    
//    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"shipLevel"];
//    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"gunLevel"];
//    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"shieldLevel"];
    
    [self shipAttributes:(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"shipLevel"]];
    [self gunAttributes:(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"gunLevel"]];
    [self shieldAttributes:((int)[[NSUserDefaults standardUserDefaults]integerForKey:@"shieldLevel"])];
    
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
        bankRoll -= self.shipCost;
        [[NSUserDefaults standardUserDefaults]setInteger:bankRoll forKey:@"bank"];
        _bankLabel.string = [NSString stringWithFormat:@"$%d",bankRoll];
        [[NSUserDefaults standardUserDefaults]setInteger:([[NSUserDefaults standardUserDefaults]integerForKey:@"shipLevel"]+1) forKey:@"shipLevel"];
        [self shipAttributes:((int)[[NSUserDefaults standardUserDefaults]integerForKey:@"shipLevel"])];
    }
}

-(void) UpgradeGun {
    if (bankRoll >= self.gunCost) {
        bankRoll -= self.gunCost;
        [[NSUserDefaults standardUserDefaults]setInteger:bankRoll forKey:@"bank"];
        _bankLabel.string = [NSString stringWithFormat:@"$%d",bankRoll];
        [[NSUserDefaults standardUserDefaults]setInteger:([[NSUserDefaults standardUserDefaults]integerForKey:@"gunLevel"]+1) forKey:@"gunLevel"];
        [self gunAttributes:((int)[[NSUserDefaults standardUserDefaults]integerForKey:@"gunLevel"])];
    }
}

-(void) UpgradeShield {
    if (bankRoll >= self.shieldCost) {
        bankRoll -= self.shieldCost;
        [[NSUserDefaults standardUserDefaults]setInteger:bankRoll forKey:@"bank"];
        _bankLabel.string = [NSString stringWithFormat:@"$%d",bankRoll];
        [[NSUserDefaults standardUserDefaults]setInteger:([[NSUserDefaults standardUserDefaults]integerForKey:@"shieldLevel"]+1) forKey:@"shieldLevel"];
        [self shieldAttributes:((int)[[NSUserDefaults standardUserDefaults]integerForKey:@"shieldLevel"])];
    }
}

-(void) shipAttributes:(int)level {
    if (level == 1) {
        _heart1.visible = true;
        _heart2.visible = false;
        _heart3.visible = false;
        _heart4.visible = false;
        _heart5.visible = false;
        self.shipCost = 250;
        _shipButton.title = [NSString stringWithFormat:@"$%d",self.shipCost];
    } else if (level == 2) {
        _heart1.visible = true;
        _heart2.visible = true;
        _heart3.visible = false;
        _heart4.visible = false;
        _heart5.visible = false;
        self.shipCost = 1000;
        _shipButton.title = [NSString stringWithFormat:@"$%d",self.shipCost];
    } else if (level == 3) {
        _heart1.visible = true;
        _heart2.visible = true;
        _heart3.visible = true;
        _heart4.visible = false;
        _heart5.visible = false;
        self.shipCost = 5000;
        _shipButton.title = [NSString stringWithFormat:@"$%d",self.shipCost];
    } else if (level == 4) {
        _heart1.visible = true;
        _heart2.visible = true;
        _heart3.visible = true;
        _heart4.visible = true;
        _heart5.visible = false;
        self.shipCost = 10000;
        _shipButton.title = [NSString stringWithFormat:@"$%d",self.shipCost];
    } else if (level == 5){
        _heart1.visible = true;
        _heart2.visible = true;
        _heart3.visible = true;
        _heart4.visible = true;
        _heart5.visible = true;
        _shipButton.title = @"MAX";
        _shipButton.enabled = false;
    }
}

-(void) gunAttributes:(int)level {
    if (level == 1) {
        _Level1.visible = true;
        _Level2.visible = false;
        _Level3.visible = false;
        _Level4.visible = false;
        _Level5.visible = false;
        _star1.visible = true;
        _star2.visible = false;
        _star3.visible = false;
        _star4.visible = false;
        _star5.visible = false;
        self.gunCost = 250;
        _gunButton.title = [NSString stringWithFormat:@"$%d",self.gunCost];
    } else if (level == 2) {
        _Level1.visible = false;
        _Level2.visible = true;
        _Level3.visible = false;
        _Level4.visible = false;
        _Level5.visible = false;
        _star1.visible = true;
        _star2.visible = true;
        _star3.visible = false;
        _star4.visible = false;
        _star5.visible = false;
        self.gunCost = 1000;
        _gunButton.title = [NSString stringWithFormat:@"$%d",self.gunCost];
    } else if (level == 3) {
        _Level1.visible = false;
        _Level2.visible = false;
        _Level3.visible = true;
        _Level4.visible = false;
        _Level5.visible = false;
        _star1.visible = true;
        _star2.visible = true;
        _star3.visible = true;
        _star4.visible = false;
        _star5.visible = false;
        self.gunCost = 5000;
        _gunButton.title = [NSString stringWithFormat:@"$%d",self.gunCost];
    } else if (level == 4) {
        _Level1.visible = false;
        _Level2.visible = false;
        _Level3.visible = false;
        _Level4.visible = true;
        _Level5.visible = false;
        _star1.visible = true;
        _star2.visible = true;
        _star3.visible = true;
        _star4.visible = true;
        _star5.visible = false;
        self.gunCost = 10000;
        _gunButton.title = [NSString stringWithFormat:@"$%d",self.gunCost];
    } else if (level == 5) {
        _Level1.visible = false;
        _Level2.visible = false;
        _Level3.visible = false;
        _Level4.visible = false;
        _Level5.visible = true;
        _star1.visible = true;
        _star2.visible = true;
        _star3.visible = true;
        _star4.visible = true;
        _star5.visible = true;
        _gunButton.title = @"MAX";
        _gunButton.enabled = false;
    }
    
}

-(void) shieldAttributes:(int)level {
    if (level==1) {
        _blueShield.visible = true;
        _greenShield.visible = false;
        _orangeShield.visible = false;
        _purpleShield.visible = false;
        _redShield.visible = false;
        _clock1.visible = true;
        _clock2.visible = false;
        _clock3.visible = false;
        _clock4.visible = false;
        _clock5.visible = false;
        self.shieldCost = 100;
        _shieldButton.title = [NSString stringWithFormat:@"$%d",self.shieldCost];
    } else if (level==2){
        _blueShield.visible = false;
        _greenShield.visible = true;
        _orangeShield.visible = false;
        _purpleShield.visible = false;
        _redShield.visible = false;
        _clock1.visible = true;
        _clock2.visible = true;
        _clock3.visible = false;
        _clock4.visible = false;
        _clock5.visible = false;
        self.shieldCost = 500;
        _shieldButton.title = [NSString stringWithFormat:@"$%d",self.shieldCost];
    } else if (level==3){
        _blueShield.visible = false;
        _greenShield.visible = false;
        _orangeShield.visible = true;
        _purpleShield.visible = false;
        _redShield.visible = false;
        _clock1.visible = true;
        _clock2.visible = true;
        _clock3.visible = true;
        _clock4.visible = false;
        _clock5.visible = false;
        self.shieldCost = 1000;
        _shieldButton.title = [NSString stringWithFormat:@"$%d",self.shieldCost];
    } else if (level==4){
        _blueShield.visible = false;
        _greenShield.visible = false;
        _orangeShield.visible = false;
        _purpleShield.visible = true;
        _redShield.visible = false;
        _clock1.visible = true;
        _clock2.visible = true;
        _clock3.visible = true;
        _clock4.visible = true;
        _clock5.visible = false;
        self.shieldCost = 5000;
        _shieldButton.title = [NSString stringWithFormat:@"$%d",self.shieldCost];
    } else if (level==5) {
        _blueShield.visible = false;
        _greenShield.visible = false;
        _orangeShield.visible = false;
        _purpleShield.visible = false;
        _redShield.visible = true;
        _clock1.visible = true;
        _clock2.visible = true;
        _clock3.visible = true;
        _clock4.visible = true;
        _clock5.visible = true;
        _shieldButton.title = @"MAX";
        _shieldButton.enabled = false;
    }
}

@end
