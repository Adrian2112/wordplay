//
//  ILWord.m
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/6/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import "ILWord.h"
#import "ILFirebase.h"
#import "ILGame.h"
#import <Firebase/Firebase.h>

@implementation ILWord

+(instancetype)wordFromSnapshot:(FDataSnapshot *)snapshot
{
    ILWord *word = [[ILWord alloc] init];
    
    word.wordId = snapshot.name;
    word.word = snapshot.value[@"word"];
    word.score = snapshot.value[@"score"];
    word.userId = snapshot.value[@"user_id"];
    
    return word;
}

-(instancetype)initWithWord:(NSString *)word forGame:(ILGame *)game
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    Firebase *scoringListReference = [[ILFirebase scoringList] childByAutoId];
    
    self.wordId = scoringListReference.name;
    self.word = word;
    
    [scoringListReference setValue:@{@"game": game.name, @"word": self.word, @"user_id": game.userId}];
    
    return self;
}

-(NSAttributedString *)attributedStringToDisplay
{
    if (self.score) {
        NSString *string = [NSString stringWithFormat:@"%@  %@", self.score, self.word];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        if ([self.score isEqual:@(0)]) {
            [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
        }
        
        return [attributedString copy];
    }
    
    return [[NSAttributedString alloc] initWithString:self.word];
}

@end
