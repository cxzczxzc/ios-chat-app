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
}
@property (strong, nonatomic) IBOutlet UIButton *chatBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet FIRDatabaseReference *ref;
@property (strong, nonatomic)  NSMutableArray *userList;
@property (weak, nonatomic) IBOutlet UIButton *createNewRequest;

@end
