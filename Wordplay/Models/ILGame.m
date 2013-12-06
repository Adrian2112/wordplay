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

@property (strong, nonatomic) Firebase *modelReference;

@end

@implementation ILGame

-(id)init
{
    self = [super initWithFirebaseReference:[ILFirebase newGame]];
    
    if (self == nil) {
        return nil;
    }
    
    self.modelReference = [ILFirebase newGame];
    
    self.name = self.modelReference.name;
    
    return self;
}

-(void)addNewWord:(NSString *)word
{
    Firebase *newRecord = [[ILFirebase scoringList] childByAutoId];
    [newRecord setValue:@{@"game": self.name, @"word": word}];
}

@end
