//
//  GameScene.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameScene.h"

double missileLaunchImpulse = 3;
double shipThrust = 8;
double shipDampening = .97;
int smallSpeedIncrease = 80;
int mediumSpeedIncrease = 120;
int initialAsteroidVelocity = 60;
bool debugMode = false;
double joystickTouchThreshold = 90;
double shipTouchThreshold = 50;
int numberOfLives = 2;
int startLevel = 30;
int bulletExplosionSpeed = 90;
int startingNumberOfBombs = 1;
double howOftenPowerupDropsAreMade = 60;
int bombLimit = 5;      
double coinFlipper = 0;

double smallStarSpeed = .0006;
double mediumStarSpeed = .001;
double largeStarSpeed = .0016;

@implementation GameScene

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if (self.tutorial) {
        tutorialStep += 1;
        [self tutorial:tutorialStep];
    } else if (!self.paused) {
        mainShip.physicsBody.angularVelocity = 0;
        CGPoint touchLocation = [touch locationInNode:self];
        double hypotenuse = pow(pow(touchLocation.x - screenWidth*(_joystickCenter.position.x),2) + pow(touchLocation.y - screenHeight*(_joystickCenter.position.y), 2),.5);
        if (hypotenuse<joystickTouchThreshold) {
            CGFloat point = -atan2((-_joystickCenter.position.y*screenHeight+touchLocation.y),(-_joystickCenter.position.x*screenWidth+touchLocation.x))*180/M_PI+90;
            mainShip.rotation = point;
            _joystickArrow.rotation = point;
        } else if (touchLocation.y > 100 && touchLocation.y < (screenHeight - 50)){
            if (self.numShields > 0){
                [mainShip raiseShield];
                self.numShields -=1;
                [self removeChildByName:[NSString stringWithFormat:@"shield%d",self.numShields]];
            }
        }
    }
}
-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    if (!self.paused) {
        mainShip.physicsBody.angularVelocity = 0;
        CGPoint touchLocation = [touch locationInNode:self];
        double hypotenuse = pow(pow(touchLocation.x - screenWidth*(_joystickCenter.position.x),2) + pow(touchLocation.y - screenHeight*(_joystickCenter.position.y), 2),.5);
        if (hypotenuse<joystickTouchThreshold) {
            CGFloat point = -atan2((-_joystickCenter.position.y*screenHeight+touchLocation.y),(-_joystickCenter.position.x*screenWidth+touchLocation.x))*180/M_PI+90;
            mainShip.rotation = point;
            _joystickArrow.rotation = point;
            
        }
    }
}

