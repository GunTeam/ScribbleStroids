//
//  MainScene.m
//  Scribble 'Stroids
//
//  Created by Jorrie Brettin on 8/01/2014.
//  Copyright (c) 2014 Jorrie Brettin. All rights reserved.
//

#import "MainScene.h"
#import "GameScene.h"
#import "Store.h"
#import <iAd/iAd.h>

#define k_Save @"SaveItem"

double SSS = .03;
double MSS = .05;
double LSS = .08;

@implementation MainScene

//iAd codes
-(id)init
{
    bool adsRemoved =[[NSUserDefaults standardUserDefaults]boolForKey:@"removeiAds"];
    
    if( (self= [super init]) )
    {
        // On iOS 6 ADBannerView introduces a new initializer, use it when available.
        if (!adsRemoved){
            if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
                _adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
                
            } else {
                _adView = [[ADBannerView alloc] init];
            }
            _adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
            _adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
            [[[CCDirector sharedDirector]view]addSubview:_adView];
            [_adView setBackgroundColor:[UIColor clearColor]];
            [[[CCDirector sharedDirector]view]addSubview:_adView];
            _adView.delegate = self;
        }
    }
    if (!adsRemoved) {
        [self layoutAnimated:YES];
    }
    return self;
}


- (void)layoutAnimated:(BOOL)animated
{
    // As of iOS 6.0, the banner will automatically resize itself based on its width.
    // To support iOS 5.0 however, we continue to set the currentContentSizeIdentifier appropriately.
    CGRect contentFrame = [CCDirector sharedDirector].view.bounds;
    _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        contentFrame.size.height -= _bannerView.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        _bannerView.frame = bannerFrame;
    }];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    bool adsRemoved =[[NSUserDefaults standardUserDefaults]boolForKey:@"removeiAds"];
    if (!adsRemoved) {
        [self layoutAnimated:YES];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    bool adsRemoved =[[NSUserDefaults standardUserDefaults]boolForKey:@"removeiAds"];
    if (!adsRemoved) {
        [self layoutAnimated:YES];
    }
}

//end iAd codes

-(void) didLoadFromCCB{
    
    [[OALSimpleAudio sharedInstance]setEffectsMuted:true];
    
    //set defaults for first time users
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"returningUser"]) {
        CCLOG(@"set new defaults");
        //game defaults
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"returningUser"];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"tutorial"];
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"SFXOn"];
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"MusicOn"];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"bank"];
        
        //set ship, gun, and shield levels
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"shipLevel"];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"gunLevel"];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"shieldLevel"];
        
        //display stats
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"highScore"];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"highestLevel"];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"asteroidsDestroyed"];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"deaths"];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"bulletsFired"];
        
        //inapp purchase
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"removeiAds"];
    }
    
    //start load background
    int randX = 0;
    int randY = 0;
    while (randX == 0 || randY == 0) {
        randX = arc4random() % 10 - 5;
        randY = arc4random() % 10 - 5;
        
    }
    smallStarSpeedX = randX * SSS;
    smallStarSpeedY = randY * SSS;

    mediumStarSpeedX = randX * MSS;
    mediumStarSpeedY = randY * MSS;
    
    largeStarSpeedX = randX * LSS;
    largeStarSpeedY = randY * LSS;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    if (screenWidth == 768 && screenHeight == 1024) {
        screenWidth = screenWidth/2;
        screenHeight = screenHeight/2;
    }
    
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
    
    ship = (Ship *) [CCBReader load:@"Ship"];
    ship.position = CGPointMake(-45, 0);
    ship.inMain = true;
    [ship showFlames];
    [ship takeDownShield];
    [self addChild:ship z:-1];
    
    int event = arc4random() % 6;
    [self runAnimation:event];
    
    [self schedule:@selector(randomEvent:) interval:6];
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"Main"]) {
        _scoreLabel.string = [NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults]integerForKey:@"score"]];
        _scoreLabel.visible = true;
        _gameOverLabel.visible = true;
        _titleLabel.visible = false;

        
    } else{
        _scoreLabel.visible = false;
        _gameOverLabel.visible = false;
        _titleLabel.visible = true;
    }
    
}

-(void) onEnter {
    [super onEnter];
    bool adsRemoved =[[NSUserDefaults standardUserDefaults]boolForKey:@"removeiAds"];
    if (adsRemoved) {
        [_adView setHidden:true];
    }
}

-(void) randomEvent:(CCTime) dt{
    int event = arc4random() % 6;
    [self runAnimation:event];
}

-(void) Play{
    [_adView setHidden:true];
    
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:.15];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameScene"] withTransition:transition];
}

-(void) ToHighscores{
    CCLOG(@"Highscores");
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"HighScoreScene"] withTransition:transition];
}

