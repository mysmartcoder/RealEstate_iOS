//
//  ClientDetailVC.m
//  Real Estat
//
//  Created by NLS32-MAC on 02/05/16.
//  Copyright © 2016 . All rights reserved.
//

#import "ClientDetailVC.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "Static.h"
#import "Utility.h"
#import "AsyncImageView.h"
#import "EditClientVC.h"

@interface ClientDetailVC ()

@end

@implementation ClientDetailVC
@synthesize dictInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Client Detail";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(btnEditClicked)]];
    [self getAllModileLabels];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnEditClicked
{
    EditClientVC *objCD=[[EditClientVC alloc]initWithNibName:@"EditClientVC" bundle:nil];
    [self.navigationController pushViewController:objCD animated:TRUE];
}
-(void)getAllModileLabels{
    
    /*
     ------------------
     URL : [api_url]
     Parameter Pass
     ------------------
     _operation = describe
     _session = session (from Login)
     module = Module name
    
     */
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_ALL_FIELDS forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:@"Contacts" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
             
            }
            
        }else{
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
    
    
}


-(void)getAllDashboardData{
    
    /*
     
     _operation = selectAgentCityRecords
     _session = strategies session id
     clientid = selected client id
     agentname = selected agent name
     recordid = record id
     module = module name (Documents)
     
     */
    
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:FETCH_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:[self.dictInfo valueForKey:@"id"] forKey:@"record"];

    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                
                    //                arrEvent;
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



@end
