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

@end

@implementation ILGame

-(id)init
{
    self = [super initWithFirebaseReference:[ILFirebase newGame]];
    
    if (self == nil) {
        return nil;
    }
    
    self.wordsReference = [self.modelReference childByAppendingPath:@"words"];
    
    self.name = self.modelReference.name;
    
    return self;
}

-(ILWord *)addNewWord:(NSString *)word
{
    return [[ILWord alloc] initWithWord:word forGame:self];
}

-(void)listenForWords
{
    [self.wordsReference observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
    }];
}

@end
