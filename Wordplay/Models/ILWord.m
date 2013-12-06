//
//  ILWord.m
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/6/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import "ILWord.h"
#import <Firebase/Firebase.h>
#import "ILGame.h"

@implementation ILWord

-(instancetype)initWithWord:(NSString *)word forGame:(ILGame *)game
{
    Firebase *wordReference = [game.wordsReference childByAutoId];
    self = [super initWithFirebaseReference:wordReference];
    if (self == nil) {
        return nil;
    }
    
    self.wordId = wordReference.name;
    self.word = word;
    
    [self.modelReference setValue:@{@"game": game.name, @"word": self.word}];
    
    return self;
}
@end
