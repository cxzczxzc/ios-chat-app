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
@property (weak, nonatomic) IBOutlet UIWebView *webViewBG;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation ViewController
@synthesize errorLabel,passwordTextField,emailTextField,signInLabel,signInSelector;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"ViewWeb" ofType:@"html"];
    NSURL *htmlURL = [[NSURL alloc] initFileURLWithPath:htmlPath];
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:htmlURL];
    
    [self.webViewBG loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[htmlURL URLByDeletingLastPathComponent]];
    
    self.login.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.login.layer.borderWidth = 2.0;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
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
                                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign in Error" message:@"User does not exist or bad login credentials!" preferredStyle:UIAlertControllerStyleAlert];
                                     
                                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                                     
                                     [alert addAction:ok];
                                     
                                     [self presentViewController:alert animated:YES completion:nil];
                                     
                                 }
                             }];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Input Error" message:@"Please enter a valid email!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
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
    [self performSegueWithIdentifier:@"LoginToMain" sender:self];
}
@end
