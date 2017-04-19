//
//  User.m
//  Sheridan United
//
//  Created by Saad Ahmad on 2017-04-18.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "User.h"
//this class is used to store the data retrieved from Firebase
//this class is then used to populate the tableview in the main view controller
@implementation User
@synthesize displayName,profileUrl,senderId;

- (id) init
    {
        self = [super init];
        if (self) {
            
        }
        return self;
    }

@end
