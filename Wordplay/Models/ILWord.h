//
//  ILWord.h
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/6/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILFirebaseModel.h"

@class ILGame;

@interface ILWord : ILFirebaseModel

@property (strong, nonatomic) NSString *wordId;
@property (strong, nonatomic) NSString *word;

-(instancetype)initWithWord:(NSString *)word forGame:(ILGame *)game;

@end