-(void) didLoadFromCCB {
    
    [[OALSimpleAudio sharedInstance]setEffectsMuted:![[NSUserDefaults standardUserDefaults]boolForKey:@"SFXOn"]];
    
    //stats variables
    asteroidsDestroyed = 0;
    numDeaths = 0;
    bulletsFired = 0;
    coinsCollected = 0;
    
    
    
    [[OALSimpleAudio sharedInstance]setEffectsMuted:![[NSUserDefaults standardUserDefaults]boolForKey:@"SFXOn"]];
    
    shipDestroyed = [OALSimpleAudio sharedInstance];
    
    
    [[CCDirector sharedDirector] setDisplayStats:false];
    
    //start load background
    smallStarsArray = [[NSMutableArray alloc]init];
    mediumStarsArray = [[NSMutableArray alloc]init];
    largeStarsArray = [[NSMutableArray alloc]init];
    asteroidArray = [[NSMutableArray alloc]init];
    
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
    [self addChild:background z:-2];
    //end load background
    
    self.userInteractionEnabled = true;
    self.multipleTouchEnabled =true;
    
    self.level = startLevel;
    
    self.score = 0;
    
    [[[CCDirector sharedDirector] view] setMultipleTouchEnabled:YES];
    _boostButton.exclusiveTouch = false;
    _shootButton.exclusiveTouch = false;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        screenWidth = screenWidth/2;
        screenHeight = screenHeight/2;
    }
    
    //add the physics node behind the gamescene buttons
    _physicsNode = [[CCPhysicsNode alloc]init];
    [self addChild:_physicsNode z:-1];
    
    _physicsNode.collisionDelegate = self;
    
    //labels
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Chalkduster" fontSize:18];
    scoreLabel.anchorPoint = CGPointMake(0, 1);
    scoreLabel.position = CGPointMake(0, screenHeight);
    [self addChild:scoreLabel];
    levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"$%d",self.bankRoll] fontName:@"Chalkduster" fontSize:18];
    levelLabel.color = [CCColor colorWithCcColor3b:ccc3(239, 215, 9)];
    levelLabel.anchorPoint = CGPointMake(1, 1);
    levelLabel.position = CGPointMake(screenWidth, screenHeight);
    [self addChild:levelLabel];
    //end labels
    self.lives = (int)([[NSUserDefaults standardUserDefaults]integerForKey:@"shipLevel"]);
    [self displayNumberOfLives:self.lives];
        
    self.numShields = 1;
    [self displayNumberOfShields:1];
    
    //start pause menu
    self.paused = false;
    _pauseMenu.visible = false;
    _settingsButton.visible = false;
    _storeButton.visible = false;
    _pauseBankLabel.visible = false;
    _pauseBankBalance.visible = false;
    _extraLifeCostLabel.visible = false;
    _extraNukeCostLabel.visible = false;
    _buyLife.visible = false;
    _buyShield.visible = false;
    self.extraLifeCost = 100;
    self.extraShieldCost = 50;
    //end pause menu
    
    _extraLifeCostLabel.string = [NSString stringWithFormat:@"$%d",self.extraLifeCost];
    _extraNukeCostLabel.string = [NSString stringWithFormat:@"$%d",self.extraShieldCost];
    
    
    tutorialStep = 0;
    int tutorialInt = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"tutorial"];
    if (tutorialInt != 0) {
        self.tutorial = true;
        double opacity = .3;
        _pauseButton.enabled = false;
        _boostButton.enabled = false;
        _shootButton.enabled = false;
        _joystickArrow.opacity = opacity;
        _joystickCenter.opacity = opacity;
        scoreLabel.opacity = opacity;
        levelLabel.opacity = opacity;
        for (int i = 0; i < self.numShields; i ++) {
            [self getChildByName:[NSString stringWithFormat:@"shield%d",i] recursively:false].opacity = opacity;
        }
        for (int i = 0; i < self.lives; i ++) {
            [self getChildByName:[NSString stringWithFormat:@"ship%d",i] recursively:false].opacity = opacity;
        }
        //now we need to check if it's a one-time tutorial
        if (tutorialInt == 1 /*this is the setting for "once"*/){
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"tutorial"];
        }
        [self tutorial:(int)tutorialStep];
    } else {
        self.tutorial = false;
        [self startGame];
    }
}

-(void) onEnter{
    [super onEnter];
    self.bankRoll = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"bank"];
    levelLabel.string = [NSString stringWithFormat:@"$%d",self.bankRoll];
    _pauseBankBalance.string = [NSString stringWithFormat:@"$%d",self.bankRoll];
}

