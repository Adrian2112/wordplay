//
//  ILSelectGameViewController.m
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/7/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import "ILSelectGameViewController.h"
#import "ILGame.h"
#import "ILGameViewController.h"

@interface ILSelectGameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *gameNameLabel;

@end

@implementation ILSelectGameViewController

- (IBAction)playButtonClicked:(id)sender
{
    ILGame *game = [[ILGame alloc] initWithName:self.gameNameLabel.text];
    [self presentGameControllerWithGame:game];
}

- (IBAction)newGame:(id)sender
{
    ILGame *game = [[ILGame alloc] init];
    [self presentGameControllerWithGame:game];
}

-(void)presentGameControllerWithGame:(ILGame *)game
{
    ILGameViewController *gameVC = [[ILGameViewController alloc] initWithGame:game];
    
    game.delegate = gameVC;
    
    [self presentViewController:gameVC animated:YES completion:nil];
}


@end
