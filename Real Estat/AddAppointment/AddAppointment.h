//
//  AddAppointment.h
//  Real Estat
//
//  Created by NLS32-MAC on 28/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"
#import "UIDownPicker.h"

@interface AddAppointment : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *txtBookWith;
    IBOutlet UITextField *txtDate;
    IBOutlet UITextField *txtAvailablity;
    IBOutlet UITextField *txtType;
    NSMutableDictionary *dictResponce;
    NSMutableArray *arrWith;
    UIView *viewbg_Popup;
    NSMutableArray *ArrAlClient;
    NSMutableArray *arrvalueType;
    NSMutableArray *arrAvailable;
    IBOutlet UIView *datepickerView;
    IBOutlet UIDatePicker *datepicker;
    
}
@property (strong, nonatomic) DownPicker *downPicker;
- (IBAction)hideDatepickerView:(id)sender;
- (IBAction)dismissPicker:(id)sender;
- (IBAction)saveRecord:(id)sender;

@property (strong,nonatomic) NSString *fromWhichVC;

@property (strong,nonatomic) NSString *nameStr;
@property (strong,nonatomic) NSString *idStr;


@end
    //EditClientList