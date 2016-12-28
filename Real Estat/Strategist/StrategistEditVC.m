    //
    //  StrategistEditVC.m
    //  Real Estat
    //
    //  Created by NLS32-MAC on 04/05/16.
    //  Copyright © 2016 . All rights reserved.
    //

#import "StrategistEditVC.h"
#import "ClientSearch.h"
#import "DropDownListView.h"
#import "NSObject+SBJSON.h"
#import "UITextView+Placeholder.h"
#import "Utility.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "PdfViewVC.h"
@interface StrategistEditVC ()<kDropDownListViewDelegate,CLIENTSELECT>

{

    DropDownListView * Dropobj;
    
}
@end

@implementation StrategistEditVC
@synthesize dictInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
        // Do any additional setup after loading the view from its nib.
    [txtNotes.layer setCornerRadius:4.0];
    [txtNotes.layer setBorderColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor];
    [txtNotes.layer setBorderWidth:1.0];
    txtNotes.placeholder=@"Enter Notes Here";
    [scrollview setContentSize:CGSizeMake(WIDTH, HEIGHT+200)];
    
    [self getDescribeRecord];
/*
 for Edit Field
 
 Get Agent City Records
    ----------------------
    
    URL :
    
    Parameter Pass
    --------------
    
    _operation = selectAgentCityRecords
    _session = strategies session id
    clientid = selected client id
    agentname = selected agent name
    recordid = record id
    module = module name (Documents)
    
    
    Send Agent mail
    
    URL :
    
    Parameter pass
    --------------
    _operation = sendAgentMailRecords
    _session = strategies session id
    areavalue = Berkshire Hathaway , Koenig Rubloff (City)
    userid = login user id
    clientid = selected client id
    agentname = selected agent name
*/
    
}
-(void)getDescribeRecord
{
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_ALL_FIELDS forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:@"Documents" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                dictResponce=responseObject;
                NSMutableArray *arrFields=[[[dictResponce valueForKey:@"result"] valueForKey:@"describe"] valueForKey:@"fields"];
                if(arrFields.count >0){
                    [self getStrategistRecord];

                    for(NSMutableDictionary *arrDic in arrFields){
                            if([[arrDic valueForKey:@"label"]isEqualToString:@"Title"]){
                                txtTitle.text=[[arrDic valueForKey:@"Title"] valueForKey:@"default"];
                            }
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Choose Strategist"]){
                            agent.accessibilityHint=[arrDic valueForKey:@"name"];

                        }
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Suburb"]){
                            suburb.accessibilityHint=[arrDic valueForKey:@"name"];
                            arrSuburb=[[arrDic valueForKey:@"type"] valueForKey:@"picklistValues"];
                            
                        }

                        if([[arrDic valueForKey:@"label"]isEqualToString:@"Assigned Client"]){
                            assignedClient.accessibilityHint=[arrDic valueForKey:@"name"];
                            
                        }
                        if([[arrDic valueForKey:@"label"]isEqualToString:@"General Notes"]){
                            txtNotes.accessibilityHint=[arrDic valueForKey:@"name"];
                            
                        }
                    }
                    
                }
            }
        
    else{
        [self getStrategistRecord];

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
-(void)getStrategistRecord
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
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:FETCH_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:[self.dictInfo valueForKey:@"id"] forKey:@"record"];
    [dict setObject:@"Documents" forKey:@"module"];

    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
