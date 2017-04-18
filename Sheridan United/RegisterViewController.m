//
//  RegisterViewController.m
//  Sheridan United
//
//  Created by Xcode User on 2017-04-15.
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
- (void)viewDidLoad {
    [super viewDidLoad];
       // Do any additional setup after loading the view.
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
-(void) saveValuesForUser:(FIRUser *) user
{
    self.ref = [[FIRDatabase database] referenceFromURL:@"https://sheridan-united.firebaseio.com"];
    NSString *username = nameTf.text;
    [[[ref child:@"users"] child:user.uid]
     setValue:@{@"senderId": user.uid,@"displayName": username, @"profileUrl": profileImageURL}];
}
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
             NSLog(@"%@", error.localizedDescription);
             return;
         }
         else
         {
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
//- (void) selectPhoto:(UITapGestureRecognizer *)recognizer
//{
//    NSLog(@"select photo clicked");
//    imagePicker =[[UIImagePickerController alloc] init];
//    imagePicker.allowsEditing=YES;
//    imagePicker.delegate=self;
//    [self presentViewController:imagePicker animated:YES completion:nil];
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    if([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)(kUTTypeImage)])
//    {
//        //if media type is image
//        UIImage *chosenImage = (UIImage *)info[UIImagePickerControllerOriginalImage];
//        [imgView setImage:chosenImage];
//        //[self sendImageToDatabase:chosenImage];
//        //image
//    }
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//}

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

//-(void)sendImageToDatabase:(UIImage*)pic
//{
//    FIRStorageReference *storage = [[FIRStorage storage]referenceForURL:@"gs://sheridan-united.appspot.com/"];
//    NSTimeInterval interval = [[[NSDate alloc]init ]timeIntervalSinceReferenceDate];
//    NSString *username=(NSString *)[[FIRAuth auth] currentUser];
//    NSString *filepath= [NSString stringWithFormat: @"%@/%f", username,interval];
//    FIRStorageReference *child=[storage child: filepath];
//    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc]init] ;
//    metadata.contentType=@"image/jpg";
//    NSData *imageData = UIImageJPEGRepresentation(pic, 0.8);
//    [child putData:imageData metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error)
//     {
//         if (!error)
//         {
//             NSLog(@"Image uploaded ");
//         }
//         else if (error)
//         {
//             NSLog(@"Failed to save image message %@",error.description);
//         }
//     }];
//    
//#pragma mark ui methods
//}

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


@end