-(void) ToStore{
    CCLOG(@"store");
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:.1];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"Store"] withTransition:transition];
}

-(void) ToSettings{
    CCLOG(@"Settings");
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.15];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"Settings"] withTransition:transition];
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

-(void) runAnimation: (int) animation {
    if (animation == 0) {
        ship.position = CGPointMake(-30, screenHeight/5);
        ship.rotation = 79;
        CCActionMoveTo *move = [CCActionMoveTo actionWithDuration:2. position:CGPointMake(screenWidth + 45, screenHeight/ 3)];
        [ship runAction:move];
    } else if (animation == 1) {
        ship.position = CGPointMake(screenWidth+45, screenHeight/3);
        ship.rotation = -62;
        CCActionMoveTo *move = [CCActionMoveTo actionWithDuration:2. position:CGPointMake(-45, screenHeight*2/3)];
        [ship runAction:move];
    } else if (animation == 2) {
        ship.position = CGPointMake(screenWidth/3, screenHeight+45);
        ship.rotation = 170;
        CCActionMoveTo *move = [CCActionMoveTo actionWithDuration:2.8 position:CGPointMake(screenWidth*2/3, -45)];
        [ship runAction:move];
    } else if (animation == 3) {
        ship.position = CGPointMake(-300, -300);
        ship.rotation = 38;
        CCActionMoveTo *moveShip = [CCActionMoveTo actionWithDuration:4 position:CGPointMake(screenWidth + 60, screenHeight +75)];
        [ship runAction:moveShip];
        Asteroid *asteroid = (Asteroid *) [CCBReader load:@"AsteroidLarge"];
        asteroid.isMain = true;
        asteroid.position = CGPointMake(-45, -45);
        [self addChild:asteroid z:-1];
        CCActionMoveTo *moveAsteroid = [CCActionMoveTo actionWithDuration:2.8 position:CGPointMake(screenWidth + 60, screenHeight +75)];
        [asteroid runAction:moveAsteroid];
    } else if (animation == 4) {
        ship.position = CGPointMake(0, screenHeight + 45);
        ship.rotation = 168;
        CCActionMoveTo *moveShip = [CCActionMoveTo actionWithDuration:3 position:CGPointMake(screenWidth/2, -45)];
        [ship runAction:moveShip];
        Asteroid *asteroid1 = (Asteroid *) [CCBReader load:@"AsteroidMedium"];
        Asteroid *asteroid2 = (Asteroid *) [CCBReader load:@"AsteroidMedium"];
        asteroid1.isMain = true;
        asteroid2.isMain = true;
        asteroid1.position = CGPointMake(30, screenHeight+150);
        asteroid2.position = CGPointMake(-10, screenHeight+130);
        CCActionMoveTo *moveAsteroid1 = [CCActionMoveTo actionWithDuration:4.5 position:CGPointMake(screenWidth/4, -45)];
        CCActionMoveTo *moveAsteroid2 = [CCActionMoveTo actionWithDuration:4. position:CGPointMake(screenWidth*2/3, -45)];
        [self addChild:asteroid1 z:-1];
        [self addChild:asteroid2 z:-1];
        [asteroid1 runAction:moveAsteroid1];
        [asteroid2 runAction:moveAsteroid2];
    } else if (animation == 5) {
        Asteroid *asteroid1 = (Asteroid *) [CCBReader load:@"AsteroidSmall"];
        Asteroid *asteroid2 = (Asteroid *) [CCBReader load:@"AsteroidSmall"];
        Asteroid *asteroid3 = (Asteroid *) [CCBReader load:@"AsteroidSmall"];
        asteroid1.position = CGPointMake(-45, screenHeight*2/3);
        asteroid2.position = CGPointMake(-45, screenHeight/2);
        asteroid3.position = CGPointMake(-45, screenHeight*3/7);
        asteroid1.isMain = true;
        asteroid2.isMain = true;
        asteroid3.isMain = true;
        CCActionMoveTo *moveAsteroid1 = [CCActionMoveTo actionWithDuration:4.5 position:CGPointMake(screenWidth + 45, screenHeight/2)];
        CCActionMoveTo *moveAsteroid2 = [CCActionMoveTo actionWithDuration:3.5 position:CGPointMake(screenWidth + 45, screenHeight/4)];
        CCActionMoveTo *moveAsteroid3 = [CCActionMoveTo actionWithDuration:4 position:CGPointMake(screenWidth + 45, screenHeight*4/5)];
        [self addChild:asteroid1 z:-1];
        [self addChild:asteroid2 z:-1];
        [self addChild:asteroid3 z:-1];
        [asteroid1 runAction:moveAsteroid1];
        [asteroid2 runAction:moveAsteroid2];
        [asteroid3 runAction:moveAsteroid3];
    }
}






@end
