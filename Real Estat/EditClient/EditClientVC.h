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

@interface EditClientVC : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
   
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *lastname;
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *officePhone;
    IBOutlet UITextField *txtMr;
    IBOutlet UITextField *org;
    IBOutlet UITextField *spoucePhone;
    IBOutlet UITextField *strategist;
    IBOutlet UITextField *email;
    IBOutlet UITextField *assignTo;
    IBOutlet UITextField *price;
    
    IBOutlet UITextView *clientNotes;
    IBOutlet UITextView *agentNotes;
    UITextField *current;
    
    NSMutableArray *arrSalute,*arrPrice,*arrOrg;
    
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
    IBOutlet UIButton *btnSave;
    
    IBOutlet UITextField *suburb;
    
    NSMutableArray *tblDataArray;
    NSMutableArray *saveDataArray;

    
}
@property (strong,nonatomic)NSMutableDictionary *dictInfo;
@property (assign,nonatomic)BOOL isEditable;
@property (strong, nonatomic) DownPicker *downPicker;
- (IBAction)hideDatepickerView:(id)sender;
- (IBAction)dismissPicker:(id)sender;
- (IBAction)saveRecord:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblView;



@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewForTbl;
@property (strong, nonatomic) IBOutlet UIView *btnBgView;
- (IBAction)saveBtnTapped:(id)sender;
- (IBAction)canBtnTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *saveBtnTapped;

@property (strong, nonatomic) NSString *isDataEditable;



@end
    //EditClientList