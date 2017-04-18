//
//  AutheticationManager.m
//  Sheridan United
//
//  Created by Xcode User on 2017-04-18.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "AutheticationManager.h"
@import  Firebase;
@import FirebaseAuth;
@implementation AutheticationManager

    -(void)isLoggedIn
    {
        [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
            if (user) {
                NSLog(@"User's name %@", user.displayName);
                NSLog(@"User is signed in with uid: %@", user.uid);
            } else {
                NSLog(@"No user is signed in.");
                NSError *signOutError;
                BOOL status = [[FIRAuth auth] signOut:&signOutError];
                if (!status) {
                    NSLog(@"Error signing out: %@", signOutError);
                    return;
                }
            }
        }];
    }


@end
