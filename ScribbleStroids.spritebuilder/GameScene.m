//
//  GameScene.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameScene.h"

double missileLaunchImpulse = 3;
double shipThrust = 10;
double shipDampening = .97;
int smallSpeedIncrease = 80;
int mediumSpeedIncrease = 120;
int initialAsteroidVelocity = 60;
bool debugMode = false;
double joystickTouchThreshold = 90;
double shipTouchThreshold = 50;
int numberOfLives = 2;
int startLevel = 1;
int bulletExplosionSpeed = 90;
int startingNumberOfBombs = 3;
double howOftenPowerupDropsAreMade = 60;
int bombLimit = 5;

double smallStarSpeed = .0006;
double mediumStarSpeed = .001;
double largeStarSpeed = .0016;

@implementation GameScene

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CCLOG(@"Received a touch");
    if (!self.paused) {
        mainShip.physicsBody.angularVelocity = 0;
        CGPoint touchLocation = [touch locationInNode:self];
        double hypotenuse = pow(pow(touchLocation.x - screenWidth*(_joystickCenter.position.x),2) + pow(touchLocation.y - screenHeight*(_joystickCenter.position.y), 2),.5);
        if (hypotenuse<joystickTouchThreshold) {
            CCLOG(@"Touch inside threshold");
            CGFloat point = -atan2((-_joystickCenter.position.y*screenHeight+touchLocation.y),(-_joystickCenter.position.x*screenWidth+touchLocation.x))*180/M_PI+90;
            mainShip.rotation = point;
            _joystickArrow.rotation = point;
        } else if (touchLocation.y > 100 && touchLocation.y < (screenHeight - 50)){
            if (self.numBombs > 0){
                [self deployBomb:touchLocation];
                self.numBombs -=1;
                [self removeChildByName:[NSString stringWithFormat:@"bomb%d",self.numBombs]];
            }
        }
    }
}
-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CCLOG(@"Moved a touch");
    if (!self.paused) {
        mainShip.physicsBody.angularVelocity = 0;
        CGPoint touchLocation = [touch locationInNode:self];
        double hypotenuse = pow(pow(touchLocation.x - screenWidth*(_joystickCenter.position.x),2) + pow(touchLocation.y - screenHeight*(_joystickCenter.position.y), 2),.5);
        if (hypotenuse<joystickTouchThreshold) {
            CCLOG(@"Touch inside threshold");
            CGFloat point = -atan2((-_joystickCenter.position.y*screenHeight+touchLocation.y),(-_joystickCenter.position.x*screenWidth+touchLocation.x))*180/M_PI+90;
            mainShip.rotation = point;
            _joystickArrow.rotation = point;
            
        }
    }
}

-(void) didLoadFromCCB {
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
    
    //add the physics node behind the gamescene buttons
    _physicsNode = [[CCPhysicsNode alloc]init];
    [self addChild:_physicsNode z:-1];
    
    _physicsNode.collisionDelegate = self;
    
    mainShip = (Ship *)[CCBReader load:@"Ship"];
    mainShip.inMain = false; //since it's not in the main menu, we set this to false
    mainShip.position = CGPointMake(screenWidth/2, screenHeight/4);
    mainShip.rateOfFire = 1./30.;
    [_physicsNode addChild:mainShip z:-1];
    _physicsNode.debugDraw = debugMode;
    
    //labels
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Chalkduster" fontSize:18];
    scoreLabel.anchorPoint = CGPointMake(0, 1);
    scoreLabel.position = CGPointMake(0, screenHeight);
    [self addChild:scoreLabel];
    levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d",self.level] fontName:@"Chalkduster" fontSize:18];
    levelLabel.anchorPoint = CGPointMake(1, 1);
    levelLabel.position = CGPointMake(screenWidth, screenHeight);
    [self addChild:levelLabel];
    //end labels
    
    [self createLevel:self.level];
    
    self.lives = numberOfLives;
    [self displayNumberOfLives];
        
    self.numBombs = startingNumberOfBombs;
    [self displayNumberOfBombs];
    
    [self schedule:@selector(powerUpDrop:) interval:howOftenPowerupDropsAreMade];
    
    self.paused = false;
}

-(void) deployBomb:(CGPoint)touch {
    for (int i = 0; i < 360; i +=30) {
        Bullet *bullet = (Bullet *)[CCBReader load:@"Bullet"];
        bullet.physicsBody.velocity = CGPointMake(bulletExplosionSpeed*cos(i), bulletExplosionSpeed*sin(i));
        bullet.scale = 1.2;
        bullet.position = touch;
        [_physicsNode addChild:bullet];
    }
}

