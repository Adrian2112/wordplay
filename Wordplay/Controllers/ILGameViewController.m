//
//  ILGameViewController.m
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/4/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import "ILGameViewController.h"
#import "ILBoardViewController.h"

@interface ILGameViewController ()
@property (strong, nonatomic) ILBoardViewController *boardViewController;
@property (weak, nonatomic) IBOutlet UIView *boardCollectionControllerContainer;

@end

@implementation ILGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.boardCollectionControllerContainer.layer.masksToBounds = YES;
    
    self.boardViewController = [[ILBoardViewController alloc] initWithLetterMatrix:[self getLetterMatrix]];
    [self addChildViewController:self.boardViewController];
    
    [self.boardCollectionControllerContainer addSubview:self.boardViewController.collectionView];
}

#pragma mark - Handle touches on board
- (void)touchesMoved: (NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(self.boardCollectionControllerContainer.frame, point)) {
        CGPoint boardPoint = [self.boardCollectionControllerContainer convertPoint:point fromView:self.view];
        [self.boardViewController touchedAtPoint:boardPoint];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.boardViewController touchEnded];
}

-(NSArray *)getLetterMatrix
{
    return @[
             @[@"V", @"T", @"R", @"S"],
             @[@"R", @"Y", @"B", @"W"],
             @[@"W", @"E", @"O", @"A"],
             @[@"I", @"Z", @"H", @"U"],
             ];
}

@end