-(void) startGame {
    self.tutorial = false;
    double opacity = 1;
    _pauseButton.enabled = true;
    _boostButton.enabled = true;
    _shootButton.enabled = true;
    _joystickArrow.opacity = opacity;
    _joystickCenter.opacity = opacity;
    scoreLabel.opacity = opacity;
    levelLabel.opacity = opacity;
    for (int i = 0; i < self.numShields; i ++) {
        [self getChildByName:[NSString stringWithFormat:@"shield%d",i] recursively:false].opacity = opacity;
    }
    for (int i = 0; i < self.lives; i ++) {
        [self getChildByName:[NSString stringWithFormat:@"ship%d",i] recursively:false].opacity = opacity;
    }
    
    [_tutCoin1 removeFromParent];
    [_tutCoin2 removeFromParent];
    [_tutCoin3 removeFromParent];
    [_tutLabel11 removeFromParent];
    [_tutLabel12 removeFromParent];
    [_tutLabel21 removeFromParent];
    [_tutLabel22 removeFromParent];
    [_tutLabel23 removeFromParent];
    [_tutLabel24 removeFromParent];
    [_tutLabel31 removeFromParent];
    [_tutLabel41 removeFromParent];
    [_tutLabel42 removeFromParent];
    [_tutLabel43 removeFromParent];
    [_tutLabel44 removeFromParent];
    [_tutLabel51 removeFromParent];
    [_tutSprite removeFromParent];
    [_tutStroid3 removeFromParent];
    [_tutStroid2 removeFromParent];
    [_tutStroid1 removeFromParent];
    
    [self createLevel:self.level];
    
    [self resetShip];

    _physicsNode.debugDraw = debugMode;
    
    [self schedule:@selector(powerUpDrop:) interval:30];

}

-(void) powerUpDrop:(CCTime) dt {
    //stuff to drop the bomb
    Shield *powerUp = (Shield *) [CCBReader load:@"ShieldSprite"];
    powerUp.scale = .5;
    int width = screenWidth - 75;
    int randX = arc4random() % width + 37;
    int height = screenHeight - 150;
    int randY = arc4random() % height + 100;
    powerUp.position = CGPointMake(randX, randY);
    powerUp.opacity = 0;
    CCAction *fadeIn = [CCActionFadeIn actionWithDuration:1.];
    [_physicsNode addChild:powerUp];
    [powerUp runAction:fadeIn];
    
}

-(void) displayNumberOfLives:(double)opacity {
    
    for (int i = 0; i < self.lives+ 1; i++) {
        [self removeChildByName:[NSString stringWithFormat:@"ship%d",i]];
    }
    for (int i = 0; i < self.lives; i++) {
        CCLOG(@"Loading ships");
        Ship *ship = (Ship *)[CCBReader load:@"DisplayShip"];
        ship.anchorPoint = CGPointMake(0, 1);
        ship.scale = .44;
        ship.opacity = opacity;
        ship.position = CGPointMake(0 + ship.contentSizeInPoints.width*i*.46, screenHeight - scoreLabel.contentSizeInPoints.height);
        [self addChild:ship z:0 name:[NSString stringWithFormat:@"ship%d",i]];
    }
    
}

-(void) displayNumberOfShields:(double)opacity {
    double scale = .28;
    for (int i = 0; i < self.numShields + 1; i++) {
        [self removeChildByName:[NSString stringWithFormat:@"shield%d",i]];
    }
    for (int i= 0; i < self.numShields; i++) {
        Shield *shield = (Shield *)[CCBReader load:@"ShieldSprite"];
        shield.displayShield = true;
        shield.scale = scale;
        shield.anchorPoint = CGPointMake(1, 1);
        shield.opacity = opacity;
        shield.position = CGPointMake(screenWidth - scale * shield.contentSizeInPoints.width*i, screenHeight - levelLabel.contentSizeInPoints.height);
        [self addChild:shield z:0 name:[NSString stringWithFormat:@"shield%d",i]];
    }
}

