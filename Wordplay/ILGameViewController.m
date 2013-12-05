//
//  ILGameViewController.m
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/4/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import "ILGameViewController.h"

@interface ILGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *boardCollectionView;

@end

@implementation ILGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.boardCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

- (void)touchesMoved: (NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CGPoint cellPoint = [self.boardCollectionView convertPoint:point fromView:self.view];
    UICollectionViewCell *cell = [self.boardCollectionView cellForItemAtIndexPath:[self.boardCollectionView indexPathForItemAtPoint:cellPoint]];
    cell.backgroundColor = [UIColor redColor];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.boardCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 16;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

@end