//        [self getBookWithData];
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                dictResponce=responseObject;
                NSMutableDictionary *arrFields=[[dictResponce valueForKey:@"result"] valueForKey:@"record"] ;
                
                if([arrFields valueForKey:@"suburb"]){
                    
                    NSString *strDat=[arrFields objectForKey:@"suburb"];
                    
                    if(![strDat isEqualToString:@""]){
                    
                    
                    NSArray *items = [strDat componentsSeparatedByString:@"|##|"];
                    if(items.count==0){
                        suburb.text=[arrFields valueForKey:@"suburb"];
                    }else{
                        NSString *strArr;
                        for(int i=0;i<items.count;i++){
                            if(i==0){
                                strArr=[items objectAtIndex:i];
                            }else{
                                strArr=[NSString stringWithFormat:@"%@,%@",strArr,[items objectAtIndex:i]];
                            }
                            
                        }
                        suburb.text=strArr;
                    }

                        
                        
                    }
                    
                    
                }
                if([arrFields valueForKey:@"notes_title"]){
                    txtTitle.text=[arrFields valueForKey:@"notes_title"];
                }
                if([arrFields valueForKey:@"cf_894"]){
                    assignedClient.text=[[arrFields valueForKey:@"cf_894"] valueForKey:@"label"];
                   assignedClient.accessibilityLabel=[[arrFields valueForKey:@"cf_894"] valueForKey:@"value"];

                }
                
                
                if([[arrFields valueForKey:@"file"]isKindOfClass:[NSMutableArray class]]){
                    arrDocuments=[arrFields valueForKey:@"file"];
                    
                    [tblDoc reloadData];
                    
                }
                
                if([arrFields valueForKey:@"cf_999"]){
                    txtNotes.text=[arrFields valueForKey:@"cf_999"];
                }
                if([arrFields valueForKey:@"assigned_user_id"]){
                    agent.text=[[arrFields valueForKey:@"assigned_user_id"] valueForKey:@"label"];
                    agent.accessibilityLabel=[[arrFields valueForKey:@"assigned_user_id"] valueForKey:@"value"];
                }
            }
        }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                STOPLOADING()
                NSLog(@"%@",error.localizedDescription);
            }];
            
            
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)getBookWithData{
    
    
    SHOWLOADING(@"Loading")
    
    
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_MODULE_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:@"Document" forKey:@"module"];
    
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
//                        strategist.text=[[arrDat objectAtIndex:i] valueForKey:@"label"];
//                        strategist.accessibilityLabel=[[arrDat objectAtIndex:i] valueForKey:@"value"];
//                        assignTo.text=[[arrDat objectAtIndex:i] valueForKey:@"label"];
//                        assignTo.accessibilityLabel=[[arrDat objectAtIndex:i] valueForKey:@"value"];
                        
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

-(void)showAgentFromSuburbData
{
    /*
     for Assign Agent
     Get suburb records
     --------------------------------
     URL : [api_url]
     
     Paramaeter Pass
     ----------------
     
     _operation = getSuburbRecords
     _session =
     record = Chicago
     */
    
    NSString *strDat=suburb.text;
    
    if([strDat isEqualToString:@""]){
        return;
    }
    NSMutableDictionary *dictRec=[[NSMutableDictionary alloc]init];
    
    NSArray *items = [strDat componentsSeparatedByString:@","];
    if(items.count==0){
        [dictRec setObject:strDat forKey:strDat];
    }else{
        for(NSString *str in items){
        [dictRec setObject:str forKey:str];
        }
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_SUBURB_RECORDS forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:[dictRec JSONRepresentation] forKey:@"record"];
    SHOWLOADING(@"Loading")
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
              NSMutableArray  *arrAg=[[NSMutableArray alloc]init];
                NSMutableArray *arrDat=[[responseObject valueForKey:@"result"] valueForKey:@"suburbarray"];
                arrAgent=arrDat;
                
                for(int i=0;i<arrDat.count;i++){
                    
                    [arrAg addObject:[[arrDat objectAtIndex:i] valueForKey:@"fname"]];
                }
                if(arrAg.count >0){
                    [self showDropdownWithOption:arrAg WithoptionTitle:@"Select Agent" :false];
                    
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    

}
-(void)getAgentData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_MODULE_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:@"Contacts" forKey:@"module"];
    
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
                        
                            //                        strategist.text=[[arrDat objectAtIndex:i] valueForKey:@"label"];
                            //                        strategist.accessibilityLabel=[[arrDat objectAtIndex:i] valueForKey:@"value"];
                            //                        assignTo.text=[[arrDat objectAtIndex:i] valueForKey:@"label"];
                            //                        assignTo.accessibilityLabel=[[arrDat objectAtIndex:i] valueForKey:@"value"];
                        
                        
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
    [txtNotes resignFirstResponder];
    if(textField==suburb){
        NSMutableArray *arrOp=[[NSMutableArray alloc]init];
        for(int i=0;i<arrSuburb.count;i++){
            
            NSMutableDictionary *dic=[arrSuburb objectAtIndex:i];
            [arrOp addObject:[dic valueForKey:@"label"]];
            
        }
        [self showDropdownWithOption:arrOp WithoptionTitle:@"Select Suburb":true];
        return NO;
        
    }
    if(textField==agent){
        [self showAgentFromSuburbData];
        return NO;

    }
    if(textField==assignedClient ){
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

    return YES;
}

