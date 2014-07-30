//
//  GameScene.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "Ship.h"

double missileLaunchImpulse = 3;

@implementation GameScene

-(void) didLoadFromCCB {
    
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
    [self addChild:_physicsNode z:-1];
    
    _physicsNode.collisionDelegate = self;
    
    //
    
    Asteroid *asteroid = (Asteroid *) [CCBReader load:@"Asteroid"];
    
    asteroid.position = CGPointMake(100, 300);
    asteroid.scale = .4;
    
    [_physicsNode addChild:asteroid z:-10];
    
    mainShip = (Ship *)[CCBReader load:@"Ship"];
    mainShip.position = CGPointMake(100, 100);
    mainShip.scale = .2;
    [_physicsNode addChild:mainShip z:-1];
    _physicsNode.debugDraw = true;

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
        CGPoint thrust = CGPointMake(15*cos(shipDirection*M_PI/180), 15*-sin(shipDirection*M_PI/180));
        [mainShip.physicsBody applyImpulse:thrust];
        
    } else {
        mainShip.physicsBody.velocity = CGPointMake(mainShip.physicsBody.velocity.x*.995,
                                                    mainShip.physicsBody.velocity.y*.995);
    }
    mainShip.physicsBody.angularVelocity = mainShip.physicsBody.angularVelocity*.995;

    
    if (mainShip.position.x > screenWidth){
        mainShip.position = CGPointMake(0, mainShip.position.y);
    } else if (mainShip.position.x < 0){
        mainShip.position = CGPointMake(screenWidth, mainShip.position.y);
    }
    
    if (mainShip.position.y > screenHeight){
        mainShip.position = CGPointMake(mainShip.position.x, 0);
    } else if (mainShip.position.y < 0) {
        mainShip.position = CGPointMake(mainShip.position.x, screenHeight);
    }
    
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
    
    if (asteroid.scale > .11) {
        
        Asteroid *asteroid1 = (Asteroid *) [CCBReader load:@"Asteroid"];
        asteroid1.position = asteroid.position;
        asteroid1.scale = asteroid.scale*.5;
        int rx1 = (arc4random() % 40) - 20;
        int ry1 = (arc4random() % 40) - 20;
        asteroid1.physicsBody.velocity = CGPointMake(rx1, ry1);
        [_physicsNode addChild:asteroid1];
        
        
        Asteroid *asteroid2 = (Asteroid *)[CCBReader load:@"Asteroid"];
        asteroid2.position = asteroid.position;
        asteroid2.scale = asteroid.scale*.5;
        int rx2 = (arc4random() % 40) - 20;
        int ry2 = (arc4random() % 40) - 20;
        asteroid2.physicsBody.velocity = CGPointMake(rx2, ry2);
        [_physicsNode addChild:asteroid2];
        
        
    }
    
    [asteroid removeFromParent];
    [bullet removeFromParent];
    
    return true;
}

-(void)level1
{
    
}

@end
