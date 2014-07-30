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
    
    //This block enables multi-touch
    //This should not need to be touched
    [[[CCDirector sharedDirector] view] setMultipleTouchEnabled:YES];
    _leftButton.exclusiveTouch = false;
    _rightButton.exclusiveTouch = false;
    _boostButton.exclusiveTouch = false;
    _shootButton.exclusiveTouch = false;
    //End multi-touch block
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    //add the physics node behind the gamescene buttons
    _physicsNode = [[CCPhysicsNode alloc]init];
    [self addChild:_physicsNode z:-1];
    
    //this is needed so physics methods that happen on the physics node
    //can be handled by the gamescene
    _physicsNode.collisionDelegate = self;
    
    //this is how an asteroid should be spawned.
    //You can set the initial velocity using random numbers
    //The asteroid scale doesn't really matter at this point, it will change when we get
    //new artwork.
    //You must induce the physicsBody property of an object to access properties like
    //velocity and angularVelocity, and to access methods like applyImpulse
    /*Asteroid *asteroid = (Asteroid *) [CCBReader load:@"Asteroid"];
    asteroid.position = CGPointMake(100, 300);
    asteroid.physicsBody.velocity = CGPointMake(10, 10);
    asteroid.scale = .4;
    [_physicsNode addChild:asteroid z:-10];*/
    
    
    //spawn the ship
    //The ship's scale also doesn't actually matter at this point. We need
    //to get the artwork to know just what the scale will be. We place it in the
    //center of the screen.
    mainShip = (Ship *)[CCBReader load:@"Ship"];
    mainShip.position = CGPointMake(screenWidth/2, screenHeight/2);
    mainShip.scale = .2;
    [_physicsNode addChild:mainShip];
    
    //this is for debugging purposes. While true, you can see the physics bodies
    _physicsNode.debugDraw = true;
    
    [self level1];

}

//The update function is called 60 times per second and is automatically called
-(void) update:(CCTime)delta{
    //_button.state is true when the button is pressed.
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
        //this is the dampening part of the ship. When you're not touching the thrusters,
        //it slowly comes to a stop.
        mainShip.physicsBody.velocity = CGPointMake(mainShip.physicsBody.velocity.x*.995,
                                                    mainShip.physicsBody.velocity.y*.995);
    }
    mainShip.physicsBody.angularVelocity = mainShip.physicsBody.angularVelocity*.995;
    
}

//These methods are called by touchUpInside actions by the four buttons
//on screen. I don't know how to change it so it's not touchUpInside.

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
    
    //this splits the asteroid that is being shot in half if it's large enough
    
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
    //destroy the asteroid and the bullet
    [asteroid removeFromParent];
    [bullet removeFromParent];
    
    return true;
}

-(void)level1
{
    Asteroid *asteroid1 = (Asteroid *) [CCBReader load:@"Asteroid"];
    asteroid1.position = CGPointMake(75, 300);
    asteroid1.physicsBody.velocity = CGPointMake(5, 20);
    asteroid1.scale = .4;
    [_physicsNode addChild:asteroid1 z:-10];
    
    Asteroid *asteroid2 = (Asteroid *) [CCBReader load:@"Asteroid"];
    asteroid2.position = CGPointMake(250, 100);
    asteroid2.physicsBody.velocity = CGPointMake(-50, 25);
    asteroid2.scale = .3;
    [_physicsNode addChild:asteroid2 z:-10];
}

@end
