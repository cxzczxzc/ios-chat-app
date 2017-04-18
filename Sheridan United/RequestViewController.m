//
//  RequestViewController.m
//  Sheridan United
//
//  Created by Xcode User on 2017-04-18.
//  Copyright © 2017 Sheridan College. All rights reserved.
//

#import "RequestViewController.h"
#import "AppDelegate.h"

@interface RequestViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UISwitch *paymentSwitch;



@end

@implementation RequestViewController
@synthesize typeArray,locationArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // NSMutableArray *locationArray = [NSMutableArray array];
    [locationArray addObject:@"Davis"];
    [locationArray addObject:@"HMC"];
    [locationArray addObject:@"Trafalgar"];
    
    
    [typeArray addObject:@"Books"];
    [typeArray addObject:@"Food"];
    [typeArray addObject:@"Electronics"];
    [typeArray addObject:@"Miscellaneous"];
    
    
    _locationPicker.delegate = self;
    _locationPicker.dataSource = self;
    _locationPicker.showsSelectionIndicator = YES;
    //[self.view addSubview:];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    NSLog(@"1");
    return 1;// or the number of vertical "columns" the picker will show...
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
     NSLog(@"2");
    if(pickerView == self.locationPicker){
               if (locationArray!=nil) {
                  return [locationArray count];
               }
    }
    else if(pickerView == self.typePicker)
    {
        if (typeArray!=nil) {
            return [typeArray count];
        }
        
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
     NSLog(@"3");
    //you can also write code here to descide what data to return depending on the component ("column")
   if(pickerView == self.locationPicker){
        if (locationArray!=nil) {
            return [locationArray objectAtIndex:row];//assuming the array contains strings..
        }

    }
    else if(pickerView == self.typePicker){
        if (typeArray!=nil) {
            return [typeArray objectAtIndex:row];//assuming the array contains strings..
        }

    }
    return @"";}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
