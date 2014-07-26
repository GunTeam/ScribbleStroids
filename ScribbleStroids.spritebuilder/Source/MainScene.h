//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCNode.h"

@interface MainScene : CCNode
{
    CCLabelTTF *_titleLabel;
}
-(void) playGame;
-(void) howTo;
-(void) highScores;

@end
