//
//  RequestViewController.m
//  Sheridan United
//


#import "RequestViewController.h"
#import "AppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
@import Firebase;
@import FirebaseAuth;
@interface RequestViewController()
@end

@implementation RequestViewController
@synthesize locationArray,locationPicker,typePicker, typeArray,titleTf,descTv, saveButton,ref, paymentSw;
//the arrays are initialized which will be used to populate picker views in viewDidLoad method
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
//an instance of current user is created
//values are stored in database for the current user (every user has a unique id, we can query firebase using the unique ids)
- (IBAction)saveButtonDidTapped:(id)sender {
    NSLog(@"1");
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    [self saveValuesForUser: currentUser];
    NSLog(@"2");
}
//the user enters his details which are retrieved from the textfields
-(void) saveValuesForUser:(FIRUser *) user
{
    NSString *title = titleTf.text;
    NSString *description = descTv.text;
    NSString *location;
    NSString *type;
    NSString *payment;
    
    NSInteger row;
    
    if(paymentSw.isOn)payment = @"Yes";
    else payment = @"No";
    
    row = [locationPicker selectedRowInComponent:0];
    location = [locationArray objectAtIndex:row];
    NSString *str=[@" at: " stringByAppendingString:location];
    row = [typePicker selectedRowInComponent:0];
    type = [typeArray objectAtIndex:row];
    //reference to the firebase database where these values are stored
    self.ref = [[FIRDatabase database] referenceFromURL:@"https://sheridan-united.firebaseio.com"];
    //we look for the child 'users' - equivalent of a table in RDBMS systems and append with keys the values entered by the user in the UI
    [[[ref child:@"users"] child:user.uid]
updateChildValues:@{@"request1title":title , @"request1description":description, @"request1location":str, @"request1payment":payment, @"request1type":type}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark PickerView methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;// or the number of vertical "columns" the picker will show...
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView == self.locationPicker){
               if (locationArray!=nil) {
            return [locationArray count];
        }
    }
    if(pickerView == self.typePicker)
    {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
