//
//  User.h
//  Sheridan United
//
//  Created by Xcode User on 2017-04-18.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject{
    NSString *displayName;
    NSString *profileUrl;
    NSString *senderId;
}
@property(strong,nonatomic) NSString *displayName;
@property(strong,nonatomic) NSString *profileUrl;
@property(strong,nonatomic) NSString *senderId;
- (id) init;
@end
