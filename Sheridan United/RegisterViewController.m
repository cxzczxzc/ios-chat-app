//
//  RegisterViewController.m
//  Sheridan United
//
//  Created by Xcode User on 2017-04-15.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "RegisterViewController.h"
@import Firebase;
@import FirebaseAuth;
@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize emailTf,passwordTf,nameTf,imgView,registerButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerButtonDidTap:(id)sender {
    [[FIRAuth auth]
     createUserWithEmail:emailTf.text
     password:passwordTf.text
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         if (user) {
             //user found
        //     [self openChat];
         }
         else
         {
             NSLog(@"Unable to register!");
         }
     }
     ];

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
