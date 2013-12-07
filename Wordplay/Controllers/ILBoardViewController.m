//
//  ILBoardViewController.m
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/4/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import "ILBoardViewController.h"
#import "ILLetterCell.h"

#define kLetterCellReuseIdentifier @"letterCell"

@interface ILBoardViewController ()

@property (strong, nonatomic) NSMutableArray *wordFormationPath;
@property (strong, nonatomic) NSIndexPath *indexPathForLastCellTouched;
@property (strong, nonatomic) NSArray *boardLetters;
@property (strong, nonatomic) NSMutableString *formedWord;

@property (strong, nonatomic) NSArray *adjacencies;

@end

@implementation ILBoardViewController

-(instancetype)initWithBoardLetters:(NSArray *)boardLetters
{
    self = [super initWithCollectionViewLayout:[ILBoardViewController collectionViewFlowLayout]];
    if (self == nil) {
        return nil;
    }
    
    self.boardLetters = boardLetters;
    self.collectionView.userInteractionEnabled = NO;
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ILLetterCell" bundle:Nil] forCellWithReuseIdentifier:kLetterCellReuseIdentifier];
    
}

#pragma mark - Handle touches

-(void)touchedAtPoint:(CGPoint)point
{
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    // do nothing if index path is the same as last cell touched
    // or index path is nil
    // or the wordFormationIndexPath already include the index path
    if ([indexPath isEqual:self.indexPathForLastCellTouched]
        || indexPath == nil
        || [self.wordFormationPath containsObject:@(indexPath.row)])
    {
        return;
    }
    
    self.indexPathForLastCellTouched = indexPath;
    
    ILLetterCell *cell = (ILLetterCell *)[self.collectionView cellForItemAtIndexPath:self.indexPathForLastCellTouched];
    
    [self.formedWord appendString:cell.letterLabel.text];
    [self.wordFormationPath addObject:@(self.indexPathForLastCellTouched.row)];
    
    if (![self isValidPath:self.wordFormationPath]) {
        [self touchEndedWithWord];
        return;
    }
    
    [self colorPath:self.wordFormationPath];
}

-(NSString *)touchEndedWithWord
{
    [self.collectionView reloadData];
    NSString *word = self.formedWord;
    self.formedWord = nil;
    self.wordFormationPath = nil;
    
    return word;
}

-(BOOL)isValidPath:(NSArray *)path
{
    NSNumber *previousPosition = path[0];
    for (int i = 1; i < path.count; i++) {
        NSNumber *currentPosition = path[i];
        NSArray *adjacenciesForPreviousLetter = self.adjacencies[[previousPosition integerValue]];
        
        if (![adjacenciesForPreviousLetter containsObject:currentPosition]) return NO;
        previousPosition = currentPosition;
    }
    return YES;
}

-(void)colorPath:(NSArray *)path
{
    for (int i = 0; i < path.count - 1; i++) {
        NSNumber *item = path[i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[item integerValue] inSection:0];
        ILLetterCell *cell = (ILLetterCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor grayColor];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[path.lastObject integerValue] inSection:0];
    ILLetterCell *cell = (ILLetterCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
}

#pragma mark - Collection View Flow Layout generator

+(UICollectionViewFlowLayout *)collectionViewFlowLayout
{
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    collectionViewFlowLayout.minimumLineSpacing = 4;
    collectionViewFlowLayout.minimumInteritemSpacing = 0;
    collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    collectionViewFlowLayout.itemSize = CGSizeMake(75, 75);
    
    return collectionViewFlowLayout;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 16;
}

-(ILLetterCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ILLetterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLetterCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSString *letter = self.boardLetters[indexPath.row];
    
    cell.letterLabel.text = letter;
    
    return cell;
}

# pragma mark - Lazy load variables

-(NSMutableArray *)wordFormationPath
{
    if (_wordFormationPath == nil) _wordFormationPath = [NSMutableArray array];
    return _wordFormationPath;
}

-(NSMutableString *)formedWord
{
    if (_formedWord == nil) _formedWord = [NSMutableString string];
    return _formedWord;
}

-(NSArray *)adjacencies
{
    if (_adjacencies == nil)
    {
        _adjacencies = @[
                         @[@1,@4,@5],
                         @[@0,@2,@4,@5,@6],
                         @[@1,@3,@5,@6,@7],
                         @[@2,@6,@7],
                         @[@0,@1,@5,@8,@9],
                         @[@0,@1,@2,@4,@6,@8,@9,@10],
                         @[@1,@2,@3,@5,@7,@9,@10,@11],
                         @[@2,@3,@6,@10,@11],
                         @[@4,@5,@9,@12,@13],
                         @[@4,@5,@6,@8,@10,@12,@13,@14],
                         @[@5,@6,@7,@9,@11,@13,@14,@15],
                         @[@6,@7,@10,@14,@15],
                         @[@8,@9,@13],
                         @[@8,@9,@10,@12,@14],
                         @[@9,@10,@11,@13,@15],
                         @[@10,@11,@14]
        ];
    }
    
    return _adjacencies;
}

@end