-(void)showDropdownWithOption:(NSMutableArray *)arr WithoptionTitle:(NSString *)title :(BOOL)isMultiple
{
    Dropobj = [[DropDownListView alloc] initWithTitle:title options:arr xy:CGPointMake(self.view.frame.origin.x+10, self.view.frame.origin.y+10) size:CGSizeMake(300, 300) isMultiple:isMultiple];
    Dropobj.accessibilityLabel=title;
    Dropobj.delegate = self;
    [Dropobj showInView:viewbg_Popup animated:YES];
    
    if(!isMultiple){
        Dropobj.arryData=arr;
    }
    
    [self.view addSubview:Dropobj];
    [Dropobj SetBackGroundDropDown_R:166.0 G:189.0 B:23.0 alpha:1.0];
    /*----------------Set DropDown backGroundColor-----------------*/
}

#pragma mark- DROPDOWN METHODS

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    [Dropobj fadeOut];
    [viewbg_Popup removeFromSuperview];
    
    if ([dropdownListView.accessibilityLabel isEqualToString:@"Select Availability"]) {
    }
    
    if ([dropdownListView.accessibilityLabel isEqualToString:@"Select Agent"]) {
        
        for(int i=0;i<arrAgent.count;i++){
            if([[[arrAgent objectAtIndex:i] valueForKey:@"fname"] isEqualToString:[Dropobj.arryData objectAtIndex:anIndex] ]){
                agent.text=[[arrAgent objectAtIndex:i] valueForKey:@"fname"];
                agent.accessibilityLabel=[[arrAgent objectAtIndex:i] valueForKey:@"ids"];
            }
        }
    }
}



- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    /*----------------Get Selected Value[Multiple selection]-----------------*/
    
    if(ArryData.count >0){
    NSString *strArr;
    for(int i=0;i<ArryData.count;i++){
        if(i==0){
            strArr=[ArryData objectAtIndex:i];
        }else{
            strArr=[NSString stringWithFormat:@"%@,%@",strArr,[ArryData objectAtIndex:i]];
        }
        
    }
    suburb.text=strArr;
    }
    
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



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length != 0) {
            // Get the Ascii character
        int asciiCode = [text characterAtIndex:0];
            // If the ascii code is /n or new line, then resign first responder
        if (asciiCode == 10) {
            
            [txtNotes resignFirstResponder];
        }
        
    }
    return true;
    
}

- (IBAction)showEditStrategistView:(id)sender {
    
  /*  for Edit Field
        
        Get Agent City Records
        ----------------------
        
        URL :
        
        Parameter Pass
        --------------
        
        _operation = selectAgentCityRecords
        _session = strategies session id
        clientid = selected client id
        agentname = selected agent name
        recordid = record id
        module = module name (Documents)*/
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_AGENT_DETAIL forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:agent.accessibilityLabel forKey:@"clientid"];
    [dict setObject:agent.text forKey:@"agentname"];
    [dict setObject:[self.dictInfo valueForKey:@"id"]  forKey:@"recordid"];

    [dict setObject:@"Documents" forKey:@"module"];

    SHOWLOADING(@"Loading")
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                NSMutableArray  *arrAg=[[NSMutableArray alloc]init];
                NSMutableArray *arrDat=[[responseObject valueForKey:@"result"] valueForKey:@"suburbarray"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    

    
}







- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
        // Configure the cell...
    cell.textLabel.text = [[arrDocuments objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.textLabel.font=txtNotes.font;
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrDocuments count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    PdfViewVC *objV=[[PdfViewVC alloc]initWithNibName:@"PdfViewVC" bundle:nil];
    objV.strUrl=[[arrDocuments objectAtIndex:indexPath.row] valueForKey:@"url"];

    [self.navigationController pushViewController:objV animated:true];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
@interface NSMutableDictionary (BVJSONString)
-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end

@implementation NSMutableDictionary (BVJSONString)

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end
