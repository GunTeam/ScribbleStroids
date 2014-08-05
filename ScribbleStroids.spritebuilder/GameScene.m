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
double touchThreshold = 45;
int numberOfLives = 5;
int startLevel = 1;

@implementation GameScene

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CCLOG(@"Received a touch");
    mainShip.physicsBody.angularVelocity = 0;
    CGPoint touchLocation = [touch locationInNode:self];
    double hypotenuse = pow(pow(touchLocation.x - screenWidth*(_joystickCenter.position.x),2) + pow(touchLocation.y - screenHeight*(_joystickCenter.position.y), 2),.5);
    if (hypotenuse<touchThreshold) {
        CCLOG(@"Touch inside threshold");
        CGFloat point = -atan2((-_joystickCenter.position.y*screenHeight+touchLocation.y),(-_joystickCenter.position.x*screenWidth+touchLocation.x))*180/M_PI+90;
//        CGFloat point = ccpAngle(_joystickCenter.position, touchLocation)*180/M_PI;
        
        mainShip.rotation = point;
        _joystickArrow.rotation = point;
    }
}
-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CCLOG(@"Moved a touch");
    mainShip.physicsBody.angularVelocity = 0;
    CGPoint touchLocation = [touch locationInNode:self];
    double hypotenuse = pow(pow(touchLocation.x - screenWidth*(_joystickCenter.position.x),2) + pow(touchLocation.y - screenHeight*(_joystickCenter.position.y), 2),.5);
    if (hypotenuse<touchThreshold) {
        CCLOG(@"Touch inside threshold");
        CGFloat point = -atan2((-_joystickCenter.position.y*screenHeight+touchLocation.y),(-_joystickCenter.position.x*screenWidth+touchLocation.x))*180/M_PI+90;
        //        CGFloat point = ccpAngle(_joystickCenter.position, touchLocation)*180/M_PI;
        
        mainShip.rotation = point;
        _joystickArrow.rotation = point;

    }
}

-(void) didLoadFromCCB {
    
    self.userInteractionEnabled = true;
    self.multipleTouchEnabled =true;
    
    self.level = startLevel;
    
    self.score = 0;
    
    [[[CCDirector sharedDirector] view] setMultipleTouchEnabled:YES];
    _leftButton.exclusiveTouch = false;
    _rightButton.exclusiveTouch = false;
    _boostButton.exclusiveTouch = false;
    _shootButton.exclusiveTouch = false;
    
    _leftButton.visible = false;
    _rightButton.visible = false;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    //add the physics node behind the gamescene buttons
    _physicsNode = [[CCPhysicsNode alloc]init];
    [self addChild:_physicsNode z:-1];
    
    _physicsNode.collisionDelegate = self;
    
    mainShip = (Ship *)[CCBReader load:@"Ship"];
    mainShip.position = CGPointMake(screenWidth/2, screenHeight/4);
    mainShip.rateOfFire = 1./30.;
    [_physicsNode addChild:mainShip z:-1];
    _physicsNode.debugDraw = debugMode;
    
    //labels
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:18];
    scoreLabel.anchorPoint = CGPointMake(0, 1);
    scoreLabel.position = CGPointMake(0, screenHeight);
    [self addChild:scoreLabel];
    levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d",self.level] fontName:@"Arial" fontSize:18];
    levelLabel.anchorPoint = CGPointMake(1, 1);
    levelLabel.position = CGPointMake(screenWidth, screenHeight);
    [self addChild:levelLabel];
    //end labels
    
    [self createLevel:self.level];
    
    self.lives = numberOfLives;
    [self displayNumberOfLives];
    
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

-(void) update:(CCTime)delta{
    
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

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ship:(Ship *)ship asteroid:(CCSprite *)asteroid {
    // collision handling
    CCLOG(@"Asteroid and ship collided");
    self.lives -=1 ;
    [self removeChildByName:[NSString stringWithFormat:@"ship%d",self.lives]];
    mainShip.position = CGPointMake(screenWidth/2, screenHeight/4);
    mainShip.physicsBody.velocity = CGPointMake(0, 0);
    mainShip.rotation = 0;
    return true;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bullet:(CCSprite *)bullet asteroid:(Asteroid *)asteroid {
    // collision handling
    CCLOG(@"Asteroid and bullet collided");
    
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
        [asteroid removeFromParent];
        self.numberOfAsteroidsRemaingingInLevel -= 1;
        if (self.numberOfAsteroidsRemaingingInLevel == 0) {
            [self levelOver];
        }
    }
    
    self.score += 1;
    scoreLabel.string = [NSString stringWithFormat:@"%d", self.score];
    
    [asteroid removeFromParent];
    [bullet removeFromParent];
    
    
    
    return true;
}

-(void) levelOver {
    
    //run level over animation
    mainShip.position = CGPointMake(screenWidth/2, screenHeight/4);
    self.level += 1;
    levelLabel.string = [NSString stringWithFormat:@"Level: %d", self.level];
    CCLabelTTF *levelUpLabel = [CCLabelTTF  labelWithString:@"Level Up!" fontName:@"Helvetica" fontSize:36];
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