-(void) powerUpDrop:(CCTime) dt {
    //stuff to drop the bomb
    int randNumber = arc4random() % 2;
    CCSprite *powerUp = [[CCSprite alloc]init];
    if (randNumber == 0) {
        powerUp = (Bomb *) [CCBReader load:@"Bomb"];
    } else {
        powerUp = (Shield *) [CCBReader load:@"ShieldSprite"];
    }
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

-(void) displayNumberOfLives {
    for (int i = 0; i < self.lives; i++) {
        CCLOG(@"Loading ships");
        CCSprite *ship = [CCSprite spriteWithImageNamed:@"PurpleFins200dpi.png"];
        ship.anchorPoint = CGPointMake(0, 1);
        ship.scale = .2;
        ship.position = CGPointMake(0 + ship.contentSizeInPoints.width*i*.2, screenHeight - scoreLabel.contentSizeInPoints.height);
        [self addChild:ship z:0 name:[NSString stringWithFormat:@"ship%d",i]];
    }
}
-(void) displayNumberOfBombs {
    double scale = .28;
    for (int i = 0; i < self.numBombs + 1; i++) {
        [self removeChildByName:[NSString stringWithFormat:@"bomb%d",i]];
    }
    for (int i= 0; i < self.numBombs; i++) {
        Bomb *bomb = (Bomb *)[CCBReader load:@"Bomb"];
        bomb.scale = scale;
        bomb.anchorPoint = CGPointMake(1, 1);
        bomb.position = CGPointMake(screenWidth - scale * bomb.contentSizeInPoints.width*i, screenHeight - levelLabel.contentSizeInPoints.height);
        [self addChild:bomb z:0 name:[NSString stringWithFormat:@"bomb%d",i]];
    }
}

-(void) update:(CCTime)delta{
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
    }
    
    if (_boostButton.state) {
        CGFloat shipDirection = mainShip.rotation;
        CGPoint thrust = CGPointMake(shipThrust*cos((shipDirection-90)*M_PI/180), shipThrust*-sin((shipDirection-90)*M_PI/180));
        [mainShip.physicsBody applyImpulse:thrust];
        [mainShip showFlames];
        
    } else {
        mainShip.physicsBody.velocity = CGPointMake(mainShip.physicsBody.velocity.x*shipDampening,
                                                    mainShip.physicsBody.velocity.y*shipDampening);
        [mainShip hideFlames];
    }
    mainShip.physicsBody.angularVelocity = mainShip.physicsBody.angularVelocity*.995;

    
}

