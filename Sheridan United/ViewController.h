//
//  ViewController.h
//  Sheridan United
//


#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    
    IBOutlet UITextField *passwordTextField;
    IBOutlet UILabel *signInLabel;
    IBOutlet UISegmentedControl *signInSelector;
    IBOutlet UILabel *errorLabel;
    IBOutlet UITextField *emailTextField;
    
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *signInSelector;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UILabel *signInLabel;
@end

