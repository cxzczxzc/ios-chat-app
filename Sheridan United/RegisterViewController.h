//
//  RegisterViewController.h
//  Sheridan United
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface RegisterViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImageView *imgView;
    UITextField *nameTf;
    UITextField *emailTf;
    UITextField *passwordTf;
    UIButton *registerButton;
    UIImagePickerController *imagePicker;
    NSString *profileImageURL;
    UIImage *profileImage;
    FIRDatabaseReference *ref;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextField *nameTf;
@property (strong, nonatomic) IBOutlet UITextField *emailTf;
@property (strong, nonatomic) IBOutlet UITextField *passwordTf;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic)  UIImagePickerController *imagePicker;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) UIImage *profileImage;
@end
