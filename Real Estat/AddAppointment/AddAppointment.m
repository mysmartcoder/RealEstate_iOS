    //
    //  AddAppointment.m
    //  Real Estat
    //
    //  Created by NLS32-MAC on 28/04/16.
    //  Copyright © 2016 . All rights reserved.
    //

#import "AddAppointment.h"
#import "Utility.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "AddAppointment.h"
#import "ClientSearch.h"
#import "DropDownListView.h"
#import "NSObject+SBJSON.h"
@interface AddAppointment ()<kDropDownListViewDelegate,CLIENTSELECT>
{
    DropDownListView * Dropobj;
    
}
@end

@implementation AddAppointment
@synthesize downPicker,fromWhichVC,nameStr,idStr;

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"Add Appointment";
    [self getAppointmentField];
    NSDateFormatter *dfTime = [[NSDateFormatter alloc] init];
    [dfTime setDateFormat:@"MM-dd-yyyy"];
    txtDate.text=[dfTime stringFromDate:[NSDate date]];
    [dfTime setDateFormat:@"yyyy-MM-dd"];
    txtDate.accessibilityLabel=[dfTime stringFromDate:[NSDate date]];
    if ([fromWhichVC isEqualToString:@"Dashboard"]) {
        txtBookWith.text=nameStr;
        txtBookWith.accessibilityLabel=idStr;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

-(void)getAppointmentField
{
        //
        //    Module Fields List
        //    ------------------
        //    URL : [api_url]
        //    Parameter Pass
        //    ------------------
        //    _operation = describe
        //    _session = session (from Login)
        //    module = Module name
    
    
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_ALL_FIELDS forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:@"Events" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            [self getBookWithData];
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                dictResponce=responseObject;
                NSMutableArray *arrFields=[[[dictResponce valueForKey:@"result"] valueForKey:@"describe"] valueForKey:@"fields"];
                if(arrFields.count >0){
                    for(NSMutableDictionary *arrDic in arrFields){
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Appointment Type"]){
//                            txtType.text=[[arrDic valueForKey:@"type"] valueForKey:@"defaultValue"];
                            arrvalueType=[[arrDic valueForKey:@"type"] valueForKey:@"picklistValues"];
                        }
                    }
                    
                }
            }else{
                STOPLOADING()
                
                if([[[responseObject valueForKey:@"error"] valueForKey:@"code"] isEqualToString:@"ACCESS_DENIED"]){
                    [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
                }
            }
            
        }else{
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
}

-(void)getBookWithData{
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:FETCH_MODILE_OWNERS forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:@"Events" forKey:@"module"];
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                arrWith=[[NSMutableArray alloc]init];
                NSMutableArray *arrDat=[[responseObject valueForKey:@"result"] valueForKey:@"users"];
                ArrAlClient=arrDat;
                for(int i=0;i<arrDat.count;i++){
                    if(i==0){
                        if (![fromWhichVC isEqualToString:@"Dashboard"]) {
                            txtBookWith.text=[[arrDat objectAtIndex:i] valueForKey:@"label"];
                            txtBookWith.accessibilityLabel=[[arrDat objectAtIndex:i] valueForKey:@"value"];
                        }
                    }
                    [arrWith addObject:[[arrDat objectAtIndex:i] valueForKey:@"label"]];
                }
                if(arrWith.count >0){
                 
                        //[self showDropdownWithOption:arrWith WithoptionTitle:@"Select Client"];
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
}



