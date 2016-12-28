//
//  FollowupDateVC.m
//  Real Estat
//
//  Created by NLS32-MAC on 25/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import "FollowupDateVC.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "Static.h"
#import "Utility.h"
#import "FollowDetailVC.h"
@interface FollowupDateVC ()

@end

@implementation FollowupDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Follow Up Date";
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    [Utility setNavigationBar:self.navigationController];
    [self getFollowupData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getFollowupData{
    
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_MODULE_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:[[AppDelegate initAppdelegate].dictCurrentoption valueForKey:@"name"] forKey:@"module"];
    

    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                arrFollowUpdata=[[responseObject valueForKey:@"result"] valueForKey:@"records"] ;
                
                if(arrFollowUpdata.count==0){
                    lblNoData.hidden=false;
                    lblNoData.text=[NSString stringWithFormat:@"No %@ Found",self.title];
                }
                
                [tblView reloadData];
            
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrFollowUpdata count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier] ;
    cell.textLabel.text =[[arrFollowUpdata objectAtIndex:indexPath.row] valueForKey:@"label"];
    cell.textLabel.font=[UIFont fontWithName:FONT_REGULAR size:14.0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSMutableDictionary *dic=[arrFollowUpdata objectAtIndex:indexPath.row];
    FollowDetailVC *objFollowDetail=[[FollowDetailVC alloc]initWithNibName:@"FollowDetailVC" bundle:nil];
    objFollowDetail.dict=dic;
    [self.navigationController pushViewController:objFollowDetail animated:true];
}
@end
