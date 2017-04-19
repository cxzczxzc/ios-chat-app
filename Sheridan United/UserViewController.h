//
//  UserViewController.h
//  Sheridan United
//
//  Created by Xcode User on 2017-04-17.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface UserViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    FIRDatabaseReference *ref;
    UIImageView *imageView;
    UITextField *nameTf;
    UITextField *campusTf;
    UITextField *phoneTf;
    UITextField *programTf;
    UITextField *tagLineTf;
    UIImagePickerController *imagePicker;
    NSString *profileImageURL;
    UIImage *profileImage;
    
}
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *nameTf;
@property (strong, nonatomic) IBOutlet UITextField *campusTf;
@property (strong, nonatomic) IBOutlet UITextField *phoneTf;
@property (strong, nonatomic) IBOutlet UITextField *programTf;
@property (strong, nonatomic) IBOutlet UITextField *tagLineTf;

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@end
