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

@protocol ILGameDelegate;

@interface ILGame : ILFirebaseModel

@property (strong, nonatomic) id <ILGameDelegate> delegate;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *boardLetters;
@property (strong, nonatomic) NSString *userId;

-(id)initWithName:(NSString *)name;

-(ILWord *)addNewWord:(NSString *)word;

@end

@protocol ILGameDelegate <NSObject>

@required
-(void)game:(ILGame *)game receivedWord:(ILWord *)word;

@end
