//
//  GameScene.m
//  ScribbleStroids
//
//  Created by Jorrie Brettin on 7/26/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GameScene.h"



@implementation GameScene

-(void) didLoadFromCCB {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    
    mainShip = (Ship *)[CCBReader load:@"Ship"];
    mainShip.position = CGPointMake(100, 100);
    mainShip.scale = .2;
//    mainShip.physicsBody.linearDamping = 1;
    [_physicsNode addChild:mainShip];
    _physicsNode.debugDraw = true;
    
    
//    CGPoint launchDirection = ccp(1, 0);
//    CGPoint force = ccpMult(launchDirection, 8000);
//    [mainShip.physicsBody applyForce:force];
    
//    [self schedule:@selector(update:) interval:0.];
}

-(void) update:(CCTime)delta{
    if (_leftButton.state) {
        mainShip.rotation -=5;
    }
    
    if (_rightButton.state) {
        mainShip.rotation += 5;
    }
    
    if (_boostButton.state) {
//        mainShip.physicsBody.velocity = CGPointMake(-75, -75);
        
        CGFloat shipDirection = mainShip.rotation;
        CGPoint thrust = CGPointMake(15*cos(shipDirection*M_PI/180), 15*-sin(shipDirection*M_PI/180));
        [mainShip.physicsBody applyImpulse:thrust];
    } else {
        mainShip.physicsBody.velocity = CGPointMake(mainShip.physicsBody.velocity.x*.99,
                                                    mainShip.physicsBody.velocity.y*.99);
    }
    
    if (_shootButton.state) {
        mainShip.physicsBody.velocity = CGPointMake(0, 0);
        //shoot some bullets
    }
    
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
//    mainShip.physicsBody.angularVelocity = 20;
}

-(void) TurnRight{
    CCLOG(@"Right Button Pressed");
}

-(void) Boost{
    CCLOG(@"Boost Button Pressed");
}

-(void) Shoot{
    CCLOG(@"Shoot Button Pressed");
}

@end
