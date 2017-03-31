//
//  ViewController.m
//  Sheridan United
//
//  Created by Xcode User on 2017-03-31.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize loginButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    loginButton.layer.borderWidth=2.0;
    loginButton.layer.borderColor=[UIColor whiteColor].CGColor;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)loginDidTapped:(id)sender {
    printf("login did tapped");
    //create a main storyboard instance
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    //From main storyboard instantiate a navigation controller
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"NavigationVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
    //Get the app delegate
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //Set navigation controller as root view controller
    appDelegate.window.rootViewController = vc;
    
}

@end
