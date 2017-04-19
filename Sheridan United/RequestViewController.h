//
//  RequestViewController.h
//  Sheridan United
//
//  Created by Xcode User on 2017-04-18.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface RequestViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UITextField *titleTf;
    UITextView *descTv;
    FIRDatabaseReference *ref;
   NSMutableArray *locationArray;
    NSMutableArray *typeArray;
    IBOutlet UIPickerView *locationPicker;
    IBOutlet UIPickerView *typePicker;
    IBOutlet UIButton *saveButton;
    IBOutlet UISwitch *paymentSw;
}
@property (strong, nonatomic) IBOutlet UITextField *titleTf;
@property (strong, nonatomic) IBOutlet UITextView *descTv;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property NSMutableArray *locationArray;
@property NSMutableArray *typeArray;
@property IBOutlet UIPickerView *locationPicker;
@property IBOutlet UIPickerView *typePicker;
@property IBOutlet UIButton *saveButton;
@property IBOutlet UISwitch *paymentSw;

@end
