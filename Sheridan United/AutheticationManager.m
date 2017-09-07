
//This class contains the code to check if the user is already signed in
// If yes then the user is not required to login again after minimizing the application
// For performance reasons we disregarded this code after intial implementation
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
