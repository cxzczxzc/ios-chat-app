//
//  UserViewController.m
//  Sheridan United
//
//  Created by Xcode User on 2017-04-17.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "UserViewController.h"
@import Firebase;
@interface UserViewController ()

@end

@implementation UserViewController
@synthesize phoneTf,nameTf,imageView,programTf,tagLineTf,campusTf,saveBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    imageView.layer.cornerRadius=imageView.frame.size.height/2;
    imageView.clipsToBounds=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction:)];
    tap.numberOfTapsRequired=1;
    imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveButtonDidTapped:(id)sender {
    
}
-(void)updateUserData
{
//    NSString *key = [[_ref child:@"posts"] childByAutoId].key;
//    NSDictionary *post = @{@"displayName": userID,
//                           @"author": username,
//                           @"title": title,
//                           @"body": body};
//    NSDictionary *childUpdates = @{[@"/posts/" stringByAppendingString:key]: post,
//                                   [NSString stringWithFormat:@"/user-posts/%@/%@/", userID, key]: post};
//    [_ref updateChildValues:childUpdates];
}
#pragma mark image methods
- (IBAction)chooseImageAction:(id)sender

{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info

{
    picker.delegate = self;
    profileImage = info[UIImagePickerControllerEditedImage];
    imageView.image = profileImage;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    [picker dismissViewControllerAnimated:YES completion:NULL];
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
