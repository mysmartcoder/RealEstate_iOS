//
//  FollowDetailVC.m
//  Real Estat
//
//  Created by NLS42-MAC on 31/05/16.
//  Copyright © 2016 . All rights reserved.
//

#import "FollowDetailVC.h"
#import "AppDelegate.h"
#import "Static.h"
#import "Utility.h"
@interface FollowDetailVC ()

@end

@implementation FollowDetailVC
@synthesize dict;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Date Detail";
   dateOfCall.text =[self.dict valueForKey:@"label"];
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
    [dictSe setObject:[self.dict valueForKey:@"id"] forKey:@"record"];
    
    [manager POST:WEBSERVICE_URL parameters:dictSe progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        STOPLOADING()

        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                assignTo.text=[[[[responseObject valueForKey:@"result"] valueForKey:@"record"] valueForKey:@"assigned_user_id"] valueForKey:@"label"];
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
