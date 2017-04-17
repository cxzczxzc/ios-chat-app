//
//  UserViewController.h
//  Sheridan United
//
//  Created by Xcode User on 2017-04-17.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *nameTf;
@property (strong, nonatomic) IBOutlet UITextField *campusTf;
@property (strong, nonatomic) IBOutlet UITextField *phoneTf;
@property (strong, nonatomic) IBOutlet UITextField *programTf;
@property (strong, nonatomic) IBOutlet UITextField *tagLineTf;

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@end
