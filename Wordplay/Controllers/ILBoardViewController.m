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
@property (strong, nonatomic) NSArray *letterMatrix;
@property (strong, nonatomic) NSMutableString *formedWord;

@end

@implementation ILBoardViewController

-(id)initWithLetterMatrix:(NSArray *)letterMatrix
{
    self = [super initWithCollectionViewLayout:[ILBoardViewController collectionViewFlowLayout]];
    if (self == nil) {
        return nil;
    }
    
    self.letterMatrix = letterMatrix;
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
    
    cell.backgroundColor = [UIColor redColor];
    
    [self.formedWord appendString:cell.letterLabel.text];
    [self.wordFormationPath addObject:@(self.indexPathForLastCellTouched.row)];
}

-(void)touchEnded
{
    [self.collectionView reloadData];
    NSLog(@"%@", self.formedWord);
    self.formedWord = nil;
    self.wordFormationPath = nil;
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
    
    NSInteger letterMatrixRow = indexPath.row % 4;
    NSInteger letterMatrixColumn = indexPath.row / 4;
    
    NSString *letter = self.letterMatrix[letterMatrixColumn][letterMatrixRow];
    
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

@end
