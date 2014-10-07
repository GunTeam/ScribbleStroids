//
//  Settings.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 8/10/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Settings.h"

double sss = .03;
double mss = .05;
double lss = .08;

@implementation Settings

-(void) didLoadFromCCB{
    //start load background
    int randX = 0;
    int randY = 0;
    while (randX == 0 || randY == 0) {
        randX = arc4random() % 10 - 5;
        randY = arc4random() % 10 - 5;
        
    }
    smallStarSpeedX = randX * sss;
    smallStarSpeedY = randY * sss;
    
    mediumStarSpeedX = randX * mss;
    mediumStarSpeedY = randY * mss;
    
    largeStarSpeedX = randX * lss;
    largeStarSpeedY = randY * lss;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
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
    background.scaleX = 1.25;
    [self addChild:background z:-6];
    //end load background
    
    green = [CCColor colorWithCcColor3b:ccc3(0, 120, 0)];
    red = [CCColor colorWithCcColor3b:ccc3(120, 0, 0)];
    gold = [CCColor colorWithCcColor3b:ccc3(120, 120, 0)];
    
    self.sfx = [[NSUserDefaults standardUserDefaults]boolForKey:@"SFXOn"];
    self.music = [[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"];
    self.tutorial = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"tutorial"];
    
    [self SFXSet];
    [self MusicSet];
    [self TutorialSet];
}

-(void) update:(CCTime)delta{
    //background
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

-(void) SFXToggle {
    self.sfx = !self.sfx;
    [self SFXSet];
}

-(void) SFXSet {
    if (self.sfx) {
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"SFXOn"];
        _SFXToggle.string = @"On";
        _SFXToggle.color = green;
    } else{
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"SFXOn"];
        _SFXToggle.string = @"Off";
        _SFXToggle.color = red;
    }
}

-(void) MusicToggle{
    self.music = !self.music;
    [self MusicSet];
}

-(void) MusicSet{
    if (self.music) {
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"MusicOn"];
        _musicToggle.string = @"On";
        _musicToggle.color = green;
    } else {
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"MusicOn"];
        _musicToggle.string = @"Off";
        _musicToggle.color = red;
    }
}

-(void) TutorialToggle{
    self.tutorial = (self.tutorial +1)%3;
    [self TutorialSet];
}

-(void) TutorialSet {
    if (self.tutorial == 0) {
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"tutorial"];
        _tutorialToggle.color = red;
        _tutorialToggle.string = @"Off";
    } else if (self.tutorial == 1) {
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"tutorial"];
        _tutorialToggle.color = gold;
        _tutorialToggle.string = @"Once";
    } else {
        [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"tutorial"];
        _tutorialToggle.color = green;
        _tutorialToggle.string = @"On";
    }
}

-(void) GoBack {
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:.15];
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
}

@end
