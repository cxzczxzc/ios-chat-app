//
//  ChatViewController.m
//  Sheridan United
//
//  Created by Xcode User on 2017-03-31.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)logOutDidTapped:(id)sender {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
