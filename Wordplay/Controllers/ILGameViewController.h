//
//  ILGameViewController.h
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/4/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILGame.h"

@interface ILGameViewController : UIViewController <ILGameDelegate>

-(instancetype)initWithGame:(ILGame *)game;

@end
