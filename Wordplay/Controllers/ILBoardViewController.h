//
//  ILBoardViewController.h
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/4/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ILBoardViewDelegate;

@interface ILBoardViewController : UICollectionViewController

@property (strong, nonatomic) id<ILBoardViewDelegate> delegate;

-(instancetype)initWithBoardLetters:(NSArray *)boardLetters;

-(void)touchedAtPoint:(CGPoint)point;
-(void)touchEnded;
@end

@protocol ILBoardViewDelegate <NSObject>

@required
-(void)boardView:(ILBoardViewController *)boardView formedWord:(NSString *)formedWord;

@end
