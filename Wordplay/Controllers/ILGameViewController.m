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
#import "ILWord.h"
#import <DWTagList/DWTagList.h>

@interface ILGameViewController ()
@property (strong, nonatomic) ILBoardViewController *boardViewController;
@property (weak, nonatomic) IBOutlet UIView *boardCollectionControllerContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *wordListContainer;
@property (strong, nonatomic) NSMutableDictionary *wordList;
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
    NSString *formedWord = [self.boardViewController touchEndedWithWord];
    if ([formedWord compare:@""] == NSOrderedSame) return;
    
    ILWord *word = [self.game addNewWord:formedWord];
    
    self.wordList[word.wordId] = word;
    
    [self.wordListView setTags:self.wordsStringArray];
    [self.wordListView setNeedsDisplay];
    
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
    
    [self.wordListContainer setContentOffset:bottomOffset animated:YES];
}

-(NSArray *)wordsStringArray
{
    NSMutableArray *wordList = [NSMutableArray array];
    for (NSString *wordId in self.wordList) {
        ILWord *word = self.wordList[wordId];
        
        [wordList addObject:word.word];
    }
    return [wordList copy];
}

#pragma mark - variables lazy load
-(NSMutableDictionary *)wordList
{
    if (_wordList == nil) _wordList = [NSMutableDictionary dictionary];
    return _wordList;
}

@end