-(void)getAvailablityTime{
    
    if([txtBookWith.text isEqualToString:@""]){
        [Utility showAlertWithwithMessage:@"Please select Client"];
        return;
    }
    
   /* Appointment availibity time
    ---------------------------
    URL : [api_url]
    Parameter Pass
    ------------------
    _operation = availableRecords
    _session = session (from Login)
    assigned_user_id = select assigned user id
    date = date*/
    
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_AVAILABLE_TIME forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:txtBookWith.accessibilityLabel forKey:@"assigned_user_id"];
    
    NSRange replaceRange = [txtBookWith.accessibilityLabel rangeOfString:@"19x"];
    if (replaceRange.location != NSNotFound){
        NSString* result = [txtBookWith.accessibilityLabel stringByReplacingCharactersInRange:replaceRange withString:@""];
        [dict setObject:result forKey:@"assigned_user_id"];

    }
    [dict setObject:txtDate.accessibilityLabel forKey:@"date"];

    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                arrAvailable=[[responseObject valueForKey:@"result"] valueForKey:@"describe"];
                if(arrAvailable.count >1){
                               [self showDropdownWithOption:arrAvailable WithoptionTitle:@"Select Availability"];
                }

            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];

}
-(void)showDropdownWithOption:(NSMutableArray *)arr WithoptionTitle:(NSString *)title
{
    Dropobj = [[DropDownListView alloc] initWithTitle:title options:arr xy:CGPointMake(self.view.frame.origin.x+10, self.view.frame.origin.y+10) size:CGSizeMake(300, 300) isMultiple:false];
    Dropobj.accessibilityLabel=title;
    Dropobj.delegate = self;
    Dropobj.arryData=arr;
    [Dropobj showInView:viewbg_Popup animated:YES];
    [self.view addSubview:Dropobj];
    [Dropobj SetBackGroundDropDown_R:166.0 G:189.0 B:23.0 alpha:1.0];
    /*----------------Set DropDown backGroundColor-----------------*/
}

#pragma mark- DROPDOWN METHODS

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    [Dropobj fadeOut];
    [viewbg_Popup removeFromSuperview];
    
    if ([dropdownListView.accessibilityLabel isEqualToString:@"Select Availability"]) {
        txtAvailablity.text=[dropdownListView.arryData objectAtIndex:anIndex];
    }
    if ([dropdownListView.accessibilityLabel isEqualToString:@"Select Appointment Type"]) {
        txtType.text=[dropdownListView.arryData objectAtIndex:anIndex];
    }
    
}



- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    /*----------------Get Selected Value[Multiple selection]-----------------*/
    
}
- (void)DropDownListViewDidCancel{
    [viewbg_Popup removeFromSuperview];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        [Dropobj fadeOut];
        
        
    }
}




- (IBAction)hideDatepickerView:(id)sender {
    NSDateFormatter *dfTime = [[NSDateFormatter alloc] init];
    [dfTime setDateFormat:@"MM-dd-yyyy"];
    NSString *dtTime = [dfTime stringFromDate:datepicker.date];
    txtDate.text=dtTime;
    [dfTime setDateFormat:@"yyyy-MM-dd"];
    txtDate.accessibilityLabel=[dfTime stringFromDate:datepicker.date];
    [txtDate resignFirstResponder];

}

- (IBAction)dismissPicker:(id)sender {
    [txtDate resignFirstResponder];
}

- (IBAction)saveRecord:(id)sender {
   /* ------------------
    URL : [api_url]
    Parameter Pass
    ------------------
    _operation = saveRecord
    _session = session (from Login)
    module = Module name
    record = module_id X record_id
    values = json string
    
    
  {
    "date_start": "2016-04-22",
    "due_date": "2016-04-22",
    "start_time": "14:00",
    "end_time" : "15:00",
    "subject": "New Appointment",
    "activitytype": "Follow up Strategy Call",
    "assigned_user_id": "9x1869",
    "visibility": "Private",
    "taskstatus": "Planned"
    }
    
     date_start and sue_date both are same
      "visibility": "Private",
    "taskstatus": "Planned"

*/
    
    if([txtAvailablity.text isEqualToString:@""]){
        [Utility showAlertWithwithMessage:@"Please select availability time"];
        return;
    }
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:txtDate.accessibilityLabel forKey:@"date_start"];
    [dict setObject:txtDate.accessibilityLabel forKey:@"due_date"];
    NSArray* foo = [txtAvailablity.text componentsSeparatedByString: @"-"];
    if(foo.count >1){
        
                [dict setObject:[foo objectAtIndex: 0] forKey:@"start_time"];
                [dict setObject:[foo objectAtIndex: 1] forKey:@"end_time"];
        
    }
    [dict setObject:txtType.text forKey:@"subject"];
    [dict setObject:txtType.text forKey:@"activitytype"];
    
    NSArray* ids = [txtBookWith.accessibilityLabel componentsSeparatedByString: @"x"];
 if(ids.count >1){
     [dict setObject:[NSString stringWithFormat:@"9x%@",[ids objectAtIndex: 1]] forKey:@"assigned_user_id"];

 }
    [dict setObject:@"Private" forKey:@"visibility"];
    [dict setObject:@"Planned" forKey:@"taskstatus"];

    
