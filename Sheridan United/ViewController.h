//
//  ViewController.h
//  Sheridan United
//
//  Created by Xcode User on 2017-03-31.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    
     IBOutlet UIButton *loginButtton;
     IBOutlet UITextField *passwordTextField;
     IBOutlet UILabel *signInLabel;
     IBOutlet UISegmentedControl *signInSelector;
    IBOutlet UILabel *errorLabel;
    IBOutlet UITextField *emailTextField;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *signInSelector;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UILabel *signInLabel;
@end

