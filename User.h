//
//  User.h
//  Sheridan United
//
//  Created by Saad Ahmad on 2017-04-18.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import <Foundation/Foundation.h>
//this class is used to store the data retrieved from Firebase
//this class is then used to populate the tableview in the main view controller
@interface User : NSObject{
    NSString *campus;
    NSString *displayName;
    NSString *phone;
    NSString *profileUrl;
    NSString *program;
    NSString *request1description;
    NSString *request1location;
    NSString *request1payment;
    NSString *request1title;
    NSString *request1type;
    NSString *senderId;
    NSString *tagline;
}
@property(strong, nonatomic) NSString *campus;
@property(strong, nonatomic) NSString *displayName;
@property(strong, nonatomic) NSString *phone;
@property(strong, nonatomic) NSString *profileUrl;
@property(strong, nonatomic) NSString *program;
@property(strong, nonatomic) NSString *request1description;
@property(strong, nonatomic) NSString *request1location;
@property(strong, nonatomic) NSString *request1payment;
@property(strong, nonatomic) NSString *request1title;
@property(strong, nonatomic) NSString *request1type;
@property(strong, nonatomic) NSString *senderId;
@property(strong, nonatomic) NSString *tagline;
- (id) init;
@end
