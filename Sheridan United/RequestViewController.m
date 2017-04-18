//
//  RequestViewController.m
//  Sheridan United
//
//  Created by Xcode User on 2017-04-18.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "RequestViewController.h"
#import "AppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
@import Firebase;
@import FirebaseAuth;
@interface RequestViewController()
@property (weak, nonatomic) IBOutlet UISwitch *paymentSwitch;
@end

@implementation RequestViewController
@synthesize locationArray,locationPicker,typePicker, typeArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    locationArray= [[NSMutableArray alloc]init];
    [locationArray addObject:@"Davis"];
    [locationArray addObject:@"HMC"];
    [locationArray addObject:@"Trafalgar"];
    
    typeArray= [[NSMutableArray alloc]init];
    [typeArray addObject:@"Books"];
    [typeArray addObject:@"Food"];
    [typeArray addObject:@"Electronics"];
    [typeArray addObject:@"Miscellaneous"];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;// or the number of vertical "columns" the picker will show...
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView == self.locationPicker){
        NSLog(@"location");
        if (locationArray!=nil) {
            return [locationArray count];
        }
    }
    if(pickerView == self.typePicker)
    {
        NSLog(@"type");
        
        if (typeArray!=nil) {
            return [typeArray count];
        }
        
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    //you can also write code here to descide what data to return depending on the component ("column")
    if(pickerView == self.locationPicker){
        if (locationArray!=nil) {
            return [locationArray objectAtIndex:row];//assuming the array contains strings..
        }
    }
    if(pickerView == self.typePicker){
        if (typeArray!=nil) {
            return [typeArray objectAtIndex:row];//assuming the array contains strings..
        }
    }
    return @"";}

- (IBAction)requestButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"RequestToMain" sender:self];}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