-(void) update:(CCTime)delta{
    
    if (self.collisionCounter < 120){
        self.collisionCounter += 1;
    }
    
    double shipVelocityX = mainShip.physicsBody.velocity.x;
    double shipVelocityY = mainShip.physicsBody.velocity.y;
    
    for (Stars *star in smallStarsArray) {
        star.position = CGPointMake(star.position.x - smallStarSpeed*shipVelocityX,star.position.y - smallStarSpeed*shipVelocityY);
    }
    for (Stars *star in mediumStarsArray) {
        star.position = CGPointMake(star.position.x - mediumStarSpeed*shipVelocityX,star.position.y - mediumStarSpeed*shipVelocityY);
    }
    for (Stars *star in largeStarsArray) {
        star.position = CGPointMake(star.position.x - largeStarSpeed*shipVelocityX,star.position.y - largeStarSpeed*shipVelocityY);
    }
    
    if (_shootButton.state && mainShip.readyToFire) {
        [mainShip fire];
        bulletsFired += numbBulletsPerFire;
    }
    
    if (_boostButton.state) {
        CGFloat shipDirection = mainShip.rotation;
        CGPoint thrust = CGPointMake(shipThrust*cos((shipDirection-90)*M_PI/180), shipThrust*-sin((shipDirection-90)*M_PI/180));
        [mainShip.physicsBody applyImpulse:thrust];
        if (!mainShip.flamesVisible){
            [mainShip showFlames];
        }
       
        
    } else {
        mainShip.physicsBody.velocity = CGPointMake(mainShip.physicsBody.velocity.x*shipDampening,
                                                    mainShip.physicsBody.velocity.y*shipDampening);
        if (mainShip.flamesVisible){
            [mainShip hideFlames];
        }
    }
    mainShip.physicsBody.angularVelocity = mainShip.physicsBody.angularVelocity*.995;
}

-(void) ToStore {
    [[CCDirector sharedDirector] resume];
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:.1];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"Store"] withTransition:transition];
}

-(void) ToSettings {
    [[CCDirector sharedDirector] resume];
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"Settings"] withTransition:transition];
}

