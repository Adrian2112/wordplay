//
//  ILWord.h
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/6/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@class ILGame;

@interface ILWord : NSObject

@property (strong, nonatomic) NSString *wordId;
@property (strong, nonatomic) NSString *word;
@property (strong, nonatomic) NSNumber *score;
@property (strong, nonatomic) NSString *userId;

+(instancetype)wordFromSnapshot:(FDataSnapshot *)snapshot;
-(instancetype)initWithWord:(NSString *)word forGame:(ILGame *)game;

-(NSAttributedString *)attributedStringToDisplay;

@end
