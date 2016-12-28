    //
    //  AddAppointment.m
    //  Real Estat
    //
    //  Created by NLS32-MAC on 28/04/16.
    //  Copyright © 2016 . All rights reserved.
    //

#import "EditClientVC_Agent.h"
#import "Utility.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "AddAppointment.h"
#import "ClientSearch.h"
#import "DropDownListView.h"
#import "NSObject+SBJSON.h"
#import "UITextView+Placeholder.h"
@interface EditClientVC_Agent ()<kDropDownListViewDelegate,CLIENTSELECT>
{
    DropDownListView * Dropobj;
    
}
@end

@implementation EditClientVC_Agent
@synthesize downPicker;
@synthesize dictInfo;
@synthesize isEditable;
- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"Client Detail";
    [clientNotes.layer setCornerRadius:4.0];
    clientNotes.placeholder=@"Enter Client Notes";
    [clientNotes.layer setBorderColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor];
    [clientNotes.layer setBorderWidth:1.0];
    [agentNotes.layer setCornerRadius:4.0];
    agentNotes.placeholder=@"Enter Agent Notes";
    [agentNotes.layer setBorderColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor];
    [agentNotes.layer setBorderWidth:1.0];
    [scrollView setContentSize:CGSizeMake(WIDTH, HEIGHT+100)];
    org.text=[self.dictInfo valueForKey:@"cf_755"];
    if(self.isEditable==true){
        btnSave.hidden=true;
    }
    
    [self getAppointmentField];
    
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
    [dict setObject:@"Contacts" forKey:@"module"];
    
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
//            [self getBookWithData];
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                dictResponce=responseObject;
                NSMutableArray *arrFields=[[[dictResponce valueForKey:@"result"] valueForKey:@"describe"] valueForKey:@"fields"];
                if(arrFields.count >0){
                    [self getClientDetails];
                    for(NSMutableDictionary *arrDic in arrFields){
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Appointment Type"]){
                            txtType.text=[[arrDic valueForKey:@"type"] valueForKey:@"defaultValue"];
                            arrvalueType=[[arrDic valueForKey:@"type"] valueForKey:@"picklistValues"];
                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"salutationtype"]){
                            arrSalute=[[arrDic valueForKey:@"type"] valueForKey:@"picklistValues"];
                            txtMr.accessibilityHint=@"salutationtype";
                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_house_price"]){
                            arrPrice=[[arrDic valueForKey:@"type"] valueForKey:@"picklistValues"];
                            price.accessibilityHint=@"cf_house_price";
                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"firstname"]){
                            firstName.accessibilityHint=@"firstname";
                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"lastname"]){
                            lastname.accessibilityHint=@"lastname";
                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"phone"]){
                            officePhone.accessibilityHint=@"phone";
                        }
                        
                        
