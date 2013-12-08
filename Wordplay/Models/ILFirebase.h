//
//  ILFirebase.h
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/5/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface ILFirebase : NSObject

+(Firebase *)firebase;
+(Firebase *)games;
+(Firebase *)scoringList;
+(Firebase *)newGame;
+(Firebase *)newGameWithName:(NSString *)name;

@end
