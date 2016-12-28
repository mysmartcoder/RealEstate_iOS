//
//  FollowupDateVC.m
//  Real Estat
//
//  Created by NLS32-MAC on 25/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import "ClientsVC.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "Static.h"
#import "Utility.h"
#import "ClientDetailVC.h"
#import "EditClientVC.h"
#import "StrategistEditVC.h"

@interface ClientsVC ()<UISearchBarDelegate,UITextFieldDelegate>

@end

@implementation ClientsVC
@synthesize isStrategist;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[[AppDelegate initAppdelegate].dictCurrentoption valueForKey:@"label"];
    [Utility setNavigationBar:self.navigationController];
    [self getFollowupData];
//    [self.searchDisplayController.searchBar setPlaceholder:@"Search"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
//    UITextField *txfSearchField = [self.searchBarFortbl valueForKey:@"_searchField"];
//    UILabel *lblSearchField = [txfSearchField valueForKey:@"_placeholderLabel"];
//    lblSearchField.frame=CGRectMake(lblSearchField.frame.origin.x, -100,10, 300);
//    [self.searchBarFortbl addSubview:lblSearchField];
////    lblSearchField.textAlignment=NSTextAlignmentCenter;
//    lblSearchField.numberOfLines=0;
//    lblSearchField.text=@"Search";
//    for (UIView *subView in self.searchBarFortbl.subviews){
//        for (UIView *tmpView in subView.subviews) {
//            if ([tmpView isKindOfClass:[UITextField class]]) {
//                UITextField *text = (UITextField*)tmpView;
////                [self drawPlaceholderInRect:text];
//                    // text.delegate=self;
//               //text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                    //text.rightViewMode = UITextFieldViewModeAlways;
//            }
//        }
//        
//    }
}


-(void)getFollowupData{
    
    /*

     Parameter Pass
     ------------------
     _operation = dashboardFollowUpDate
     _session = session
     module = Home
     userid = strategist login id
     
     
     
     
     */
    
    
    
    SHOWLOADING(@"Loading")
    NSMutableDictionary *dictApp=[AppDelegate initAppdelegate].dictCurrentoption;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_MODULE_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:[dictApp valueForKey:@"name"] forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                arrFollowUpdata=[[responseObject valueForKey:@"result"]  valueForKey:@"records"];
                
                if(arrFollowUpdata.count==0){
                    lblNorecord.hidden=false;
                    lblNorecord.text=[NSString stringWithFormat:@"No %@ Found",self.title];
                }
                [tblView reloadData];
            }
            
        }else{
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
    return [arrFollowUpdata count];    //count number of row from counting array hear cataGorry is An Array
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier] ;
    
    NSDictionary *tmpDic;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tmpDic = [NSDictionary dictionaryWithDictionary:[searchResults objectAtIndex:indexPath.row]];
    } else {
        tmpDic = [NSDictionary dictionaryWithDictionary:[arrFollowUpdata objectAtIndex:indexPath.row]];

    }
    
    cell.textLabel.text =[tmpDic valueForKey:@"label"];
    cell.textLabel.font=[UIFont fontWithName:FONT_REGULAR size:14.0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSMutableDictionary *tmpDic;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tmpDic = [NSMutableDictionary dictionaryWithDictionary:[searchResults objectAtIndex:indexPath.row]];
    } else {
        tmpDic = [NSMutableDictionary dictionaryWithDictionary:[arrFollowUpdata objectAtIndex:indexPath.row]];
        
    }
    
    
    if([self.title isEqualToString:@"Clients"]){
        EditClientVC *objD=[[EditClientVC alloc]initWithNibName:@"EditClientVC" bundle:nil];
        objD.dictInfo=tmpDic;
        [self.navigationController pushViewController:objD animated:true];
    }
    
    if([self.title isEqualToString:@"Strategies"]){
        StrategistEditVC *objD=[[StrategistEditVC alloc]initWithNibName:@"StrategistEditVC" bundle:nil];
        objD.dictInfo=tmpDic;
        [self.navigationController pushViewController:objD animated:true];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"label contains[c] %@", searchText];
    searchResults = [arrFollowUpdata filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
@end
