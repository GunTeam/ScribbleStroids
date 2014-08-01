//
//  GameScene.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameScene.h"

double missileLaunchImpulse = 3;
double shipThrust = 30;
double shipDampening = .97;
int smallSpeedIncrease = 60;
int mediumSpeedIncrease = 80;
int initialAsteroidVelocity = 40;
bool debugMode = false;

@implementation GameScene

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Received a touch");
    CGPoint touchLocation = [touch locationInNode:self];
    
}



-(void) didLoadFromCCB {
    //start with level 1
    self.userInteractionEnabled = true;
    
    self.level = 1;
    
    self.score = 0;
    _scoreLabel.string = [NSString stringWithFormat:@"Score: %d", self.score];
    
    [[[CCDirector sharedDirector] view] setMultipleTouchEnabled:YES];
    _leftButton.exclusiveTouch = false;
    _rightButton.exclusiveTouch = false;
    _boostButton.exclusiveTouch = false;
    _shootButton.exclusiveTouch = false;
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    
    //add the physics node behind the gamescene buttons
    _physicsNode = [[CCPhysicsNode alloc]init];
//    _physicsNode.sleepTimeThreshold = 100;
    [self addChild:_physicsNode z:-1];
    
    _physicsNode.collisionDelegate = self;
    
    mainShip = (Ship *)[CCBReader load:@"Ship"];
    mainShip.position = CGPointMake(screenWidth/2, screenHeight/4);
    mainShip.scale = .2;
    [_physicsNode addChild:mainShip z:-1];
    _physicsNode.debugDraw = debugMode;
    
    [self createLevel:self.level];

}

-(void) update:(CCTime)delta{
    if (_leftButton.state) {
        mainShip.rotation -=5;
        mainShip.physicsBody.angularVelocity = 0;
    }
    
    if (_rightButton.state) {
        mainShip.rotation += 5;
        mainShip.physicsBody.angularVelocity = 0;
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

-(void) TurnLeft{
    CCLOG(@"Left Button Pressed");
}

-(void) TurnRight{
    CCLOG(@"Right Button Pressed");
}

-(void) Boost{
    CCLOG(@"Boost Button Pressed");
}

-(void) Shoot{
    CCLOG(@"Shoot Button Pressed");
    [mainShip fire];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ship:(Ship *)ship asteroid:(CCSprite *)asteroid {
    // collision handling
    CCLOG(@"Asteroid and ship collided");
    
    
    
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
    _scoreLabel.string = [NSString stringWithFormat:@"Score: %d", self.score];
    
    [asteroid removeFromParent];
    [bullet removeFromParent];
    
    return true;
}

-(void) levelOver {
    //run level over animation
    mainShip.position = CGPointMake(screenWidth/2, screenHeight/4);
    self.level += 1;
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
