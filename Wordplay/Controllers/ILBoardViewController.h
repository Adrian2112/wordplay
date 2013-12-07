//
//  ILBoardViewController.h
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/4/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILBoardViewController : UICollectionViewController

-(instancetype)initWithBoardLetters:(NSArray *)boardLetters;

-(void)touchedAtPoint:(CGPoint)point;
-(NSString *)touchEndedWithWord;
@end
