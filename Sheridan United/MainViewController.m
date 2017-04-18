//
//  ChatViewController.m
//  Sheridan United
//
//  Created by Xcode User on 2017-03-31.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@import FirebaseDatabase;
@import FirebaseStorage;
@import FirebaseAuth;
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize chatBtn,tableView,ref,userList,userData,array;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userData= [[NSMutableDictionary alloc]init];
    self.userList=[NSMutableArray new];
    self.ref=[[FIRDatabase database] reference ];
    [self getUsers];
    self.array = [NSMutableArray arrayWithCapacity:1];
    [array addObject:@"Eezy"];
    [array addObject:@"Tutorials"];
    // Do any additional setup after loading the view.
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
-(void)getUsers/*:(NSMutableArray*)users*/
{
//    
//    [[self.ref child:@"users"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
//    {
//        NSLog(@"users are %@",snapshot);
//        NSDictionary *dict = snapshot.value;
//        NSString *name= [dict objectForKey:@"displayName"];
//        //[userList addObject:name];
//        NSLog(@"the names are %@", name);
//    }
//     ];
//     // return userList;
    [[self.ref child:@"users"]  observeEventType:FIRDataEventTypeValue withBlock:
     ^(FIRDataSnapshot *snapshot)
     {
         self.userData = snapshot.value;
         NSString *avatarURL=[userData objectForKey:@"profileUrl"];
         //self.senderDisplayName=[dict objectForKey:@"displayName"];
        NSLog(@"Dictionary contents: %@",self.userData);
         NSLog(@"Number of users : %lu",self.userData.count); //[self setupAvatar:avatarURL messageId:id];
         
     }];

}
#pragma mark tableview operations
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *keys =[[userData allKeys]sortedArrayUsingSelector:@selector(compare:)];
//    NSString *key = keys[indexPath.row];
//    NSLog(@"key %@", key);
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //cell.textLabel.text = @"afbweifviw";
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [array objectAtIndex:indexPath.row]];
    //cell.detailTextLabel.text = userData[key];
    return cell;
   

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
