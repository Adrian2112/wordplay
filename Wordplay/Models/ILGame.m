//
//  ILGame.m
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/5/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import "ILGame.h"
#import "ILFirebase.h"
#import <Firebase/Firebase.h>

@interface ILGame ()

// the word reference to listen for new words
@property (strong, nonatomic) Firebase *wordsReference;

@end

@implementation ILGame

-(id)initWithName:(NSString *)name
{
    self = [super initWithFirebaseReference:[ILFirebase newGameWithName:name]];
    
    if (self == nil) {
        return nil;
    }
    
    [self initialize];
    
    return self;
    
}

-(instancetype)init
{
    self = [super initWithFirebaseReference:[ILFirebase newGame]];
    
    if (self == nil) {
        return nil;
    }
    
    self.boardLetters = [self generateBoardLetters];
    [self.modelReference setValue:@{@"board_letters": self.boardLetters}];
    [self initialize];
    
    return self;
}

-(void)initialize
{
    self.wordsReference = [self.modelReference childByAppendingPath:@"words"];
    
    self.name = self.modelReference.name;
    
    self.userId = [NSString stringWithFormat:@"%d", arc4random()];
}

-(void)setDelegate:(id<ILGameDelegate>)delegate
{
    _delegate = delegate;
    [self listenForWords];
}

-(ILWord *)addNewWord:(NSString *)word
{
    return [[ILWord alloc] initWithWord:word forGame:self];
}

-(void)listenForWords
{
    if (self.delegate == nil) return;
    
    [self.wordsReference observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        ILWord *word = [ILWord wordFromSnapshot:snapshot];
        [self.delegate game:self receivedWord:word];
    }];
}

-(NSArray *)generateBoardLetters
{
    NSMutableArray *board = [NSMutableArray array];
    NSArray *dice = @[@"PCHOAS", @"OATTOW", @"LRYTTE", @"VTHRWE",
                      @"EGHWNE", @"SEOTIS", @"ANAEEG", @"IDSYTT",
                      @"MTOICU", @"AFPKFS", @"XLDERI", @"ENSIEU",
                      @"YLDEVR", @"ZNRNHL", @"NMIQHU", @"OBBAOJ"];
    
    for (int i = 0; i < 16; i++) {
        NSString *diceLetters = dice[i];
        NSString *letter = [diceLetters substringWithRange:NSMakeRange(arc4random_uniform(4), 1)];
        [board addObject:letter];
    }
    
    // knuth shuffle
    for (int i = 15; i > 0; i -= 1) {
        int j = floor(arc4random_uniform(i));
        [board exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    return [board copy];
}

-(NSArray *)boardLetters
{
    if (_boardLetters == nil){
        [self getBoardLettersFromServer];
        return nil;
    }
    return _boardLetters;
}

-(void)getBoardLettersFromServer
{
    [self.modelReference observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        self.boardLetters = snapshot.value[@"board_letters"];
        NSLog(@"letters received %@", self.boardLetters);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"boardLettersLoadedFromServer" object:self];

    }];
}

@end
