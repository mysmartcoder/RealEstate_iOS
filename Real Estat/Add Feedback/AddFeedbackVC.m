//
//  AddFeedbackVC.m
//  Real Estat
//
//  Created by NLS42-MAC on 29/06/16.
//  Copyright © 2016 . All rights reserved.
//

#import "AddFeedbackVC.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "Static.h"
#import "Utility.h"
#import "DropDownListView.h"
@interface AddFeedbackVC ()<kDropDownListViewDelegate>
{
    DropDownListView * Dropobj;
    UIView *viewbg_Popup;

}
@end

@implementation AddFeedbackVC
@synthesize assigned_user_id,town_str,agentName;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Add Town Feedback";
    [scrollview setContentSize:CGSizeMake(WIDTH-10, HEIGHT_IPHONE_4s+500)];
    townLike.accessibilityLabel=@"cf_926";
    additional.accessibilityLabel=@"cf_936";
    compare.accessibilityLabel=@"cf_928";
    concern.accessibilityLabel=@"cf_930";
    townRank.accessibilityLabel=@"cf_932";
    town.accessibilityLabel=@"town";
    rate.accessibilityLabel=@"rate";
    
        // Responsive to star size
    rateView.starSize = 40;
    
        // Customizable border color
    rateView.starBorderColor = NAVBARCLOLOR;
    
        // Customizable star normal color
    rateView.starNormalColor = [UIColor lightGrayColor];
    
        // Customizable star fill color
    rateView.starFillColor = NAVBARCLOLOR;
    
        // Customizable star fill mode
    rateView.starFillMode = StarFillModeHorizontal;
    
        // Change rating whenever needed
    rateView.step = 1.0;
    
        // Can Rate
    rateView.canRate = YES;

    if (self.town_str.length >0) {
        town.text=self.town_str;
    }
    [self getBookWithData];

    // Do any additional setup after loading the view from its nib.
}
-(void)getAllFields
{
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_ALL_FIELDS forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"_session"];
    [dict setObject:@"Fbm" forKey:@"module"];
//    [dict setObject:@"PRIVATE" forKey:@"mode"];
       
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
            }else{
                
                [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
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

- (IBAction)saveFeedback:(id)sender {
    
    if([townLike.text isEqualToString:@""]||
       [additional.text isEqualToString:@""]||
       [compare.text isEqualToString:@""]||
       [concern.text isEqualToString:@""]||
       [townRank.text isEqualToString:@""]||
       [town.text isEqualToString:@""]){
        [Utility showAlertWithwithMessage:@"Please enter Value"];
        return;
    }
    if(rateView.rating ==0){
        [Utility showAlertWithwithMessage:@"Please Select Ratings"];
        return;
    }
    
 /*   URL : [api_url]
    Parameter Pass
    ------------------
    _operation = saveRecord
    _session = session (from Login)
    module = Module name
    record = module_id X record_id
    values = json string
   */
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:townLike.text forKey:townLike.accessibilityLabel];
    [dict setObject:additional.text forKey:additional.accessibilityLabel];
    [dict setObject:compare.text forKey:compare.accessibilityLabel];
    [dict setObject:concern.text forKey:concern.accessibilityLabel];
    [dict setObject:townRank.text forKey:townRank.accessibilityLabel];
    [dict setObject:town.text forKey:town.accessibilityLabel];
    [dict setObject:[NSString stringWithFormat:@"%f",rateView.rating] forKey:rate.accessibilityLabel];
  
        //If user available - Kaushik
    if (agent.accessibilityLabel) {
        [dict setObject:agent.accessibilityLabel forKey:@"assigned_user_id"];
   
    }else{
        [dict setObject:@"" forKey:@"assigned_user_id"];

    }
    

    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *dictPost=[[NSMutableDictionary alloc]init];
    [dictPost setObject:ADD_APPT_RECORD forKey:OPERATION];
    [dictPost setObject:TOKEN forKey:@"session"];
    [dictPost setObject:@"Fbm" forKey:@"module"];
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
                    [Utility showAlertWithwithMessage:@"Feedback added successfully"];
                });
                return;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
    if(textField==townRank){
        [self showPopup];
        return NO;
    }
    
    if(textField==agent){
        if(arrWith.count >0){
            
            [self showDropdownWithOption:arrWith WithoptionTitle:@"Select Client"];
        }        return NO;
    }
    return YES;
}


-(void)showPopup{
    viewbg_Popup=[[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:viewbg_Popup];
    Dropobj = [[DropDownListView alloc] initWithTitle:@"Select Town Rank" options:@[@"Top",@"Middle",@"Low"] xy:CGPointMake(10, 50) size:CGSizeMake(WIDTH-20, 300) isMultiple:false];
    Dropobj.arryData=@[@"Top",@"Middle",@"Low"];
    Dropobj.delegate = self;
    Dropobj.accessibilityLabel=@"TownRank";
    [Dropobj showInView:viewbg_Popup animated:YES];
    [self.view addSubview:Dropobj];
    [Dropobj SetBackGroundDropDown_R:166.0 G:189.0 B:23.0 alpha:1.0];

}

#pragma mark- DROPDOWN METHODS

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    [Dropobj fadeOut];
    [viewbg_Popup removeFromSuperview];
    if([Dropobj.accessibilityLabel isEqualToString:@"TownRank"]){
     townRank.text=[dropdownListView.arryData objectAtIndex:anIndex];
    }else{
        agent.text=[[ArrAlClient objectAtIndex:anIndex] valueForKey:@"label"];
        agent.accessibilityLabel=[[ArrAlClient objectAtIndex:anIndex] valueForKey:@"value"];
    }
}

- (void)DropDownListViewDidCancel{
    [viewbg_Popup removeFromSuperview];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        [Dropobj fadeOut];
        [viewbg_Popup removeFromSuperview];
        
        
    }
}
-(void)rateView:(RateView*)rateView didUpdateRating:(float)rating
{
    NSLog(@"rateViewDidUpdateRating: %.1f", rating);
}



-(void)getBookWithData{
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:FETCH_MODILE_OWNERS forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:@"Fbm" forKey:@"module"];
    [dict setObject:town.text forKey:@"town"];

    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                arrWith=[[NSMutableArray alloc]init];
                ArrAlClient=[[NSMutableArray alloc]init];
                NSMutableArray *arrDat=[[responseObject valueForKey:@"result"] valueForKey:@"users"];
                ArrAlClient=arrDat;
                for(int i=0;i<arrDat.count;i++){
                    
                    if(i==0){
                        agent.text=[[arrDat objectAtIndex:i] valueForKey:@"label"];
                        agent.accessibilityLabel=[[arrDat objectAtIndex:i] valueForKey:@"value"];
                    }
                    [arrWith addObject:[[arrDat objectAtIndex:i] valueForKey:@"label"]];
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
    viewbg_Popup=[[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:viewbg_Popup];

    Dropobj = [[DropDownListView alloc] initWithTitle:title options:arr xy:CGPointMake(10, 50) size:CGSizeMake(WIDTH-20, 300) isMultiple:false];
    
    Dropobj.accessibilityLabel=title;
    Dropobj.delegate = self;
    Dropobj.arryData=arr;
    [Dropobj showInView:viewbg_Popup animated:YES];
    [Dropobj SetBackGroundDropDown_R:166.0 G:189.0 B:23.0 alpha:1.0];
    /*----------------Set DropDown backGroundColor-----------------*/
}
@end

