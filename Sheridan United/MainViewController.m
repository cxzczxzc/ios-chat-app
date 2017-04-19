//
//  ChatViewController.m
//  Sheridan United
//
//  Created by Xcode User on 2017-03-31.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "UIImageView+WebCache.h"
@import FirebaseDatabase;
@import FirebaseStorage;
@import FirebaseAuth;
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize chatBtn,tableView,ref,userList;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userList=[NSMutableArray new];
    self.ref=[[FIRDatabase database] reference ];
    [self getUsers];
}
- (IBAction)logOutDidTapped:(id)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    printf("logOutDidTapped pressed");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    //From main storyboard instantiate a View Controller
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
    //Get the app delegate
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //Set navigation controller as root view controller
    appDelegate.window.rootViewController = vc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chatButtonPressed:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    //From main storyboard instantiate a View Controller
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ChatVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
    //Get the app delegate
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //Set navigation controller as root view controller
    appDelegate.window.rootViewController = vc;
}
#pragma mark db methods
-(void)getUsers
{

    [[self.ref child:@"users"]  observeEventType:FIRDataEventTypeChildAdded withBlock:
     ^(FIRDataSnapshot *snapshot)
     {
         User *user= [[User alloc]init];
         NSDictionary *dict = snapshot.value;
         [user setValuesForKeysWithDictionary:dict];
         [self.userList addObject:user];
         [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                           withObject:nil
                                        waitUntilDone:NO];
     }];
}
#pragma mark tableview operations
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                     withObject:nil
                                  waitUntilDone:NO];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[userList[indexPath.row] profileUrl]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.textLabel.text=[userList[indexPath.row] displayName];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
