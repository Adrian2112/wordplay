//
//  ILGame.h
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/5/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILFirebaseModel.h"

@interface ILGame : ILFirebaseModel

@property (strong, nonatomic) NSString *name;

-(void)addNewWord:(NSString *)word;

@end
