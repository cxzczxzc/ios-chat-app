

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