//                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Organization Name"]){
//                            org.accessibilityHint=[arrDic valueForKey:@"name"];
//                        }
                        
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Primary Email"]){
                            email.accessibilityHint=[arrDic valueForKey:@"name"];
                        }
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Strategist"]){
                            strategist.accessibilityHint=[arrDic valueForKey:@"name"];
                        }
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Spouse Phone"]){
                            spoucePhone.accessibilityHint=[arrDic valueForKey:@"name"];
                        }
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Client Notes"]){
                            clientNotes.accessibilityHint=[arrDic valueForKey:@"name"];
                        }
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Agent Notes"]){
                            agentNotes.accessibilityHint=[arrDic valueForKey:@"name"];
                        }
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Assigned To"]){
                            assignTo.accessibilityHint=[arrDic valueForKey:@"name"];
                        }
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Price"]){
                            price.accessibilityHint=[arrDic valueForKey:@"name"];
                        }
                    }
                    
                    
                }
            }else{
                STOPLOADING()
                
                if([[[responseObject valueForKey:@"error"] valueForKey:@"code"] isEqualToString:@"ACCESS_DENIED"]){
                    [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
                }
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
}



-(void)getClientDetails{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:FETCH_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    if([self.dictInfo valueForKey:@"id"]){
    [dict setObject:[self.dictInfo valueForKey:@"id"] forKey:@"record"];
    }else if([self.dictInfo valueForKey:@"contactid"]){
//        [dict setObject:[self.dictInfo valueForKey:@"contactid"] forKey:@"record"];
        [dict setObject:[NSString stringWithFormat:@"12x%@",[self.dictInfo valueForKey:@"contactid"]] forKey:@"record"];

    }else{
        [dict setObject:[NSString stringWithFormat:@"12x%@",[self.dictInfo valueForKey:@"clientid"]] forKey:@"record"];

    }
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()

        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                dictResponce=responseObject;
                NSMutableArray *arrFields=[[dictResponce valueForKey:@"result"] valueForKey:@"record"] ;
                if(arrFields.count >0){
                    
                        if([arrFields valueForKey:txtMr.accessibilityHint]){
                            
                            txtMr.text=[arrFields valueForKey:txtMr.accessibilityHint];
                        }
                    suburb.text=[arrFields valueForKey:@"cf_759"];
                    created.text=[arrFields valueForKey:@"createdtime"];

                    if([arrFields valueForKey:firstName.accessibilityHint]){
                        
                        firstName.text=[arrFields valueForKey:firstName.accessibilityHint];
                    }
                    if([arrFields valueForKey:lastname.accessibilityHint]){
                        
                        lastname.text=[arrFields valueForKey:lastname.accessibilityHint];
                    }
                    
                    if([arrFields valueForKey:email.accessibilityHint]){
                        
                        email.text=[arrFields valueForKey:email.accessibilityHint];
                    }
                    
                    strategist.text=[[arrFields valueForKey:@"strategist"] valueForKey:@"label"];

                    if([arrFields valueForKey:spoucePhone.accessibilityHint]){
                        
                        spoucePhone.text=[arrFields valueForKey:spoucePhone.accessibilityHint];
                    }
                    
                   
                    assignTo.text=[[arrFields valueForKey:@"assigned_user_id"] valueForKey:@"label"];

                  }

            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
    

}

-(void)getBookWithData{
    
    return;
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
                        strategist.text=[[arrDat objectAtIndex:i] valueForKey:@"label"];
                        strategist.accessibilityLabel=[[arrDat objectAtIndex:i] valueForKey:@"value"];
                        assignTo.text=[[arrDat objectAtIndex:i] valueForKey:@"label"];
                        assignTo.accessibilityLabel=[[arrDat objectAtIndex:i] valueForKey:@"value"];
                        
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
    
    
    if ([dropdownListView.accessibilityLabel isEqualToString:@"Select Salute"]) {
        txtMr.text=[dropdownListView.arryData objectAtIndex:anIndex];
        txtMr.accessibilityLabel=[dropdownListView.arryData objectAtIndex:anIndex];
    }
    if ([dropdownListView.accessibilityLabel isEqualToString:@"Select Appointment Type"]) {
        txtType.text=[dropdownListView.arryData objectAtIndex:anIndex];
    }
    if ([dropdownListView.accessibilityLabel isEqualToString:@"Select Organization"]) {
        org.text=[dropdownListView.arryData objectAtIndex:anIndex];
        org.accessibilityLabel=[[arrOrg objectAtIndex:anIndex] valueForKey:@"id"];
        
    }
    if ([dropdownListView.accessibilityLabel isEqualToString:@"Select Price"]) {
        price.text=[dropdownListView.arryData objectAtIndex:anIndex];
        price.accessibilityLabel=[[arrPrice objectAtIndex:anIndex] valueForKey:@"id"];
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
     Save Record
     ------------------
     URL : [api_url]
     Parameter Pass
     ------------------
     _operation = saveRecord
     _session = session (from Login)
     module = Module name
     record = module_id X record_id
     values = json string
     
     client{
     "salutationtype" : "Mr.",
     "firstname" : "Jiten",
     "lastname" : "Jonny",
     "phone": "123456789",
     "account_id": 6360,
     "email" : "jitenjonny@gmail.com",
     "strategist": 1816,
     "cf_943": "123456789",
     "cf_876" : "Client Notes",
     "cf_880" : "Agent Notes",
     "assigned_user_id" : 1816,
     "cf_house_price" : "$400,000 - $600,000"
     }
     
     */
    
    if([txtAvailablity.text isEqualToString:@""]){
        [Utility showAlertWithwithMessage:@"Please select availability time"];
        return;
    }
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:txtMr.text forKey:@"salutationtype"];
    [dict setObject:firstName.text forKey:@"firstname"];
    [dict setObject:lastname.text forKey:@"lastname"];
    [dict setObject:officePhone.text forKey:@"phone"];
    [dict setObject:org.text forKey:org.accessibilityHint];
    [dict setObject:email.text forKey:@"email"];
    [dict setObject:strategist.accessibilityLabel forKey:@"strategist"];
    [dict setObject:clientNotes.text forKey:clientNotes.accessibilityHint];
    [dict setObject:agentNotes.text forKey:agentNotes.accessibilityHint];
    [dict setObject:spoucePhone.text forKey:spoucePhone.accessibilityHint];
    [dict setObject:assignTo.accessibilityLabel forKey:assignTo.accessibilityHint];
    [dict setObject:price.text forKey:price.accessibilityHint];

    
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *dictPost=[[NSMutableDictionary alloc]init];
    [dictPost setObject:ADD_APPT_RECORD forKey:OPERATION];
    [dictPost setObject:TOKEN forKey:@"session"];
    [dictPost setObject:@"Contacts" forKey:@"module"];
    [dictPost setObject:dict forKey:@"values"];
    
    [manager POST:WEBSERVICE_URL parameters:dictPost progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                
                [self.navigationController popViewControllerAnimated:true];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [Utility showAlertWithwithMessage:@"Client Information Edited Successfully"];
                });
                return;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

-(void)getOrganizations
{
   /* List module records
    ------------------
    URL : [api_url]
    
    Parameter Pass
    ------------------
    _operation = listModuleRecords
    _session = session (from Login)
    module = Module name
    mode = PRIVATE
    syncToken = Blank
    page = integer
    */
   
    if(arrOrg.count >0){
        NSMutableArray *arrOp=[[NSMutableArray alloc]init];
        for(int i=0;i<arrOrg.count;i++){
            
            NSMutableDictionary *dic=[arrOrg objectAtIndex:i];
            [arrOp addObject:[dic valueForKey:@"label"]];
            
        }
        [self showDropdownWithOption:arrOp WithoptionTitle:@"Select Organization"];
        return;
    }
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_MODULE_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];

    [dict setObject:@"Contacts" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
               
                arrOrg=[[responseObject valueForKey:@"result"]valueForKey:@"records"];
                NSMutableArray *arrOp=[[NSMutableArray alloc]init];
                for(int i=0;i<arrOrg.count;i++){
                    NSMutableDictionary *dic=[arrOrg objectAtIndex:i];
                    [arrOp addObject:[dic valueForKey:@"label"]];
                }
                [self showDropdownWithOption:arrOp WithoptionTitle:@"Select Organization"];
            }
        }else{
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    

}