-(void) Pause {
    [[OALSimpleAudio sharedInstance]setEffectsMuted:![[NSUserDefaults standardUserDefaults]boolForKey:@"SFXOn"]];
    [[NSUserDefaults standardUserDefaults] setInteger:self.bankRoll forKey:@"bank"];
    self.paused = !self.paused;
    if (!(self.numShields < 3)) {
        _buyShield.enabled = false;
    } else {
        _buyShield.enabled = true;
    }
    
    if (!(self.lives < 6)) {
        _buyLife.enabled = false;
    } else {
        _buyLife.enabled = true;
    }
    
    _pauseBankBalance.string = [NSString stringWithFormat:@"$%d",self.bankRoll];
    
    if (self.paused) {
        _extraNukeCostLabel.visible = true;
        _buyLife.visible = true;
        _buyShield.visible = true;
        _pauseBankLabel.visible = true;
        _pauseBankBalance.visible = true;
        _extraLifeCostLabel.visible = true;
        _settingsButton.visible = true;
        _storeButton.visible = true;
        _pauseMenu.visible = true;
        double opacity = .3;
        [[CCDirector sharedDirector] pause];
        mainShip.visible = false;
        _boostButton.enabled = false;
        _shootButton.enabled = false;
        _joystickArrow.opacity = opacity;
        _joystickCenter.opacity = opacity;
        scoreLabel.opacity = opacity;
        levelLabel.opacity = opacity;
        
        for (int i = 0; i < self.numShields; i ++) {
            [self getChildByName:[NSString stringWithFormat:@"shield%d",i] recursively:false].opacity = opacity;
        }
        for (int i = 0; i < self.lives; i ++) {
            [self getChildByName:[NSString stringWithFormat:@"ship%d",i] recursively:false].opacity = opacity;
        }
        for (Asteroid *asteroid in asteroidArray){
            asteroid.visible = false;
        }
    } else {
        _extraNukeCostLabel.visible = false;
        _buyLife.visible = false;
        _buyShield.visible = false;
        _pauseBankLabel.visible = false;
        _pauseBankBalance.visible = false;
        _extraLifeCostLabel.visible = false;
        _pauseMenu.visible = false;
        _settingsButton.visible = false;
        _storeButton.visible = false;
        double opacity = 1;
        [[CCDirector sharedDirector] resume];
        _boostButton.enabled = true;
        _shootButton.enabled = true;
        mainShip.visible = true;
        _joystickArrow.opacity = opacity;
        _joystickCenter.opacity = opacity;
        scoreLabel.opacity = opacity;
        levelLabel.opacity = opacity;
        for (int i = 0; i < self.numShields; i ++) {
            [self getChildByName:[NSString stringWithFormat:@"shield%d",i] recursively:false].opacity = opacity;
        }
        for (int i = 0; i < self.lives; i ++) {
            [self getChildByName:[NSString stringWithFormat:@"ship%d",i] recursively:false].opacity = opacity;
        }
        for (Asteroid *asteroid in asteroidArray){
            asteroid.visible = true;
        }
    }
    
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ship:(Ship *)ship asteroid:(Asteroid *)asteroid {
    // collision handling
    CCLOG(@"Asteroid and ship collided");
    if (!mainShip.immune && self.collisionCounter >= 120) {
        numDeaths +=1;
        self.collisionCounter = 0;
        [[OALSimpleAudio sharedInstance] playEffect:@"shipAsteroid.mp3"];
        [self asteroidCollision:asteroid];
        mainShip.immune = true;
        self.lives -=1 ;
        Explosion *explosion = (Explosion *)[CCBReader load:@"Explosion"];
        explosion.position = mainShip.position;
        explosion.rotation = mainShip.rotation;
        explosion.scale += .8;
        [self addChild:explosion];
        _boostButton.userInteractionEnabled = false;
        _boostButton.state = false;
        _shootButton.userInteractionEnabled = false;
        _shootButton.state = false;
        if (self.lives < 0) {
            [[NSUserDefaults standardUserDefaults]setInteger:self.bankRoll forKey:@"bank"];
            [_physicsNode removeChild:mainShip];
            [self scheduleOnce:@selector(gameOver) delay:1];
        } else{
            [self removeChildByName:[NSString stringWithFormat:@"ship%d",self.lives]];
            [_physicsNode removeChild:mainShip];
            [self scheduleOnce:@selector(resetShip) delay:1];
        }
        
    }
    return true;
}

-(void) gameOver {
    [[NSUserDefaults standardUserDefaults]setInteger:self.score forKey:@"score"];
    if (self.score > [[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"]) {
        [[NSUserDefaults standardUserDefaults]setInteger:self.score forKey:@"highScore"];
    }
    
    [[NSUserDefaults standardUserDefaults]setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"asteroidsDestroyed"] +asteroidsDestroyed forKey:@"asteroidsDestroyed"];
    
    [[NSUserDefaults standardUserDefaults]setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"deaths"] + numDeaths forKey:@"deaths"];
    
    [[NSUserDefaults standardUserDefaults]setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"bulletsFired"] +bulletsFired forKey:@"bulletsFired"];
    
    [[GameKitHelper sharedGameKitHelper] submitScore:(int64_t)coinsCollected + [[NSUserDefaults standardUserDefaults]integerForKey:@"Coins"] category:@"Coins"];
    
    [[NSUserDefaults standardUserDefaults]setInteger:coinsCollected + [[NSUserDefaults standardUserDefaults]integerForKey:@"Coins"] forKey:@"Coins"];
    
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"Main"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]withTransition:transition];
}

