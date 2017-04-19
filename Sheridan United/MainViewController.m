//
//  ChatViewController.m
//  Sheridan United
//
//  Created by Saad Ahmad on 2017-03-31.
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
//instantiate the view with a Firebase database instance
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userList=[NSMutableArray new];
    self.ref=[[FIRDatabase database] reference ];
    [self getUsers];
    // Do any additional setup after loading the view.
}
//tries to sign out the user and returns error if not successful
- (IBAction)logOutDidTapped:(id)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    [self performSegueWithIdentifier:@"Logout" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//segues to handle the navigation
- (IBAction)chatButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"MainToChat" sender:self];}

- (IBAction)userButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"MainToUser" sender:self];
}

- (IBAction)requestButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"MainToRequest" sender:self];}
#pragma mark db methods
//gets the list of all users from firebase which will be used to append to the tableview
-(void)getUsers
{//looking up the 'users' child of firebase
    //snapshot contains a dictionary of all the users

    [[self.ref child:@"users"]  observeEventType:FIRDataEventTypeChildAdded withBlock:
     ^(FIRDataSnapshot *snapshot)
     {
         User *user= [[User alloc]init];
         NSDictionary *dict = snapshot.value;
         NSLog(@"userdic %@", dict);
         [user setValuesForKeysWithDictionary:dict];
         [self.userList addObject:user];
         //loading the tableview after populating it in the main thread
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
//populating the tableView cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    //again reloading the tableview in the main thread
    [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                     withObject:nil
                                  waitUntilDone:NO];
    //assigning an image to the tableview cell
    //this is where we use SDWebImage
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[userList[indexPath.row] profileUrl]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.textLabel.text=[userList[indexPath.row] displayName];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    NSString *str=[[userList[indexPath.row]request1title] stringByAppendingString:[userList[indexPath.row]request1location]];
    cell.detailTextLabel.text=str;
    cell.detailTextLabel.font = [UIFont italicSystemFontOfSize:15];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
