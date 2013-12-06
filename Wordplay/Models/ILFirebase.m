//
//  ILFirebase.m
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/5/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import "ILFirebase.h"

static NSString * const kFirebaseURLString = @"https://wordplay.firebaseIO.com";

@implementation ILFirebase

+ (Firebase *)firebase
{
    static Firebase *_firebase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _firebase = [[Firebase alloc] initWithUrl:kFirebaseURLString];
    });
    return _firebase;
}

+ (Firebase *)games
{
    static Firebase *_games = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _games = [[self firebase] childByAppendingPath:@"games"];
    });
    return _games;
}

+ (Firebase *)scoringList
{
    static Firebase *_scoringList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _scoringList = [[self firebase] childByAppendingPath:@"scoringList"];
    });
    return _scoringList;
}

+(Firebase *)newGame
{
    return [[self games] childByAutoId];
}


@end
