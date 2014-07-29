//
//  GameCenterViewController.h
//  ScribbleStroids
//
//  Created by Adam Birdsall on 7/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface GameCenterViewController : UIViewController

// A flag indicating whether the Game Center features can be used after a user has been authenticated.
@property (nonatomic) BOOL gameCenterEnabled;

// This property stores the default leaderboard's identifier.
@property (nonatomic, strong) NSString *leaderboardIdentifier;

-(void)authenticateLocalPlayer;

@end
