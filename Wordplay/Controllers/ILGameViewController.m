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
@property (weak, nonatomic) IBOutlet UIScrollView *currentUserWordListContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *opponentUserWordListContainer;
@property (strong, nonatomic) DWTagList *currentUserWordListView;
@property (strong, nonatomic) DWTagList *opponentUserWordListView;
@property (strong, nonatomic) CHOrderedDictionary *currentUserWordListDictionary;
@property (strong, nonatomic) NSMutableArray *opponentWordList;
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
    
    self.currentUserWordListView = [[DWTagList alloc] initWithFrame:self.currentUserWordListContainer.bounds];
    self.opponentUserWordListView = [[DWTagList alloc] initWithFrame:self.opponentUserWordListContainer.bounds];
    
    [self.currentUserWordListView setTextShadowOffset:CGSizeZero];
    [self.currentUserWordListView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.opponentUserWordListView setTextShadowOffset:CGSizeZero];
    [self.opponentUserWordListView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    
    [self.currentUserWordListContainer addSubview:self.currentUserWordListView];
    [self.opponentUserWordListContainer addSubview:self.opponentUserWordListView];
    
    self.currentUserWordListView.automaticResize = YES;
    self.opponentUserWordListView.automaticResize = YES;
    
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

-(void)scrollWordsViewToBottom:(UIScrollView *)scrollView withWordListView:(DWTagList *)wordListView
{
    CGFloat yPosition = wordListView.contentSize.height - scrollView.frame.size.height;
    CGPoint bottomOffset = CGPointMake(0, yPosition < 0 ? 0 : yPosition);
    
    scrollView.contentSize = wordListView.contentSize;
    
    [scrollView setContentOffset:bottomOffset animated:YES];
}

-(NSArray *)wordsStringArray
{
    NSMutableArray *wordList = [NSMutableArray array];
    for (NSString *wordId in self.currentUserWordListDictionary) {
        ILWord *word = self.currentUserWordListDictionary[wordId];
        
        [wordList addObject:word.attributedStringToDisplay];
    }
    return [wordList copy];
}

-(void)updateCurrentUserWordListView
{
    [self.currentUserWordListView setTags:self.wordsStringArray];
    
    [self scrollWordsViewToBottom:self.currentUserWordListContainer withWordListView:self.currentUserWordListView];
}

#pragma mark - ILBoardViewDelegate

-(void)boardView:(ILBoardViewController *)boardView formedWord:(NSString *)formedWord
{
    if ([formedWord compare:@""] == NSOrderedSame) return;
    
    ILWord *word = [self.game addNewWord:formedWord];
    
    self.currentUserWordListDictionary[word.wordId] = word;
    
    [self updateCurrentUserWordListView];
}

#pragma mark - ILGameDelegate

-(void)game:(ILGame *)game receivedWord:(ILWord *)word
{
    NSLog(@"received word %@", word.word);
    if ([self isWordFromCurrentUser:word]) {
        self.currentUserWordListDictionary[word.wordId] = word;
        [self updateCurrentUserWordListView];
    } else {
        [self.opponentWordList addObject:word.attributedStringToDisplay];
        [self.opponentUserWordListView setTags:self.opponentWordList];
        [self scrollWordsViewToBottom:self.opponentUserWordListContainer withWordListView:self.opponentUserWordListView];
    }
}

#pragma mark - variables lazy load
-(CHOrderedDictionary *)currentUserWordListDictionary
{
    if (_currentUserWordListDictionary == nil) _currentUserWordListDictionary = [CHOrderedDictionary dictionary];
    return _currentUserWordListDictionary;
}

-(ILGame *)game{
    if (_game == nil) {
        _game = [[ILGame alloc] init];
        _game.delegate = self;
    }
    
    return _game;
}

-(NSMutableArray *)opponentWordList
{
    if (_opponentWordList == nil) _opponentWordList = [NSMutableArray array];
    return _opponentWordList;
}

#pragma mark - preferred font size changed
- (void)preferredContentSizeChanged:(NSNotification *)aNotification {
    [self.currentUserWordListView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.currentUserWordListView display];
    [self.opponentUserWordListView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [self.opponentUserWordListView display];
}

-(BOOL)isWordFromCurrentUser:(ILWord *)word
{
    return [word.userId compare:self.game.userId] == NSOrderedSame;
}

@end
