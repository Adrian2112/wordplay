//
//  ILFirebaseModel.m
//  Wordplay
//
//  Created by Adrian Gonzalez on 12/5/13.
//  Copyright (c) 2013 Adrian Gonzalez. All rights reserved.
//

#import "ILFirebaseModel.h"

@implementation ILFirebaseModel

-(instancetype)initWithFirebaseReference:(Firebase *)reference
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.modelReference = reference;
    
    return self;
}

@end