-(void) resetShip{
    int shipLevel = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"gunLevel"];
    mainShip = [[Ship alloc]init];
    mainShip.immune = true;
    if (shipLevel == 1) {
        mainShip = (Ship *)[CCBReader load:@"Ship"];
        numbBulletsPerFire = 1;
    } else if (shipLevel == 2) {
        mainShip = (Ship *)[CCBReader load:@"Level2"];
        numbBulletsPerFire = 2;
    } else if (shipLevel == 3) {
        mainShip = (Ship *)[CCBReader load:@"Level3"];
        numbBulletsPerFire = 3;
    } else if (shipLevel == 4) {
        mainShip = (Ship *)[CCBReader load:@"Level4"];
        numbBulletsPerFire = 4;
    } else {
        mainShip = (Ship *)[CCBReader load:@"Level5"];
        numbBulletsPerFire = 6;
    }
    mainShip.inMain = false; //since it's not in the main menu, we set this to false
    mainShip.position = CGPointMake(screenWidth/2, screenHeight/4);
    [mainShip raiseShield];
    [_physicsNode addChild:mainShip z:-1];
    _boostButton.userInteractionEnabled = true;
    _shootButton.userInteractionEnabled = true;
}

         
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bullet:(CCSprite *)bullet asteroid:(Asteroid *)asteroid {
    // collision handling
    CCLOG(@"Asteroid and bullet collided");
    if (asteroid.key) {
        asteroidsDestroyed += 1;
        asteroid.key = false;
        [self asteroidCollision:asteroid];
        
        self.score += self.level-1;
    }
    
    Explosion *explosion = (Explosion *)[CCBReader load:@"Explosion"];
    explosion.position = bullet.position;    
    [self addChild:explosion];
    
    [bullet removeFromParent];

    
    return true;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair shield:(CCSprite *)shield pickupShield:(Shield *)pickupShield{
    if (self.numShields < 3) {
        self.numShields += 1;
        [self displayNumberOfShields:1.];
    } else {
        [mainShip raiseShield];
    }
    [pickupShield removeFromParent];
    return true;
}
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair shield:(CCSprite *)shield coin:(Coin *)coin{
    self.bankRoll += coin.value;
    coinsCollected += coin.value;
    levelLabel.string = [NSString stringWithFormat:@"$%d",self.bankRoll];
    coin.wasPickedUp = true;
    [coin removeFromParent];
    return true;
}
-(void) asteroidCollision : (Asteroid *) asteroid{
    if (asteroid.size == 1) {
        self.score +=10;
        Asteroid *asteroid1 = (Asteroid *) [CCBReader load:@"AsteroidMedium"];
        asteroid1.size = 2;
        asteroid1.position = CGPointMake(asteroid.position.x+1, asteroid.position.y +1);
        asteroid1.physicsBody.velocity = CGPointMake(asteroid.physicsBody.velocity.x +(int)(arc4random()%mediumSpeedIncrease - mediumSpeedIncrease/2), asteroid.physicsBody.velocity.y + (int)(arc4random()%mediumSpeedIncrease - mediumSpeedIncrease/2));
        [_physicsNode addChild:asteroid1];
        [asteroidArray addObject:asteroid1];
        
        Asteroid *asteroid2 = (Asteroid *) [CCBReader load:@"AsteroidMedium"];
        asteroid2.size = 2;
        asteroid2.position = CGPointMake(asteroid.position.x-1, asteroid.position.y-1);
        asteroid2.physicsBody.velocity = CGPointMake(asteroid.physicsBody.velocity.x +(int)(arc4random()%mediumSpeedIncrease - mediumSpeedIncrease/2), asteroid.physicsBody.velocity.y + (int)(arc4random()%mediumSpeedIncrease - mediumSpeedIncrease/2));
        [_physicsNode addChild:asteroid2];
        [asteroidArray addObject:asteroid2];
        
    } else if (asteroid.size == 2){
        self.score += 20;
        Asteroid *asteroid1 = (Asteroid *) [CCBReader load:@"AsteroidSmall"];
        asteroid1.size = 3;
        asteroid1.position = CGPointMake(asteroid.position.x+1, asteroid.position.y +1);
        asteroid1.physicsBody.velocity = CGPointMake(asteroid.physicsBody.velocity.x +(int)(arc4random()%smallSpeedIncrease - smallSpeedIncrease/2), asteroid.physicsBody.velocity.y + (int)(arc4random()%smallSpeedIncrease - smallSpeedIncrease/2));
        [_physicsNode addChild:asteroid1];
        [asteroidArray addObject:asteroid1];
        
        Asteroid *asteroid2 = (Asteroid *) [CCBReader load:@"AsteroidSmall"];
        asteroid2.size = 3;
        asteroid2.position = CGPointMake(asteroid.position.x-1, asteroid.position.y-1);
        asteroid2.physicsBody.velocity = CGPointMake(asteroid.physicsBody.velocity.x +(int)(arc4random()%smallSpeedIncrease - smallSpeedIncrease/2), asteroid.physicsBody.velocity.y + (int)(arc4random()%smallSpeedIncrease - smallSpeedIncrease/2));
        [_physicsNode addChild:asteroid2];
        [asteroidArray addObject:asteroid2];
        
    } else {
        self.score += 30;
        self.numberOfAsteroidsRemaingingInLevel -= 1;
        [self spawnCoin:asteroid.position];
        if (self.numberOfAsteroidsRemaingingInLevel == 0) {
            [self levelOver];
        }
    }
    scoreLabel.string = [NSString stringWithFormat:@"%d", self.score];
    [asteroidArray removeObject:asteroid];
    [asteroid removeFromParent];
}

-(void) BuyExtraLife{
    CCLOG(@"Life");
    if (self.bankRoll >= self.extraLifeCost){
        //do extra life stuff
        self.lives += 1;
        if (!(self.lives < 6)) {
            _buyLife.enabled = false;
        }
        [self displayNumberOfLives:.3];
        self.bankRoll-=self.extraLifeCost;
        self.extraLifeCost = self.extraLifeCost*2;
        _extraLifeCostLabel.string = [NSString stringWithFormat:@"$%d",self.extraLifeCost];
        [[NSUserDefaults standardUserDefaults]setInteger:self.bankRoll forKey:@"bank"];
        _pauseBankLabel.string = @"Bank:";
        _pauseBankBalance.string = [NSString stringWithFormat:@"$%d",self.bankRoll];
        levelLabel.string = [NSString stringWithFormat:@"$%d",self.bankRoll];
    }
}

-(void) BuyExtraShield{
    if (self.bankRoll >= self.extraShieldCost){
        //do extra nuke stuff
        self.numShields += 1;
        if (!(self.numShields < 3)){
            _buyShield.enabled = false;
        }
        [self displayNumberOfShields:.3];
        self.bankRoll-=self.extraShieldCost;
        self.extraShieldCost = self.extraShieldCost*2;
        _extraNukeCostLabel.string = [NSString stringWithFormat:@"$%d",self.extraShieldCost];
        [[NSUserDefaults standardUserDefaults]setInteger:self.bankRoll forKey:@"bank"];
        _pauseBankLabel.string = @"Bank:";
        _pauseBankBalance.string = [NSString stringWithFormat:@"$%d",self.bankRoll];
        levelLabel.string = [NSString stringWithFormat:@"$%d",self.bankRoll];
    }
}

-(void) levelOver {
    
    //run level over animation
    mainShip.position = CGPointMake(screenWidth/2, screenHeight/4);
    mainShip.physicsBody.velocity = CGPointMake(0,0);
    self.level += 2;
    levelLabel.string = [NSString stringWithFormat:@"$%d", self.bankRoll];
    CoinLabel *levelUpLabel = [CoinLabel  labelWithString:@"Level Up!" fontName:@"Chalkduster" fontSize:36];
    levelUpLabel.scale = 0;
    levelUpLabel.position = CGPointMake(screenWidth/2, screenHeight/2);
    [self addChild:levelUpLabel];
    
    CCAction *expand = [CCActionScaleTo actionWithDuration:1. scale:1];
    CCAction *delay = [CCActionDelay actionWithDuration:.3];
    CCAction *disappear = [CCActionFadeOut actionWithDuration:.2];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[expand,delay,disappear]];
    [levelUpLabel runAction:sequence];
    [self scheduleOnce:@selector(createLevelAfterDelay:) delay:1.5];
    
}
-(void) createLevelAfterDelay: (CCTime)dt{
    [self createLevel:self.level];
}
-(void) createLevel:(int) level{
    for (int i = 0; i < level; i++) {
        Asteroid *asteroid = (Asteroid *) [CCBReader load:@"AsteroidLarge"];
        asteroid.size = 1;
        int asteroidX = (int) (arc4random()%(int)screenWidth);
        int asteroidY = (int) (arc4random()%(int)screenHeight/2)+screenHeight/2;
        asteroid.position = CGPointMake(asteroidX, asteroidY);
        int asteroidVelocityX = (arc4random()%20)-10;
        int asteroidVelocityY = (arc4random()%initialAsteroidVelocity)-initialAsteroidVelocity/2;
        asteroid.physicsBody.velocity = CGPointMake(asteroidVelocityX, asteroidVelocityY);
        [_physicsNode addChild:asteroid];
        [asteroidArray addObject:asteroid];
    }
    self.numberOfAsteroidsRemaingingInLevel = level*4;
    
}

