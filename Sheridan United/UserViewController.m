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
@synthesize phoneTf,nameTf,imageView,programTf,tagLineTf,campusTf,saveBtn,ref;

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
    
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    [self saveValuesForUser: currentUser];
    
}

-(void) saveValuesForUser:(FIRUser *) user
{
    NSString *name = nameTf.text;
    NSString *campus =campusTf.text;
    NSString *phone =phoneTf.text;
    NSString *program = programTf.text;
    NSString *tagline = tagLineTf.text;
    // NSDictionary *userInformation = @{@"email" : name};
    //[FIRAuth auth]
    self.ref = [[FIRDatabase database] referenceFromURL:@"https://sheridan-united.firebaseio.com"];
    
    [[[ref child:@"users"] child:user.uid]
     updateChildValues:@{@"senderId": user.uid,@"displayName": name, @"campus": campus, @"phone": phone, @"program": program, @"tagline": tagline}];
    
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
-(IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"UserToMain" sender:self];
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
