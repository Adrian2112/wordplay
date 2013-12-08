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
#import <CHDataStructures/CHOrderedDictionary.h>

@interface ILGameViewController () <ILBoardViewDelegate>
@property (strong, nonatomic) ILBoardViewController *boardViewController;
@property (weak, nonatomic) IBOutlet UIView *boardCollectionControllerContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *wordListContainer;
@property (strong, nonatomic) CHOrderedDictionary *wordList;
@property (strong, nonatomic) DWTagList *wordListView;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;

@property (strong, nonatomic) ILGame *game;

@end

@implementation ILGameViewController

-(instancetype)initWithGame:(ILGame *)game
{
    if ((self = [super init]) == nil) {
        return nil;
    }
    
    self.game = game;
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gameNameLabel.text = self.game.name;
    
    self.boardCollectionControllerContainer.layer.masksToBounds = YES;
    
    self.boardViewController = [[ILBoardViewController alloc] initWithBoardLetters:self.game.boardLetters];
    self.boardViewController.delegate = self;
    [self addChildViewController:self.boardViewController];
    
    [self.boardCollectionControllerContainer addSubview:self.boardViewController.collectionView];
    
    self.wordListView = [[DWTagList alloc] initWithFrame:self.wordListContainer.bounds];
    [self.wordListView setTextShadowOffset:CGSizeZero];
    [self.wordListView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    
    [self.wordListContainer addSubview:self.wordListView];
    
    self.wordListView.automaticResize = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
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
        
        [wordList addObject:word.attributedStringToDisplay];
    }
    return [wordList copy];
}

-(void)updateWordListView
{
    [self.wordListView setTags:self.wordsStringArray];
    
    [self scrollWordsViewToBottom];
}

#pragma mark - ILBoardViewDelegate

-(void)boardView:(ILBoardViewController *)boardView formedWord:(NSString *)formedWord
{
    if ([formedWord compare:@""] == NSOrderedSame) return;
    
    ILWord *word = [self.game addNewWord:formedWord];
    
    self.wordList[word.wordId] = word;
    
    [self updateWordListView];
}

#pragma mark - ILGameDelegate

-(void)game:(ILGame *)game receivedWord:(ILWord *)word
{
    self.wordList[word.wordId] = word;
    
    [self updateWordListView];
}

#pragma mark - variables lazy load
-(CHOrderedDictionary *)wordList
{
    if (_wordList == nil) _wordList = [CHOrderedDictionary dictionary];
    return _wordList;
}

-(ILGame *)game{
    if (_game == nil) {
        _game = [[ILGame alloc] init];
        _game.delegate = self;
    }
    
    return _game;
}

#pragma mark - preferred font size changed
- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    [self.wordListView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.wordListView display];
}

@end