-(void) spawnCoin:(CGPoint)spawnPosition{
    int randCoin = arc4random() %100;
    Coin *coin;
    if (randCoin<65) {
        coin = (Coin *)[CCBReader load:@"CopperCoin"];
        coin.value = 1;
    } else if (randCoin < 90) {
        coin = (Coin *)[CCBReader load:@"SilverCoin"];
        coin.value = 2;
    } else {
        coin = (Coin *)[CCBReader load:@"GoldCoin"];
        coin.value = 5;
    }
    CCColor *labelColor;
    if (coin.value == 1) {
        labelColor = [CCColor colorWithCcColor3b:ccc3(162, 104, 0)];
    } else if (coin.value == 2) {
        labelColor = [CCColor colorWithCcColor3b:ccc3(153, 153, 153)];
    } else {
        labelColor = [CCColor colorWithCcColor3b:ccc3(239, 215, 9)];
    }
    coin.position = spawnPosition;
    coin.labelColor = labelColor;
    [_physicsNode addChild:coin];
}

-(void) tutorial:(int)step {
    if (step == 0) {
        _tutLabel21.visible = false;
        _tutLabel22.visible = false;
        _tutLabel23.visible = false;
        _tutLabel24.visible = false;
        _tutLabel31.visible = false;
        _tutLabel41.visible = false;
        _tutLabel42.visible = false;
        _tutLabel43.visible = false;
        _tutLabel44.visible = false;
        _tutLabel51.visible = false;
        _tutCoin1.visible = false;
        _tutCoin2.visible = false;
        _tutCoin3.visible = false;
        _tutSprite.visible = false;
        _tutStroid1.visible = false;
        _tutStroid2.visible = false;
        _tutStroid3.visible = false;
    } else if (step == 1) {
        _tutLabel11.visible = false;
        _tutLabel12.visible = false;
        _tutLabel21.visible = true;
        _tutLabel22.visible = true;
        _tutLabel23.visible = true;
        _tutLabel24.visible = true;
    } else if (step ==2) {
        _tutLabel21.visible = false;
        _tutLabel22.visible = false;
        _tutLabel23.visible = false;
        _tutLabel24.visible = false;
        _tutLabel31.visible = true;
        _tutStroid1.visible = true;
        _tutStroid2.visible = true;
        _tutStroid3.visible = true;
    } else if (step == 3) {
        _tutLabel31.visible = false;
        _tutStroid1.visible = false;
        _tutStroid2.visible = false;
        _tutStroid3.visible = false;
        _tutLabel41.visible = true;
        _tutLabel42.visible = true;
        _tutLabel43.visible = true;
        _tutLabel44.visible = true;
        _tutCoin1.visible = true;
        _tutCoin2.visible = true;
        _tutCoin3.visible = true;
    } else if (step == 4) {
        _tutLabel41.visible = false;
        _tutLabel42.visible = false;
        _tutLabel43.visible = false;
        _tutLabel44.visible = false;
        _tutLabel51.visible = true;
        _tutCoin1.visible = false;
        _tutCoin2.visible = false;
        _tutCoin3.visible = false;
        _tutSprite.visible = true;
    } else {
        [self startGame];
    }
    
    
    

}

@end
