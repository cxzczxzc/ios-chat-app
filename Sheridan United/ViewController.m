//
//  ViewController.m
//  Sheridan United
//
//  Created by Xcode User on 2017-03-31.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
@import Firebase;
@import FirebaseAuth;

@interface ViewController ()

@end

@implementation ViewController
@synthesize loginButton,errorLabel,registerButtton,passwordTextField,emailTextField,signInLabel,signInSelector;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user) {
             NSLog(@"User's name %@", user.displayName);
            [self openChat];
            NSLog(@"User is signed in with uid: %@", user.uid);
        } else {
            NSLog(@"No user is signed in.");
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)loginDidTapped:(id)sender {
    //validate email and password inputs
        if (emailTextField.text.length > 0 && passwordTextField.text.length>0)
        {
        //sign in
        //Firebase verifies user
        [[FIRAuth auth] signInWithEmail:emailTextField.text
                               password:passwordTextField.text
                             completion:^(FIRUser *user, NSError *error) {
                                 if (user) {
                                     [self openChat];
                                 }
                                 else{
                                     errorLabel.text =@"Unable to sign in!";
                                 }
                             }];
         }
        else
        {
            errorLabel.text=@"Please check your input!";

            //error handling
        }
}

- (IBAction)registerDidTapped:(id)sender {
    [self performSegueWithIdentifier:@"LoginToRegister" sender:self];
    }
-(IBAction)unwindToThisViewController:(UIStoryboardSegue *)sender
{
    
}
-(void)openChat
{
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
//  printf("login did tapped");
//create a main storyboard instance
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
//    //From main storyboard instantiate a navigation controller
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"NavigationVC"];
//    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:vc animated:YES completion:NULL];
//    //Get the app delegate
//    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//
//    //Set navigation controller as root view controller
//    appDelegate.window.rootViewController = vc;
//
@end
