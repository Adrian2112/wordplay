//
//  ILGame.h
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/5/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILFirebaseModel.h"
#import "ILWord.h"

@interface ILGame : ILFirebaseModel

@property (strong, nonatomic) Firebase *wordsReference;
@property (strong, nonatomic) NSString *name;

-(ILWord *)addNewWord:(NSString *)word;

@end
