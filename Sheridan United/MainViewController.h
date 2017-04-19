//
//  ChatViewController.h
//  Sheridan United
//
//  Created by Xcode User on 2017-03-31.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIButton *chatBtn;
    IBOutlet UITableView *tableView;
     FIRDatabaseReference *ref;
    NSMutableArray *userList;
    NSDictionary *userData;
}
@property (strong, nonatomic) IBOutlet UIButton *chatBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet NSMutableArray *userList;
@property (strong, nonatomic) IBOutlet NSDictionary *userData;
@property (strong, nonatomic) IBOutlet NSArray *array;
@property (nonatomic)  NSInteger numRows;
@end
