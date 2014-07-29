//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameScene.h"

@implementation MainScene

-(void) didLoadFromCCB{
    //any custom initialization needed goes here
    [viewController authenticateLocalPlayer];
}

-(void) playGame{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameScene"]];
}

-(void) howTo{
    
}

-(void) highScores{
    
}

@end
