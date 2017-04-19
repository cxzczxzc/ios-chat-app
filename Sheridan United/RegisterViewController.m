//
//  RegisterViewController.m
//  Sheridan United
//
//  Created by Surbhi Handa on 2017-04-15.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "RegisterViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
@import Firebase;
@import FirebaseAuth;
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webViewBG;

@end

@implementation RegisterViewController
@synthesize emailTf,passwordTf,nameTf,profileImage,imgView,registerButton,profileImageURL,imagePicker,label,ref;
//the view is loaded along with UI items formatting
- (void)viewDidLoad {
    [super viewDidLoad];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    self.emailTf.attributedPlaceholder = str;
    str = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    self.nameTf.attributedPlaceholder=str;
    str = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    self.passwordTf.attributedPlaceholder=str;
    self.registerButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.registerButton.layer.borderWidth = 2.0;
    
    // Do any additional setup after loading the view.
    
    //HTML file is used to display the video that plays in the background
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"ViewWeb" ofType:@"html"];
    NSURL *htmlURL = [[NSURL alloc] initFileURLWithPath:htmlPath];
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:htmlURL];
    //webViewBG is used to display the html content in the background
    [self.webViewBG loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[htmlURL URLByDeletingLastPathComponent]];
    
    imgView.layer.cornerRadius=imgView.frame.size.height/2;
    imgView.clipsToBounds=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction:)];
    tap.numberOfTapsRequired=1;
    imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:tap];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerButtonDidTap:(id)sender {
    [self registerNewUser];
}
//this method is used to save the values for user
-(void) saveValuesForUser:(FIRUser *) user
{
    self.ref = [[FIRDatabase database] referenceFromURL:@"https://sheridan-united.firebaseio.com"];
    NSString *name = nameTf.text;
    // NSString *campus = "";
    //initally the profile options are added as empty strings
    //later on once the user is logged in, the userviewcontroller class
    // can be used to append to these fields
    [[[ref child:@"users"] child:user.uid]
     setValue:@{@"senderId": user.uid,@"displayName": name, @"campus": @"", @"phone": @"", @"program": @"", @"tagline": @"", @"request1title": @"", @"request1description": @"", @"request1location": @"", @"request1payment": @"", @"request1type": @"",@"profileUrl": profileImageURL}];
}
//calls the creatrUserWithEmail method of Firebase
// other options like google login, facebook login and even anonymous login can be implemented using almost similar methods
- (void) registerNewUser
{
    NSString *email = emailTf.text;
    NSString *password = passwordTf.text;
    [[FIRAuth auth]
     createUserWithEmail:email
     password:password
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error)
     {
         if (error)
         {
             //display an alert box in case of wrong input
             NSLog(@"error %@", error.description);
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration Error" message:@"Unable to register user! Please try again." preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
             
             [alert addAction:ok];
             
             [self presentViewController:alert animated:YES completion:nil];
         }
         else
         {//display an alert box prompting the user to sign in through the login page
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration Successful" message:@"Please login with your credentials!" preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
             
             [alert addAction:ok];
             
             [self presentViewController:alert animated:YES completion:nil];

            // [self openChat];
             [self saveProfileImage];
         }
     }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
    imgView.image = profileImage;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
//gets a reference to firebase storage
//Firebase storage is used to store media
//the method below is used to store the user's profile picture
- (void) saveProfileImage
{
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    //NSString *username = nameTf.text;
    
    if (imgView.image != nil)
    {
        FIRStorageReference *storageRef = [[FIRStorage storage]referenceForURL:@"gs://sheridan-united.appspot.com/"];
        NSString *imageID = [[NSUUID UUID] UUIDString];
        NSString *imageName = [NSString stringWithFormat:@"Profile Pictures/%@.jpg",imageID];
        FIRStorageReference *profilePicRef = [storageRef child:imageName];
        FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
        metadata.contentType = @"image/jpeg";
        NSData *imageData = UIImageJPEGRepresentation(self.imgView.image, 0.8);
        [profilePicRef putData:imageData metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error)
         {
             if (!error)
             {
                 profileImageURL = metadata.downloadURL.absoluteString;
                 [self saveValuesForUser: currentUser];
                 
             }
             else if (error)
             {
                 NSLog(@"Failed to Register User with profile image");
             }
         }];
    }
}
//this method can be called in case of successful 
-(void)openChat
{
    [self performSegueWithIdentifier:@"LoginToMain" sender:self];
}

@end