#pragma mark - TEXTFIELD DELEGATES

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    
    if(self.isEditable==true){
        return NO;
    }
    return true;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    
    if(self.isEditable==true){
        return NO;
    }
    
    if(textField==strategist ||textField==
       assignTo){
        if(arrWith.count>0){
            ClientSearch *objS=[[ClientSearch alloc]initWithNibName:@"ClientSearch" bundle:nil];
            objS.delegate=self;
            objS.dataArray=ArrAlClient;
            current=textField;
            [self.navigationController pushViewController:objS animated:true];
                //            [self showDropdownWithOption:arrWith WithoptionTitle:@"Select Client"];
        }
        return NO;
    }
    
    if(textField==txtMr){
        NSMutableArray *arrOp=[[NSMutableArray alloc]init];
        for(int i=0;i<arrSalute.count;i++){
            
            NSMutableDictionary *dic=[arrSalute objectAtIndex:i];
            [arrOp addObject:[dic valueForKey:@"label"]];
            
        }
        [self showDropdownWithOption:arrOp WithoptionTitle:@"Select Salute"];
        return NO;
        
    }
    
    if(textField==price){
        NSMutableArray *arrOp=[[NSMutableArray alloc]init];
        for(int i=0;i<arrPrice.count;i++){
            
            NSMutableDictionary *dic=[arrPrice objectAtIndex:i];
            [arrOp addObject:[dic valueForKey:@"label"]];
            
        }
        [self showDropdownWithOption:arrOp WithoptionTitle:@"Select Price"];
        return NO;
        
    }
    if(textField==txtDate){
        txtDate.inputView=datepickerView;
        return YES;
    }
    
    
    if(textField==txtAvailablity){
        [self getAvailablityTime];
        return NO;
    }
    if(textField==org){
        [self getOrganizations];
        return NO;
    }
    
    if(textField==officePhone || textField==spoucePhone){
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        numberToolbar.barStyle = UIBarStyleDefault;
        numberToolbar.tintColor=NAVBARCLOLOR;
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                               nil];
        [numberToolbar sizeToFit];
        textField.inputAccessoryView = numberToolbar;
        }

    
    
    return YES;
}


-(void)cancelNumberPad
{
    [officePhone resignFirstResponder];
    [spoucePhone resignFirstResponder];
        //    txtnumber.text=nil;
}
-(void)doneWithNumberPad
{
    [officePhone resignFirstResponder];
    [spoucePhone resignFirstResponder];
}




-(void)selectClientForWithClientName:(NSString *)name WithId:(NSString *)idClient;
{
    current.text=name;
    current.accessibilityLabel=idClient;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length != 0) {
            // Get the Ascii character
        int asciiCode = [text characterAtIndex:0];
            // If the ascii code is /n or new line, then resign first responder
        if (asciiCode == 10) {
            [clientNotes resignFirstResponder];
            [agentNotes resignFirstResponder];
        }
    
}
    return true;

}
@end
