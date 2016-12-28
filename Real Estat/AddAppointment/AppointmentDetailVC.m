//
//  AppointmentDetailVC.m
//  Real Estat
//
//  Created by NLS42-MAC on 07/06/16.
//  Copyright © 2016 . All rights reserved.
//

#import "AppointmentDetailVC.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "Static.h"
#import "Utility.h"

@interface AppointmentDetailVC ()

@end

@implementation AppointmentDetailVC
@synthesize dictData;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.dictData);
    

    
    [self getClientDetail];
    // Do any additional setup after loading the view from its nib.
}
-(void)getClientDetail
{
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dictSe=[[NSMutableDictionary alloc]init];
    [dictSe setObject:FETCH_RECORD forKey:OPERATION];
    [dictSe setObject:TOKEN forKey:@"session"];
    [dictSe setObject:[self.dictData valueForKey:@"id"] forKey:@"record"];
    
    [manager POST:WEBSERVICE_URL parameters:dictSe progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        STOPLOADING()
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
               responseObject= [Utility cleanJsonToObject:responseObject];
                NSMutableDictionary *dictRec=[[responseObject valueForKey:@"result"] valueForKey:@"record"];
                assignTo.text=[[dictRec valueForKey:@"assigned_user_id"] valueForKey:@"label"];
                
                sub.text=[dictRec valueForKey:@"subject"];
                actType.text=[dictRec valueForKey:@"activitytype"];
               
                NSString *startD=[NSString stringWithFormat:@"%@ %@",[[[responseObject valueForKey:@"result"] valueForKey:@"record"] valueForKey:@"date_start"],[[[responseObject valueForKey:@"result"] valueForKey:@"record"] valueForKey:@"time_start"]];
                 NSString *endD=[NSString stringWithFormat:@"%@ %@",[[[responseObject valueForKey:@"result"] valueForKey:@"record"] valueForKey:@"due_date"],[[[responseObject valueForKey:@"result"] valueForKey:@"record"] valueForKey:@"time_end"]];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

                NSDate *stRtdDate=[formatter dateFromString:startD];
                NSDate *stenDate=[formatter dateFromString:endD];
                [formatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
                
                startdate.text=startD;
                
                endDate.text=endD;
                


            }
            
        }else{
            STOPLOADING()
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
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

@end
