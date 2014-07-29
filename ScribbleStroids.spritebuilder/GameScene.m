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
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    mainShip = (Ship *)[CCBReader load:@"Ship"];
    mainShip.position = CGPointMake(100, 100);
    mainShip.scale = .2;
    [_physicsNode addChild:mainShip z:2];
    _physicsNode.debugDraw = true;

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
        mainShip.physicsBody.velocity = CGPointMake(mainShip.physicsBody.velocity.x*.995,
                                                    mainShip.physicsBody.velocity.y*.995);
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
}

-(void) TurnRight{
    CCLOG(@"Right Button Pressed");
}

-(void) Boost{
    CCLOG(@"Boost Button Pressed");
}

-(void) Shoot{
    CCLOG(@"Shoot Button Pressed");
//    [mainShip fire];
    CCSprite *bullet = (CCSprite *)[CCBReader load:@"Bullet"];
    
    bullet.position = mainShip.position;
    
    bullet.physicsBody.velocity = mainShip.physicsBody.velocity;
    [_physicsNode addChild:bullet z:1];
    CGFloat shipDirection = mainShip.rotation;
    [bullet.physicsBody applyImpulse: CGPointMake(missileLaunchImpulse*cos(shipDirection*M_PI/180),
                                                  missileLaunchImpulse*-sin(shipDirection*M_PI/180))];
}

@end
