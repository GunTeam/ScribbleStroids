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
    CCLabelTTF *_titleLabel;
    
    NSMutableArray *smallStarsArray,*mediumStarsArray,*largeStarsArray;
    
    CGFloat screenWidth,screenHeight;
    
    Ship *ship;
    
    double smallStarSpeedX,smallStarSpeedY,mediumStarSpeedX,mediumStarSpeedY,largeStarSpeedX,largeStarSpeedY;
}
-(void) playGame;
-(void) howTo;
-(void) highScores;

@end