//    _operation = saveRecord
//    _session = 6441571db67230373
//    module = Calendar
//    values = {   "date_start": "2016-08-22",   "due_date": "2016-08-22",   "start_time": "14:00",   "end_time" : "15:00",   "subject": "New Appointment",   "activitytype": "Follow up Strategy Call",   "assigned_user_id": "9x1932",   "visibility": "Private",   "taskstatus": "Planned" }
    
//    session = session (from Login)
//    module = Module name
//    record = module_id X record_id  Only used when update Record
//    values = json string
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *dictPost=[[NSMutableDictionary alloc]init];
    [dictPost setObject:ADD_APPT_RECORD forKey:OPERATION];
    [dictPost setObject:TOKEN forKey:@"session"];
    [dictPost setObject:@"Calendar" forKey:@"module"];
        // [dictPost setObject:[dict JSONRepresentation] forKey:@"values"];
    [dictPost setObject:dict forKey:@"values"];

//    [dictPost setObject:txtDate.accessibilityLabel forKey:@"record"];

    [manager POST:WEBSERVICE_URL parameters:dictPost progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
               
                [self.navigationController popViewControllerAnimated:true];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [Utility showAlertWithwithMessage:@"Your appointment has booked"];
                });
                return;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];

}




- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if(textField==txtBookWith){
        if(arrWith.count>0){
            ClientSearch *objS=[[ClientSearch alloc]initWithNibName:@"ClientSearch" bundle:nil];
            objS.delegate=self;
            objS.dataArray=ArrAlClient;
            [self.navigationController pushViewController:objS animated:true];
                //            [self showDropdownWithOption:arrWith WithoptionTitle:@"Select Client"];
        }
    }
    
    if(textField==txtType){
        
        if([txtBookWith.text isEqualToString:@""]){
            [Utility showAlertWithTitle:@"Real Estat" withMessage:@"Please select book with to select appointment"];
            return NO;
        }
        [self getBookTypeData];
//        NSMutableArray *arrOp=[[NSMutableArray alloc]init];
//        for(int i=0;i<arrvalueType.count;i++){
//            NSMutableDictionary *dic=[arrvalueType objectAtIndex:i];
//            [arrOp addObject:[dic valueForKey:@"label"]];
//            
//        }
//        [self showDropdownWithOption:arrOp WithoptionTitle:@"Select Appointment Type"];
        
    }
    
    if(textField==txtDate){
        txtDate.inputView=datepickerView;
        return YES;
    }
    
    
    if(textField==txtAvailablity){
        [self getAvailablityTime];
    }
    return NO;
}
-(void)selectClientForWithClientName:(NSString *)name WithId:(NSString *)idClient;
{
    txtBookWith.text=name;
    txtBookWith.accessibilityLabel=idClient;
}

-(void)getBookTypeData
{
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GETBOOKWITHRECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:@"Events" forKey:@"module"];
        //  [dict setObject:txtBookWith.accessibilityLabel forKey:@"assigned_user_id"];
    
    NSRange replaceRange = [txtBookWith.accessibilityLabel rangeOfString:@"19x"];
    if (replaceRange.location != NSNotFound){
        NSString* result = [txtBookWith.accessibilityLabel stringByReplacingCharactersInRange:replaceRange withString:@""];
        [dict setObject:result forKey:@"assigned_user_id"];
        
    }
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                dictResponce=responseObject;
                NSMutableArray *arrFields=[[dictResponce valueForKey:@"result"] valueForKey:@"appointmentType"] ;
                if(arrFields.count >0){
                    arrvalueType=arrFields;
                     [self showDropdownWithOption:arrFields WithoptionTitle:@"Select Appointment Type"];
//                    for(NSMutableDictionary *arrDic in arrFields){
//                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Appointment Type"]){
//                            txtType.text=[[arrDic valueForKey:@"type"] valueForKey:@"defaultValue"];
//                                arrvalueType=[[arrDic valueForKey:@"type"] valueForKey:@"picklistValues"];
//                        }
//                    }
                }
            }else{
                STOPLOADING()
                
                if([[[responseObject valueForKey:@"error"] valueForKey:@"code"] isEqualToString:@"ACCESS_DENIED"]){
                    [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
                }
            }
        }else{
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
}
@end
