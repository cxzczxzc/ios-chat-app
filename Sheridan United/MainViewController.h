//
//  ChatViewController.h
//  Sheridan United
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
