    //
    //  SideMenuVC.m
    //  RojMel
    //
    //  Created by NLS32-MAC on 27/07/15.
    //  Copyright (c) 2015 . All rights reserved.
    //

#import "SideMenuVC.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "AsyncImageView.h"
#import "Static.h"
#import "Locale.h"
#import "NYAlertViewController.h"

@interface SideMenuVC ()
{
    UITableViewCell *objcell;
    AsyncImageView *imgUser;
    UILabel *lblWelcome;
    BOOL isProvider;
    UILabel *lblComit,*lblSatis;
    NSMutableArray *arrOption;
}
@end

@implementation SideMenuVC
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    
    [self.view setBackgroundColor:BGCOLOR];
    [super viewDidLoad];
    self.edgesForExtendedLayout=0;
    self.navigationController.navigationBarHidden=true;
    
    
    float width=self.view.frame.size.width;
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    headerView.backgroundColor=NAVBARCLOLOR;
    
    imgUser=[[AsyncImageView alloc]initWithFrame:CGRectMake(20, 30, 167, 88)];
    [imgUser setImage:[UIImage imageNamed:@"logo.png"]];
    
    [headerView addSubview:imgUser];
    
    
    lblWelcome=[[UILabel alloc]initWithFrame:CGRectMake(25,30+88+2, width-20-60,20)];
    lblWelcome.font=[UIFont fontWithName:FONT_REGULAR size:12];
    lblWelcome.text=@"Real Estat";
        //    lblWelcome.textAlignment=NSTextAlignmentCenter;
    lblWelcome.textColor=BGCOLOR;
    [headerView addSubview:lblWelcome];
    
    tblView.tableHeaderView=headerView;
    arrOption=[[NSMutableArray alloc]init];
    
    if([ROLE isEqualToString:@"Client"]){
       /* NSMutableArray *arrTemp=[ARRSIDEMENU mutableCopy];
        for(int i=0;i<arrTemp.count;i++){
            NSMutableDictionary *dict=[arrTemp objectAtIndex:i];
            
            if([[dict valueForKey:@"label"]isEqualToString:@"Appointments"]  || [[dict valueForKey:@"label"]isEqualToString:@"Strategies"] || [[dict valueForKey:@"label"]isEqualToString:@"Strategies"] || [[dict valueForKey:@"label"]isEqualToString:@"Town Feedback"]){
                
                if([[dict valueForKey:@"label"]isEqualToString:@"Town Feedback"]){
                    [AppDelegate initAppdelegate].objDictTown=dict;
                }
                
                [arrOption addObject:dict];
            }
        }
        */
    }else if([ROLE isEqualToString:@"Agent"])
        {
        NSMutableArray *arrTemp=[ARRSIDEMENU mutableCopy];
        for(int i=0;i<arrTemp.count;i++){
            NSMutableDictionary *dict=[arrTemp objectAtIndex:i];
            if([[dict valueForKey:@"label"]isEqualToString:@"Appointments"] || [[dict valueForKey:@"label"]isEqualToString:@"Clients"] ){
                [arrOption addObject:dict];
            }
        }
        }else{
            NSMutableArray *arrTemp=[ARRSIDEMENU mutableCopy];
            for(int i=0;i<arrTemp.count;i++){
                NSMutableDictionary *dict=[arrTemp objectAtIndex:i];
                if([[dict valueForKey:@"label"]isEqualToString:@"Appointments"] || [[dict valueForKey:@"label"]isEqualToString:@"Clients"] ||[[dict valueForKey:@"label"]isEqualToString:@"Strategies"] ||[[dict valueForKey:@"label"]isEqualToString:@"Follow Up Date"]){
                    [arrOption addObject:dict];
                }
            }
        }
    
    NSMutableDictionary *dictDahs=[[NSMutableDictionary alloc]init];
    [dictDahs setObject:@"Dashboard" forKey:@"name"];
    [dictDahs setObject:@"Dashboard" forKey:@"label"];
    if(![ROLE isEqualToString:@"Client"]){
        [arrOption insertObject:dictDahs atIndex:0];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
        //    [self setUserInfo];
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
/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
 {
 return 30;
 }
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
 {
 UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
 UILabel *lbluser=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 25)];
 lbluser.text=[NSString stringWithFormat:@"Welcome, %@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"FirstName"],[[NSUserDefaults standardUserDefaults]valueForKey:@"LastName"]];
 [lbluser setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
 
 [headerView addSubview:lbluser];
 
 return headerView;
 
 }*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    return 48;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return arrOption.count+1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
        //    cell.backgroundColor=[UIColor colorWithRed:236.0/255 green:233.0/255 blue:233.0/255 alpha:1.0];
        //    cell.contentView.backgroundColor=[UIColor colorWithRed:236.0/255 green:233.0/255 blue:233.0/255 alpha:1.0];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    objcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    objcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    objcell.detailTextLabel.font=[UIFont fontWithName:FONT_REGULAR size:10.0];
    objcell.detailTextLabel.textColor=[UIColor colorWithRed:255.0/255.0 green:0.0 blue:0.0 alpha:0.9];
    
    NSString *textTitle;
    NSString *image;
    
    
    if(indexPath.row==arrOption.count){
        textTitle=@"Logout";
        image=@"profile_icon.png";
    }else{
        NSMutableDictionary *dict=[arrOption objectAtIndex:indexPath.row];
        textTitle=[dict valueForKey:@"label"];
    }
    objcell.imageView.image=[UIImage imageNamed:image];
    
    objcell.imageView.image = [objcell.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [objcell.imageView setTintColor:NAVBARCLOLOR];
    objcell.textLabel.text=textTitle;
    
    objcell.textLabel.font=[UIFont fontWithName:FONT_REGULAR size:13.0];
    return objcell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==arrOption.count){
        NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
        
        alertViewController.backgroundTapDismissalGestureEnabled = YES;
        alertViewController.swipeDismissalGestureEnabled = YES;
        
        alertViewController.title = @"Real Estat";
        alertViewController.message = @"Are you sure to logout?";
        
        alertViewController.titleFont = [UIFont fontWithName:FONT_REGULAR size:16.0];
        alertViewController.messageFont = [UIFont fontWithName:FONT_REGULAR size:16.0f];
        alertViewController.buttonTitleFont = [UIFont fontWithName:FONT_REGULAR size:alertViewController.buttonTitleFont.pointSize];
        alertViewController.cancelButtonTitleFont = [UIFont fontWithName:FONT_REGULAR size:alertViewController.cancelButtonTitleFont.pointSize];
        
        alertViewController.alertViewBackgroundColor = BGCOLOR;
        alertViewController.alertViewCornerRadius = 10.0f;
        
        alertViewController.titleColor = NAVBARCLOLOR;
        alertViewController.messageColor = [UIColor darkGrayColor];
        
        alertViewController.buttonColor = NAVBARCLOLOR;
        alertViewController.buttonTitleColor = BGCOLOR;
        
        alertViewController.cancelButtonColor = [UIColor redColor];
        alertViewController.cancelButtonTitleColor = BGCOLOR;
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(NYAlertAction *action) {
                                                                  [alertViewController dismissViewControllerAnimated:YES completion:nil];
                                                              }]];
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"Yes"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(NYAlertAction *action) {
                                                                  
                                                                  [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"USER"];
                                                                  [[AppDelegate initAppdelegate] setLoginView];
                                                                  [alertViewController dismissViewControllerAnimated:YES completion:nil];
                                                              }]];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertViewController animated:YES completion:nil];
        
    }else{
        [[AppDelegate initAppdelegate]setRightPanel:[arrOption objectAtIndex:indexPath.row]];
        
    }
    
}
@end