-(void) Pause {
    self.paused = !self.paused;
    if (self.paused) {
        double opacity = .5;
        [[CCDirector sharedDirector] pause];
        _boostButton.enabled = false;
        _shootButton.enabled = false;
        mainShip.opacity = opacity;
        _joystickArrow.opacity = opacity;
        _joystickCenter.opacity = opacity;
        scoreLabel.opacity = opacity;
        levelLabel.opacity = opacity;
        for (int i = 0; i < self.numBombs; i ++) {
            [self getChildByName:[NSString stringWithFormat:@"bomb%d",i] recursively:false].opacity = opacity;
        }
        for (int i = 0; i < self.lives; i ++) {
            [self getChildByName:[NSString stringWithFormat:@"ship%d",i] recursively:false].opacity = opacity;
        }
    } else {
        double opacity = 1;
        [[CCDirector sharedDirector] resume];
        _boostButton.enabled = true;
        _shootButton.enabled = true;
        mainShip.opacity = opacity;
        _joystickArrow.opacity = opacity;
        _joystickCenter.opacity = opacity;
        scoreLabel.opacity = opacity;
        levelLabel.opacity = opacity;
        for (int i = 0; i < self.numBombs; i ++) {
            [self getChildByName:[NSString stringWithFormat:@"bomb%d",i] recursively:false].opacity = opacity;
        }
        for (int i = 0; i < self.lives; i ++) {
            [self getChildByName:[NSString stringWithFormat:@"ship%d",i] recursively:false].opacity = opacity;
        }
    }
    
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ship:(Ship *)ship asteroid:(Asteroid *)asteroid {
    // collision handling
    CCLOG(@"Asteroid and ship collided");
    if (!mainShip.immune) {
        [self asteroidCollision:asteroid];
        mainShip.immune = true;
        self.lives -=1 ;
        if (self.lives < 0) {
            [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
        }
        [self removeChildByName:[NSString stringWithFormat:@"ship%d",self.lives]];
        mainShip.position = CGPointMake(screenWidth/2, screenHeight/4);
        mainShip.physicsBody.velocity = CGPointMake(0, 0);
        mainShip.rotation = 0;
        [mainShip shieldUp:1];
    }
    
    mainShip.physicsBody.angularVelocity = 0;
    return true;
}
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bullet:(CCSprite *)bullet asteroid:(Asteroid *)asteroid {
    // collision handling
    CCLOG(@"Asteroid and bullet collided");
    if (asteroid.key) {
        asteroid.key = false;
        [self asteroidCollision:asteroid];
        
        CCLabelTTF *plusOne = [CCLabelTTF labelWithString:@"+1" fontName:@"Chalkduster" fontSize:22];
        plusOne.position = asteroid.position;
        CCAction *rise = [CCActionMoveBy actionWithDuration:.5 position:CGPointMake(0, 20)];
        CCAction *fade = [CCActionFadeOut actionWithDuration:.2];
        CCActionSequence *sequence = [CCActionSequence actionWithArray:@[rise,fade]];
        [self addChild:plusOne];
        [plusOne runAction:sequence];
        
        self.score += 1;
        scoreLabel.string = [NSString stringWithFormat:@"%d", self.score];
    }
    [bullet removeFromParent];
    
    return true;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair shield:(CCSprite *)shield bomb:(Bomb *)bomb{
    if (self.numBombs < bombLimit) {
        self.numBombs += 1;
        [bomb removeFromParent];
        [self displayNumberOfBombs];
    } else {
       [bomb removeFromParent];
    }
    return true;
}
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bullet:(CCSprite *)bullet bomb:(Bomb *)bomb {
    [bullet removeFromParent];
    bomb.physicsBody.velocity = CGPointMake(0, 0);
    return true;
}
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair shield:(CCSprite *)shield pickupShield:(Shield *)pickupShield{
    [mainShip shieldUp:1];
    [pickupShield removeFromParent];
    return true;
}
-(void) asteroidCollision : (Asteroid *) asteroid{
    if (asteroid.size == 1) {
        Asteroid *asteroid1 = (Asteroid *) [CCBReader load:@"AsteroidMedium"];
        asteroid1.size = 2;
        asteroid1.position = CGPointMake(asteroid.position.x+1, asteroid.position.y +1);
        asteroid1.physicsBody.velocity = CGPointMake(asteroid.physicsBody.velocity.x +(int)(arc4random()%mediumSpeedIncrease - mediumSpeedIncrease/2), asteroid.physicsBody.velocity.y + (int)(arc4random()%mediumSpeedIncrease - mediumSpeedIncrease/2));
        [_physicsNode addChild:asteroid1];
        
        Asteroid *asteroid2 = (Asteroid *) [CCBReader load:@"AsteroidMedium"];
        asteroid2.size = 2;
        asteroid2.position = CGPointMake(asteroid.position.x-1, asteroid.position.y-1);
        asteroid2.physicsBody.velocity = CGPointMake(asteroid.physicsBody.velocity.x +(int)(arc4random()%mediumSpeedIncrease - mediumSpeedIncrease/2), asteroid.physicsBody.velocity.y + (int)(arc4random()%mediumSpeedIncrease - mediumSpeedIncrease/2));
        [_physicsNode addChild:asteroid2];
        
    } else if (asteroid.size == 2){
        Asteroid *asteroid1 = (Asteroid *) [CCBReader load:@"AsteroidSmall"];
        asteroid1.size = 3;
        asteroid1.position = CGPointMake(asteroid.position.x+1, asteroid.position.y +1);
        asteroid1.physicsBody.velocity = CGPointMake(asteroid.physicsBody.velocity.x +(int)(arc4random()%smallSpeedIncrease - smallSpeedIncrease/2), asteroid.physicsBody.velocity.y + (int)(arc4random()%smallSpeedIncrease - smallSpeedIncrease/2));
        [_physicsNode addChild:asteroid1];
        
        Asteroid *asteroid2 = (Asteroid *) [CCBReader load:@"AsteroidSmall"];
        asteroid2.size = 3;
        asteroid2.position = CGPointMake(asteroid.position.x-1, asteroid.position.y-1);
        asteroid2.physicsBody.velocity = CGPointMake(asteroid.physicsBody.velocity.x +(int)(arc4random()%smallSpeedIncrease - smallSpeedIncrease/2), asteroid.physicsBody.velocity.y + (int)(arc4random()%smallSpeedIncrease - smallSpeedIncrease/2));
        [_physicsNode addChild:asteroid2];
        
    } else {
        self.numberOfAsteroidsRemaingingInLevel -= 1;
        if (self.numberOfAsteroidsRemaingingInLevel == 0) {
            [self levelOver];
        }
    }
    [asteroid removeFromParent];
}

-(void) levelOver {
    
    //run level over animation
    mainShip.position = CGPointMake(screenWidth/2, screenHeight/4);
    self.level += 1;
    levelLabel.string = [NSString stringWithFormat:@"Level: %d", self.level];
    CCLabelTTF *levelUpLabel = [CCLabelTTF  labelWithString:@"Level Up!" fontName:@"Chalkduster" fontSize:36];
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
        
    }
    self.numberOfAsteroidsRemaingingInLevel = level*4;
    
}

@end
