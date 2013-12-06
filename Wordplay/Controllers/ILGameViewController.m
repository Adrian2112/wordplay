//
//  ILGameViewController.m
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/4/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import "ILGameViewController.h"
#import "ILBoardViewController.h"
#import "ILGame.h"
#import <DWTagList/DWTagList.h>

@interface ILGameViewController ()
@property (strong, nonatomic) ILBoardViewController *boardViewController;
@property (weak, nonatomic) IBOutlet UIView *boardCollectionControllerContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *wordListContainer;
@property (strong, nonatomic) NSMutableArray *wordList;
@property (strong, nonatomic) DWTagList *wordListView;

@property (strong, nonatomic) ILGame *game;

@end

@implementation ILGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.boardCollectionControllerContainer.layer.masksToBounds = YES;
    
    self.boardViewController = [[ILBoardViewController alloc] initWithLetterMatrix:[self getLetterMatrix]];
    [self addChildViewController:self.boardViewController];
    
    [self.boardCollectionControllerContainer addSubview:self.boardViewController.collectionView];
    
    self.wordListView = [[DWTagList alloc] initWithFrame:self.wordListContainer.bounds];
    [self.wordListContainer addSubview:self.wordListView];
    
    self.wordListView.automaticResize = YES;
    
    self.game = [[ILGame alloc] init];
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
    NSString *word = [self.boardViewController touchEndedWithWord];
    if ([word compare:@""] == NSOrderedSame) return;
    
    [self.wordList addObject:word];
    [self.wordListView setTags:[self.wordList copy]];
    [self.wordListView setNeedsDisplay];
    
    [self.game addNewWord:word];
    
    [self scrollWordsViewToBottom];
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

-(void)scrollWordsViewToBottom
{
    CGFloat yPosition = self.wordListView.contentSize.height - self.wordListContainer.frame.size.height;
    CGPoint bottomOffset = CGPointMake(0, yPosition < 0 ? 0 : yPosition);
    
    self.wordListContainer.contentSize = self.wordListView.contentSize;
    
    NSLog(@"%@ %@ %@", NSStringFromCGSize(self.wordListView.contentSize), NSStringFromCGPoint(bottomOffset), NSStringFromCGSize(self.wordListContainer.frame.size));
    [self.wordListContainer setContentOffset:bottomOffset animated:YES];
}

#pragma mark - variables lazy load
-(NSMutableArray *)wordList
{
    if (_wordList == nil) _wordList = [NSMutableArray array];
    return _wordList;
}

@end
