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
   NSMutableArray *locationArray;
    NSMutableArray *typeArray;
    IBOutlet UIPickerView *locationPicker;
    IBOutlet UIPickerView *typePicker;
    
}
@property NSMutableArray *locationArray;
@property NSMutableArray *typeArray;
@property IBOutlet UIPickerView *locationPicker;
@property IBOutlet UIPickerView *typePicker;

@end
