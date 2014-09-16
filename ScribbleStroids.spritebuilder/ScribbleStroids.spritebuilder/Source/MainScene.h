//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Jorrie on 7/26/14.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCNode.h"
#import "Ship.h"

@interface MainScene : CCNode
{    
    CCLabelTTF *_titleLabel,*_gameOverLabel,*_scoreLabel;
    
    NSMutableArray *smallStarsArray,*mediumStarsArray,*largeStarsArray;
    
    CGFloat screenWidth,screenHeight;
    
    Ship *ship;
    
    double smallStarSpeedX,smallStarSpeedY,mediumStarSpeedX,mediumStarSpeedY,largeStarSpeedX,largeStarSpeedY;
    
    NSUserDefaults *defaults;
}
-(void) playGame;
-(void) howTo;
-(void) highScores;

@end
