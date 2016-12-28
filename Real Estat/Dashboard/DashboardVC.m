    //
    //  DashboardVC.m
    //  Real Estat
    //
    //  Created by NLS32-MAC on 25/04/16.
    //  Copyright © 2016 . All rights reserved.
    //

#import "DashboardVC.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "Static.h"
#import "Utility.h"
#import "AsyncImageView.h"
#import "AgentDisplayCell.h"
#import "DropDownListView.h"
#import "UITextView+Placeholder.h"
#import "EditClientVC_Agent.h"
#import "AddAppointment.h"
#import "ClientsVC.h"
#import "PdfViewVC.h"
#import "AddFeedbackVC.h"
#import <MessageUI/MessageUI.h>
#import "EditClientVC.h"
@interface DashboardVC ()<kDropDownListViewDelegate,MFMailComposeViewControllerDelegate>


{
    NSString *loginType;
    DropDownListView * Dropobj;
    UIView *viewbg_Popup;
    
    
}
@end

@implementation DashboardVC
@synthesize documentInteractionController;
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utility setNavigationBar:self.navigationController];
    [tblView setBackgroundColor:self.view.backgroundColor];
    txtNotes.placeholder=@"Enter Notes";
    tblView.estimatedRowHeight = 70.0; // for example. Set your average height
    tblView.rowHeight = UITableViewAutomaticDimension;
    [tblView reloadData];
    self.title=@"Home";
    if([ROLE isEqualToString:@"Client"]){
        loginType=@"Client";
        tblView.tableHeaderView=headerView;
        [self getAllDashboardData];
    }else  if([ROLE isEqualToString:@"Agent"]){
        loginType=@"Agent";
        [self getAllAgentRecords];
    }else{
        loginType=@"Strategist";
        
        [self getAllStretegiesRecord];
        
    }
    [txtNotes.layer setBorderColor:NAVBARCLOLOR.CGColor];
    [txtNotes.layer setBorderWidth:1.0];
    
        // Do any additional setup after loading the view from its nib.
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

#pragma mark- UITableView DELEGATES
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if([loginType isEqualToString:@"Client"]){
        if(indexPath.section==1){
//            return 180;
            return 215;
        }
        if(indexPath.section==2){
            UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tblView.frame.size.width-20, 30)];
            lbl.numberOfLines=0;
            lbl.text =[[arrStrategist objectAtIndex:indexPath.row] valueForKey:@"title"];
            [lbl sizeToFit];
            NSMutableArray *arr=[[arrStrategist objectAtIndex:indexPath.row] valueForKey:@"file"];
            return lbl.frame.size.height+10+(arr.count * 40);
        }
        return 44;
    }else if([loginType isEqualToString:@"Strategist"]){
        return 44;
    }else{
        return 310;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    if([loginType isEqualToString:@"Client"]){
        return 5;
    }else if([loginType isEqualToString:@"Strategist"]){
        return 5;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([loginType isEqualToString:@"Client"]){
        return 4;    //count of section
    }else if([loginType isEqualToString:@"Strategist"]){
        return 3;    //count of section
    }else{
        return 1;
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if([loginType isEqualToString:@"Client"]){
        return 40;
    }else if([loginType isEqualToString:@"Strategist"]){
        return 50;
    }
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   {
    
    if([loginType isEqualToString:@"Client"]){
        UIView *vi=[[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 40)];
        
        
        UILabel *lblheader=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        [lblheader setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.5 ]];
        
        if(section==0){
            [lblheader setText:@"   Appointments"];
        }
        
        if(section==1){
            [lblheader setText:@"   Real Estat Deal Team"];
        }
        
        if(section==2){
            [lblheader setText:@"   Your Home Search Strategy"];
        }
        
        if(section==3){
            [lblheader setText:@"   Your Town Feedback"];
        }
        
        [lblheader setFont:[UIFont fontWithName:FONT_REGULAR size:15.0]];
        
        [vi setBackgroundColor:[UIColor whiteColor]];
        [vi addSubview:lblheader];
        return vi;
        
    }else if([loginType isEqualToString:@"Strategist"]){
        
        UIView *vi=[[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 50)];
        
        
        UILabel *lblheader=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 50)];
        [lblheader setBackgroundColor:[UIColor whiteColor]];
        
        if(section==0){
            [lblheader setText:@"   History"];
        }
        
        if(section==1){
            [lblheader setText:@"   Information"];
        }
        
        if(section==2){
            [lblheader setText:@"   Follow Up Date"];
        }
        
        [lblheader setFont:[UIFont fontWithName:FONT_REGULAR size:20.0]];
        [vi setBackgroundColor:[UIColor clearColor]];
        [vi addSubview:lblheader];
        return vi;
        
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([loginType isEqualToString:@"Client"]){
        if(section==0){
            return [arrEvent count];
        }
        if(section==1){
            return [arrBio count];
        }
        if(section==2){
            return [arrStrategist count];
        }
        if(section==3){
            return [arrFeedback count];
        }
    }else if([loginType isEqualToString:@"Strategist"]){
        if(section==0){
            return [arrHistory count];
        }
        if(section==2){
            return [arrFollowUpdata count];
        }
        if(section==1){
            return [arrInfo count];
        }
    }else{
        
        return [arrAgent count];
    }
    return 0;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier] ;
    if([loginType isEqualToString:@"Client"]){
        
        if(indexPath.section==1){
            cell.textLabel.numberOfLines=0;
            cell.textLabel.text =@"\n\n\n\n\n\n";
            [cell.textLabel sizeToFit];
            
            AsyncImageView *imgUser=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 20, 90, 100)];
            imgUser.imageURL=[NSURL URLWithString:[[arrBio objectAtIndex:indexPath.row]valueForKey:@"avatar"]];
            [cell.contentView addSubview:imgUser];
            
            UILabel *lbluyserName=[[UILabel alloc]initWithFrame:CGRectMake(imgUser.frame.origin.x+imgUser.frame.size.width+5, 10,tblView.frame.size.width-(imgUser.frame.origin.x+imgUser.frame.size.width+5), 20)];
            [lbluyserName setFont:[UIFont fontWithName:FONT_BOLD size:14.0]];
            lbluyserName.text=[[arrBio objectAtIndex:indexPath.row]valueForKey:@"name"];
            [lbluyserName setTextColor:[UIColor darkGrayColor]];
            [cell.contentView addSubview:lbluyserName];
            
            UILabel *lblRole=[[UILabel alloc]initWithFrame:CGRectMake(imgUser.frame.origin.x+imgUser.frame.size.width+5, lbluyserName.frame.origin.y+lbluyserName.frame.size.height, lbluyserName.frame.size.width, 20)];
            [lblRole setFont:[UIFont fontWithName:FONT_BOLD size:14.0]];
            lblRole.text=[[arrBio objectAtIndex:indexPath.row]valueForKey:@"role"];
            [lblRole setTextColor:[UIColor darkGrayColor]];
            [cell.contentView addSubview:lblRole];
            
            UILabel *lblEmail=[[UILabel alloc]initWithFrame:CGRectMake(lblRole.frame.origin.x, lblRole.frame.origin.y+lblRole.frame.size.height,  lbluyserName.frame.size.width, 20)];
            [lblEmail setFont:[UIFont fontWithName:FONT_BOLD size:14.0]];
            lblEmail.text=[NSString stringWithFormat:@"Email : %@",[[arrBio objectAtIndex:indexPath.row]valueForKey:@"email"]];
            [lblEmail setTextColor:[UIColor darkGrayColor]];
            [cell.contentView addSubview:lblEmail];
            

            
            UILabel *lblMob=[[UILabel alloc]initWithFrame:CGRectMake(lblRole.frame.origin.x, lblEmail.frame.origin.y+lblEmail.frame.size.height,  lbluyserName.frame.size.width, 20)];
            [lblMob setFont:[UIFont fontWithName:FONT_BOLD size:14.0]];
            lblMob.text=[NSString stringWithFormat:@"Mobile : %@",[[arrBio objectAtIndex:indexPath.row]valueForKey:@"phone_mobile"]];
            [lblMob setTextColor:[UIColor darkGrayColor]];
            [cell.contentView addSubview:lblMob];
            
            
            
            
            UIButton *btnAddApp=[[UIButton alloc]initWithFrame:CGRectMake(lbluyserName.frame.origin.x, lblMob.frame.origin.y+lblMob.frame.size.height+5, WIDTH-lbluyserName.frame.origin.x-15, 25)];
            [btnAddApp.layer setCornerRadius:4.0];
            [btnAddApp setBackgroundColor:NAVBARCLOLOR];
            [btnAddApp.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.0]];
            btnAddApp.accessibilityLabel=[[arrBio objectAtIndex:indexPath.row] valueForKey:@"id"];
            [btnAddApp setTitle:[NSString stringWithFormat:@"Send Notes to %@",[[arrBio objectAtIndex:indexPath.row]valueForKey:@"role"]] forState:UIControlStateNormal];
            [btnAddApp addTarget:self action:@selector(gotToTownFeedback:) forControlEvents:UIControlEventTouchUpInside];
            [btnAddApp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            if(![lblRole.text isEqualToString:@"Agent"])
                [cell.contentView addSubview:btnAddApp];
            
                //            NSLog(@"%@",[[arrBio objectAtIndex:indexPath.row]valueForKey:@"role"]);
                //            if([[[arrBio objectAtIndex:indexPath.row]valueForKey:@"role"] isEqualToString:@"agent"]){
                //                [btnAddApp setTitle:@"Email" forState:UIControlStateNormal];
                //                [btnAddApp addTarget:self action:@selector(openEmailComposer:) forControlEvents:UIControlEventTouchUpInside];
                //            }else{
                //
                //            [btnAddApp setTitle:@"Send Notes to strategist" forState:UIControlStateNormal];
                //            [btnAddApp addTarget:self action:@selector(gotToTownFeedback:) forControlEvents:UIControlEventTouchUpInside];
                //            }
            
            
            
            UIButton *btnEmail;
                
                            NSString *mobileNumberStr=[NSString stringWithFormat:@"%@",[[arrBio objectAtIndex:indexPath.row]valueForKey:@"phone_mobile"]];
                            if (mobileNumberStr.length!=0) {
                               
                                UIButton *btnCall=[[UIButton alloc]initWithFrame:CGRectMake(btnAddApp.frame.origin.x, btnAddApp.frame.origin.y+btnAddApp.frame.size.height+5,  WIDTH-lbluyserName.frame.origin.x-15, 25)];
                                [btnCall.layer setCornerRadius:4.0];
                                [btnCall setBackgroundColor:NAVBARCLOLOR];
                                [btnCall.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.0]];
                                btnCall.accessibilityLabel=[[arrBio objectAtIndex:indexPath.row] valueForKey:@"id"];
                                [btnCall setTitle:@"Call" forState:UIControlStateNormal];
                                [btnCall addTarget:self action:@selector(CallClientMethod:) forControlEvents:UIControlEventTouchUpInside];
                                [btnCall setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                [cell.contentView addSubview:btnCall];
                                
                                btnEmail=[[UIButton alloc]initWithFrame:CGRectMake(btnCall.frame.origin.x, btnCall.frame.origin.y+btnCall.frame.size.height+5,  WIDTH-lbluyserName.frame.origin.x-15, 25)];

                            }else{
                            
                                btnEmail=[[UIButton alloc]initWithFrame:CGRectMake(btnAddApp.frame.origin.x, btnAddApp.frame.origin.y+btnAddApp.frame.size.height+5,  WIDTH-lbluyserName.frame.origin.x-15, 25)];

                            
                            }
            
            
            [btnEmail.layer setCornerRadius:4.0];
            [btnEmail setBackgroundColor:NAVBARCLOLOR];
            [btnEmail.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.0]];
            btnEmail.accessibilityLabel=[[arrBio objectAtIndex:indexPath.row] valueForKey:@"id"];
            [btnEmail setTitle:@"Email" forState:UIControlStateNormal];
            [btnEmail addTarget:self action:@selector(openEmailComposer:) forControlEvents:UIControlEventTouchUpInside];
            [btnEmail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:btnEmail];
            
            
            UIButton *btnAddFeed=[[UIButton alloc]initWithFrame:CGRectMake(btnAddApp.frame.origin.x, btnEmail.frame.origin.y+btnEmail.frame.size.height+5,  WIDTH-lbluyserName.frame.origin.x-15, 25)];
            btnAddFeed.tag=indexPath.row;
            [btnAddFeed.layer setCornerRadius:4.0];
            [btnAddFeed setBackgroundColor:NAVBARCLOLOR];
            [btnAddFeed.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.0]];
            btnAddFeed.accessibilityLabel=[[arrBio objectAtIndex:indexPath.row] valueForKey:@"id"];
            [btnAddFeed setTitle:@"Schedule" forState:UIControlStateNormal];
            [btnAddFeed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnAddFeed addTarget:self action:@selector(selectbtnSchedule:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnAddFeed];
            
        }
        if(indexPath.section==2){
            
            NSMutableArray *arr=[[arrStrategist objectAtIndex:indexPath.row] valueForKey:@"file"];
            
            if(arr.count >0){
                
                UILabel *lblTit=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 20)];
                lblTit.text=@"Title";
                lblTit.font=[UIFont fontWithName:FONT_REGULAR size:14.0];
                [cell.contentView addSubview:lblTit];
                
                UILabel *lblTitTown=[[UILabel alloc]initWithFrame:CGRectMake(160, 0, 150, 20)];
                lblTitTown.text=@"Town Feedback";
                lblTitTown.font=[UIFont fontWithName:FONT_REGULAR size:14.0];
                [cell.contentView addSubview:lblTitTown];
                
                UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(13,20, tblView.frame.size.width-20, 30)];
                    //                lbl.numberOfLines=0;
                lbl.font=[UIFont fontWithName:FONT_REGULAR size:16.0];
                
                    //                [lbl setTextColor:[UIColor darkGrayColor]];
                
                lbl.text =[[arrStrategist objectAtIndex:indexPath.row] valueForKey:@"title"];
                    //                [lbl sizeToFit];
                [cell.contentView addSubview:lbl];
                
                
                for(int i=0;i<arr.count;i++){
                    
                    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(15,lbl.frame.origin.y+ lbl.frame.size.height +(32*i), 100, 30)];
                    [btn.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:14.0]];
                    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    [btn setTitle:[[arr objectAtIndex:i]valueForKey:@"name"] forState:UIControlStateNormal];
                    btn.accessibilityLabel=[[arr objectAtIndex:i]valueForKey:@"url"];
                    [btn addTarget:self action:@selector(dowloadFile:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn];
                    
                    
                    UIButton *btnAddFeed=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH- 120,lbl.frame.origin.y+lbl.frame.size.height +(33*i), 100, 26)];
                    [btnAddFeed.layer setCornerRadius:4.0];
                    [btnAddFeed setBackgroundColor:NAVBARCLOLOR];
                    [btnAddFeed.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.0]];
                    [btnAddFeed setTitle:@"Leave Feedback" forState:UIControlStateNormal];
                    [btnAddFeed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btnAddFeed addTarget:self action:@selector(gotToTownFeedback:) forControlEvents:UIControlEventTouchUpInside];
                    btnAddFeed.accessibilityLabel=USER_ID;
                    btnAddFeed.accessibilityHint=[[arr objectAtIndex:i]valueForKey:@"town"];
                    
                    [cell.contentView addSubview:btnAddFeed];
                    
                        //                    cell.accessoryView=btnAddFeed;
                    
                    UILabel *lblSep=[[UILabel alloc]initWithFrame:CGRectMake(10, lbl.frame.origin.y+ lbl.frame.size.height +(32*i)+30, WIDTH-40, 1)];
                    [lblSep setBackgroundColor:[UIColor lightGrayColor]];
                    [cell.contentView addSubview:lblSep];
                    
                }
            }else{
                cell.textLabel.numberOfLines=0;
                cell.textLabel.text =[[arrStrategist objectAtIndex:indexPath.row] valueForKey:@"title"];
                [cell.textLabel sizeToFit];
            }
            
                //            UIButton *btnAddFeed=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 25)];
                //            [btnAddFeed.layer setCornerRadius:4.0];
                //            [btnAddFeed setBackgroundColor:NAVBARCLOLOR];
                //            [btnAddFeed.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.0]];
                //            [btnAddFeed setTitle:@"Leave Feedback" forState:UIControlStateNormal];
                //            [btnAddFeed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                //            [btnAddFeed addTarget:self action:@selector(gotToTownFeedback:) forControlEvents:UIControlEventTouchUpInside];
                //            btnAddFeed.accessibilityLabel=USER_ID;
                //            cell.accessoryView=btnAddFeed;
            
            
            
            
        }
        
    }
    else if([loginType isEqualToString:@"Strategist"]){
        
        if(indexPath.section==0){
            cell.textLabel.numberOfLines=0;
            cell.textLabel.text =[[arrHistory objectAtIndex:indexPath.row] valueForKey:@"commentcontent"];
            [cell.textLabel sizeToFit];
        }
        if(indexPath.section==1){
            cell.textLabel.numberOfLines=0;
            NSError *jsonError;
            NSData *objectData = [ [Utility decodeHTMLEntities:[arrInfo valueForKey:@"Information" ]] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
            
            cell.textLabel.text =[json valueForKey:@"contents" ];
            [cell.textLabel sizeToFit];
        }
        
        
        
        if(indexPath.section==2){
            cell.textLabel.text =[[arrFollowUpdata objectAtIndex:indexPath.row] valueForKey:@"fud_tks_dateofcall"];
        }
    }else{
        
        
        AgentDisplayCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AgentDisplayCell"];
        
        
        if (cell == nil) {
                // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AgentDisplayCell" owner:self options:nil];
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSMutableDictionary *dict=[arrAgent objectAtIndex:indexPath.row];
        cell.userImage.imageURL=[NSURL URLWithString:[dict valueForKey:@"avatar"]];
        cell.name_usr.text=[NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"firstname"],[dict valueForKey:@"lastname"]];
        cell.city.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"cf_755"]];
        cell.mail.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"email"]];
        
        
        cell.btnHavemade.tag=indexPath.row;
        [cell.btnHavemade addTarget:self action:@selector(selectHaveMade:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnClientScheduling.tag=indexPath.row;
        [cell.btnClientScheduling addTarget:self action:@selector(selectClientScheduling:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnNotRespomsive.tag=indexPath.row;
        [cell.btnNotRespomsive addTarget:self action:@selector(selectbtnNotRespomsive:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnSchedule.tag=indexPath.row;
        [cell.btnSchedule addTarget:self action:@selector(selectbtnSchedule:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnChooseRank.tag=indexPath.row;
        [cell.btnChooseRank addTarget:self action:@selector(selectbtnChooseRank:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnProfile.tag=indexPath.row;
        [cell.btnProfile addTarget:self action:@selector(selectbtnProfile:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectOption.tag=indexPath.row;
        if([[dict valueForKey:@"cf_993"] isEqualToString:@""]){
            [cell.selectOption setTitle:@"Select an Option" forState:UIControlStateNormal];
        }else{
            [cell.selectOption setTitle:[dict valueForKey:@"cf_993"] forState:UIControlStateNormal];
        }
        [cell.selectOption addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.dealClose.tag=indexPath.row;
        [cell.dealClose addTarget:self action:@selector(selectdealClose:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.btnNotes.tag=indexPath.row;
        [cell.btnNotes addTarget:self action:@selector(selectbtnNotes:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnSaveRecord.tag=indexPath.row;
        [cell.btnSaveRecord addTarget:self action:@selector(selectbtnSaveRecord:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if([dict objectForKey:@"initial_contact"]){
            if([[dict valueForKey:@"initial_contact"] integerValue]==1){
                    //                cell.btnHavemade.selected=true;
                [cell.btnHavemade setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
                cell.btnHavemade.enabled=false;
            }
        }
        
        
        if([dict objectForKey:@"dealed_closed"]){
            if([[dict valueForKey:@"dealed_closed"] integerValue]==1){
                    //                cell.dealClose.selected=true;
                [cell.dealClose setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
                cell.dealClose.enabled=false;
                
            }
        }
        
        if([dict objectForKey:@"not_responsive"]){
            if([[dict valueForKey:@"not_responsive"] integerValue]==1){
                    //                cell.btnNotRespomsive.selected=true;
                [cell.btnNotRespomsive setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
                
                cell.btnNotRespomsive.enabled=false;
                
            }
            
        }
        
        if([dict objectForKey:@"actively_scheduling"]){
            if([[dict valueForKey:@"actively_scheduling"] integerValue]==1){
                    //                cell.btnClientScheduling.selected=true;
                cell.btnClientScheduling.enabled=false;
                [cell.btnClientScheduling setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
                
                
            }
        }
        if([[dict valueForKey:@"cf_993"] isEqualToString:@"Signed Contract"]){
            [cell.dealClose setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
            cell.dealClose.enabled=false;
            cell.btnClientScheduling.enabled=false;
            cell.btnNotRespomsive.enabled=false;
            cell.btnHavemade.enabled=false;
            
            
        }
        
        return cell;
        
    }
    
    cell.textLabel.font=[UIFont fontWithName:FONT_REGULAR size:16.0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
#pragma mark- DASHBOARD DATA WEBSERVICES

-(void)getAllDashboardData{
    
    /*
     _operation = dashboardAppointmentsRecords
     _session = session
     module = Home
     userid = client login id
     
     */
    
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_ALL_DASHBOARDINFO forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    
    [dict setObject:USER_ID forKey:@"userid"];
    [dict setObject:@"Home" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                
                    //                arrEvent;
                [self getAgentBio];
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



-(void)getAllStretegiesRecord{
    
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_HISTORY_REC forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    
    [dict setObject:USER_ID forKey:@"userid"];
    [dict setObject:@"Home" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [self getInformation];
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                
                arrHistory=[[responseObject valueForKey:@"result" ] valueForKey:@"historyrecords"];
            }
        }else{
            STOPLOADING()
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
}

-(void)getInformation
{
    
    SHOWLOADING(@"Loading")
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_INFORMATION forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:USER_ID forKey:@"userid"];
    [dict setObject:@"Home" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        [self getFollowupData];
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                arrInfo=[responseObject valueForKey:@"result" ] ;
                [tblView reloadData];
                
            }
        }else{
            STOPLOADING()
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        
        NSLog(@"%@",error.localizedDescription);
        
    }];
    
    
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_FOLLOWUPDATE forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    
    [dict setObject:USER_ID forKey:@"userid"];
    [dict setObject:@"Home" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                arrFollowUpdata=[[[responseObject valueForKey:@"result"] valueForKey:@"FollowUpDate"] valueForKey:@"record"];
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



#pragma mark
-(void)getAgentBio
{
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_CLIENT_BIO forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:USER_ID forKey:@"userid"];
    [dict setObject:@"Home" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                
                arrBio=[[responseObject valueForKey:@"result"] valueForKey:@"AgentAndStrategistBio"];
                [tblView reloadData];
                [self getStretegistFeedback];
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


-(void)getStretegistFeedback
{
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_CLIENT_STRETEGISES forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    
    [dict setObject:USER_ID forKey:@"userid"];
    [dict setObject:@"Home" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                
                arrStrategist=[[responseObject valueForKey:@"result"] valueForKey:@"Strategies"];
                [tblView reloadData];
                [self getTownFeedBack];
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

-(void)getTownFeedBack
{
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_TOWNFEEDBACK forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    
    [dict setObject:USER_ID forKey:@"userid"];
    [dict setObject:@"Home" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                
                arrFeedback=[[responseObject valueForKey:@"result"] valueForKey:@"TownFeedback"];
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


-(void)btnAddAppointmentClicked{
    [self.navigationController pushViewController:[[AddAppointment alloc]initWithNibName:@"AddAppointment" bundle:nil] animated:true];
    
}
-(void)btnAddFeedbackClicked{
    
}

#pragma mark- AGENT METHODS
-(void)gotToTownFeedback:(UIButton *)btn{
    AddFeedbackVC *objf=[[AddFeedbackVC alloc]initWithNibName:@"AddFeedbackVC" bundle:nil];
    objf.assigned_user_id=btn.accessibilityLabel;
    objf.town_str=btn.accessibilityHint;
    [self.navigationController pushViewController:objf animated:true];
    
    
    /*  NSMutableArray *arrTemp=[ARRSIDEMENU mutableCopy];
     for(int i=0;i<arrTemp.count;i++){
     NSMutableDictionary *dict=[arrTemp objectAtIndex:i];
     
     if([[dict valueForKey:@"label"]isEqualToString:@"Appointments"] || [[dict valueForKey:@"label"]isEqualToString:@"Clients"] || [[dict valueForKey:@"label"]isEqualToString:@"Strategies"] || [[dict valueForKey:@"label"]isEqualToString:@"Strategies"] || [[dict valueForKey:@"label"]isEqualToString:@"Town Feedback"]){
     
     if([[dict valueForKey:@"label"]isEqualToString:@"Town Feedback"]){
     [AppDelegate initAppdelegate].objDictTown=dict;
     break;
     }
     
     }
     }
     
     NSMutableDictionary *dict=[[AppDelegate initAppdelegate].objDictTown  mutableCopy];
     [AppDelegate initAppdelegate].dictCurrentoption=dict;
     [self.navigationController pushViewController:[[ClientsVC alloc]initWithNibName:@"ClientsVC" bundle:nil] animated:true];
     */
}

-(void)getAllAgentRecords
{
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_ALL_AGENT_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    
    [dict setObject:USER_ID forKey:@"userid"];
    [dict setObject:@"Home" forKey:@"module"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                arrAgent=[[[[responseObject valueForKey:@"result"] valueForKey:@"agentResult"]valueForKey:@"agentRecord" ] mutableCopy];
                [tblView reloadData];
                arrDropDownVal=[[NSMutableArray alloc]init];
                NSMutableDictionary *dictPick=[[[responseObject valueForKey:@"result"] valueForKey:@"agentResult"] valueForKey:@"picklistRecord"];
                for (id key in dictPick)
                    {
                    id value = [dictPick objectForKey:key];
                    [arrDropDownVal addObject:value ];
                    }
            }
            STOPLOADING()
        }else{
            STOPLOADING()
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
}



-(IBAction)selectHaveMade:(UIButton *)btnsender{
    btnsender.selected=!btnsender.selected;
    
    [self callDealClosedWithTag:btnsender.tag WithAgentRanking:@"" withButton:btnsender];
    
    
}
-(IBAction)selectClientScheduling:(UIButton *)btnsender{
    btnsender.selected=!btnsender.selected;
    [self callDealClosedWithTag:btnsender.tag WithAgentRanking:@"" withButton:btnsender];
    
}

-(IBAction)selectbtnNotRespomsive:(UIButton *)btnsender{
    btnsender.selected=!btnsender.selected;
    [self callDealClosedWithTag:btnsender.tag WithAgentRanking:@"" withButton:btnsender];
    
    
}

-(IBAction)selectbtnSchedule:(UIButton *)btnsender{
    int tagValue=(int)btnsender.tag;
    
    AddAppointment *addAppVC=  (AddAppointment *) [[AddAppointment alloc]initWithNibName:@"AddAppointment" bundle:nil];
    NSString *nameStr=@"";
    NSString *idStr=@"";
    NSMutableDictionary *dict;
    if([loginType isEqualToString:@"Client"]){
        dict=[arrBio objectAtIndex:tagValue];
        nameStr=[NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]];
        idStr=[NSString stringWithFormat:@"19x%@",[dict valueForKey:@"id"]];
    }
    else if([loginType isEqualToString:@"Strategist"]){
    }else{
        dict=[arrAgent objectAtIndex:tagValue];
            //19x
        nameStr=[NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"firstname"],[dict valueForKey:@"lastname"]];
        idStr=[NSString stringWithFormat:@"19x%@",[dict valueForKey:@"user_id"]];
    }
    addAppVC.fromWhichVC=@"Dashboard";
    addAppVC.nameStr=nameStr;
    addAppVC.idStr=idStr;
    [self.navigationController pushViewController:addAppVC animated:true];
}

-(IBAction)selectbtnChooseRank:(UIButton *)btnsender{
    
}

-(IBAction)selectbtnProfile:(UIButton *)btnsender{
        NSMutableDictionary *dictMain=[arrAgent objectAtIndex:btnsender.tag];
        EditClientVC *objD=[[EditClientVC alloc]initWithNibName:@"EditClientVC" bundle:nil];
        objD.dictInfo=dictMain;
        objD.isDataEditable=@"No";
        [self.navigationController pushViewController:objD animated:true];
    
//    NSMutableDictionary *dictMain=[arrAgent objectAtIndex:btnsender.tag];
//    EditClientVC_Agent *objD=[[EditClientVC_Agent alloc]initWithNibName:@"EditClientVC_Agent" bundle:nil];
//    objD.dictInfo=dictMain;
//    objD.isEditable=true;
//    [self.navigationController pushViewController:objD animated:true];
    
}

-(IBAction)selectOption:(UIButton *)btnsender{
    
    [self showDropdownWithOption:nil WithoptionTitle:@"Select option" WithTag:btnsender.tag];
    
}

-(IBAction)selectdealClose:(UIButton *)btnsender{
    btnsender.selected=!btnsender.selected;
}

-(IBAction)selectbtnNotes:(UIButton *)btnsender{
    
    [self.view addSubview:notesView];
    notesView.tag=btnsender.tag;
    [notesView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.36]];
    
}
- (IBAction)saveNotes:(id)sender {
    if([txtNotes.text isEqualToString:@""]){
        [Utility showAlertWithwithMessage:@"Please enter notes"];
        return;
    }
    
    /* 4) Save agent note
     ---------------------------------
     _operation = saveAgentNoteRecords
     _session = session id
     module = Home
     agentid =  agent id(logined user id)
     clientid = client id
     note = notes
     */
    
    SHOWLOADING(@"Loading")
    NSMutableDictionary *dictMain=[arrAgent objectAtIndex:notesView.tag];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:SAVE_AGENT_NOTES forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:USER_ID forKey:@"agentid"];
    if([dict objectForKey:@"clientid"]){
        [dict setObject:[dictMain valueForKey:@"clientid"] forKey:@"clientid"];
    }else if ([dict objectForKey:@"contactid"]){
        [dict setObject:[dictMain valueForKey:@"contactid"] forKey:@"clientid"];
    }
    
    [dict setObject:@"Home" forKey:@"module"];
    [dict setObject:txtNotes.text forKey:@"note"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[[[responseObject valueForKey:@"result"] valueForKey:@"Strategies"] objectAtIndex:0] isEqualToString:@"Successfully"]){
                responseObject= [Utility cleanJsonToObject:responseObject];
                [Utility showAlertWithwithMessage:@"Client Notes Added Successfully"];
                [tblView reloadData];
                [self cancelNotes:nil];
            }
            STOPLOADING()
        }else{
            STOPLOADING()
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

- (IBAction)cancelNotes:(id)sender {
    [notesView removeFromSuperview];
    txtNotes=nil;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(IBAction)selectbtnSaveRecord:(UIButton *)btnsender{
    
}

#pragma mark- DROPDOWN OPTIONS

-(void)showDropdownWithOption:(NSMutableArray *)arr WithoptionTitle:(NSString *)title WithTag:(int)tag
{
    viewbg_Popup=[[UIView alloc]initWithFrame:self.view.window.bounds];
    viewbg_Popup.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    Dropobj = [[DropDownListView alloc] initWithTitle:title options:arrDropDownVal xy:CGPointMake(self.view.frame.origin.x+10, self.view.frame.origin.y+10) size:CGSizeMake(300, 300) isMultiple:false];
    Dropobj.accessibilityLabel=title;
    Dropobj.delegate = self;
    Dropobj.arryData=arr;
    [Dropobj showInView:viewbg_Popup animated:YES];
    Dropobj.tag=tag;
    [self.view addSubview:viewbg_Popup];
    
    [viewbg_Popup addSubview:Dropobj];
    [Dropobj SetBackGroundDropDown_R:166.0 G:189.0 B:23.0 alpha:1.0];
    /*----------------Set DropDown backGroundColor-----------------*/
}

#pragma mark- DROPDOWN METHODS

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    
    NSString *selected=[arrDropDownVal objectAtIndex:anIndex];
    
    /*3) save Agent Ranking Records
     ------------------------------------
     _operation = saveAgentRankingRecords
     _session = session id
     agentid = agent id (logined user id)
     clientid = client id
     agentRanking = agent ranking (Activly Engaged, Moderatly Engaged, Signed Contract, Closed, Dead Deal, ny agent, pending client, already in new system, on hold, new sf, active on hold, new) */
    
    
    SHOWLOADING(@"Loading")
    NSMutableDictionary *dictMain=[arrAgent objectAtIndex:Dropobj.tag];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:SAVE_AGENT_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:USER_ID forKey:@"agentid"];
    [dict setObject:[dictMain valueForKey:@"contactid"] forKey:@"clientid"];
    [dict setObject:selected forKey:@"agentRanking"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[[[responseObject valueForKey:@"result"] valueForKey:@"Strategies"] objectAtIndex:0]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                [self getAllAgentRecords];
            }
            STOPLOADING()
        }else{
            STOPLOADING()
            [self getAllAgentRecords];
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        [self getAllAgentRecords];
        
        NSLog(@"%@",error.localizedDescription);
    }];
    [Dropobj fadeOut];
    [viewbg_Popup removeFromSuperview];
    
    if([selected isEqualToString:@"Signed Contract"]){
        [self callDealClosedWithTag:Dropobj.tag WithAgentRanking:selected withButton:nil];
    }
    
    
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    /*----------------Get Selected Value[Multiple selection]-----------------*/
    
}
- (void)DropDownListViewDidCancel{
    [viewbg_Popup removeFromSuperview];
    
}

-(void)callDealClosedWithTag:(int)tag WithAgentRanking:(NSString *)agentRank withButton:(UIButton *)btn
{
    /* operation = saveAgentClientRecords
     _session = session id
     agentid = agent id (logined user id)
     clientid = client id
     checkitem = select any option checked name (initial, Actively, Responsive, Dealed)
     chckvalue = set value 1
     agentRanking = if select agent ranking of Signed Contract at that time only deal closed check box required */
    
    
    SHOWLOADING(@"Loading")
    NSMutableDictionary *dictMain=[arrAgent objectAtIndex:tag];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:SAVE_AGENT_CLIENT_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:USER_ID forKey:@"agentid"];
    if([agentRank isEqualToString:@""]){
        [dict setObject:[dictMain valueForKey:@"contactid"] forKey:@"clientid"];
    }else{
        [dict setObject:[dictMain valueForKey:@"clientid"] forKey:@"clientid"];
    }
    
        //    [dict setObject:@"Home" forKey:@"module"];
    
    if([agentRank isEqualToString:@"Signed Contract"]){
        [dict setObject:@"Dealed" forKey:@"item"];
        [dict setObject:@"1" forKey:@"checkvalue"];
    }else{
        if([btn.titleLabel.text isEqualToString:@"Have made initial contact"]){
            
            [dict setObject:@"initial" forKey:@"checkitem"];
            [dict setObject:@"1" forKey:@"checkvalue"];
            
            
        }
        else if([btn.titleLabel.text isEqualToString:@"Client is actively scheduling"]){
            [dict setObject:@"Actively" forKey:@"checkitem"];
            [dict setObject:@"1" forKey:@"checkvalue"];
            
        }
        else if([btn.titleLabel.text isEqualToString:@"Client is not responsive"]){
            [dict setObject:@"Responsive" forKey:@"checkitem"];
            [dict setObject:@"1" forKey:@"checkvalue"];
            
        }
        else{
            [dict setObject:@"Dealed" forKey:@"checkitem"];
            [dict setObject:@"1" forKey:@"checkvalue"];
            
        }
    }
    
    
    [dict setObject:agentRank forKey:@"agentRanking"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[[[responseObject valueForKey:@"result"] valueForKey:@"Strategies"] objectAtIndex:0]boolValue]==true){
                responseObject= [Utility cleanJsonToObject:responseObject];
                [Utility showAlertWithwithMessage:@"Client Notes Added Successfully"];
                [tblView reloadData];
                [self cancelNotes:nil];
            }
            STOPLOADING()
        }else{
            STOPLOADING()
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
    
    [self getAllAgentRecords];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        [Dropobj fadeOut];
        [viewbg_Popup removeFromSuperview];
        
        
    }
}




-(IBAction)dowloadFile:(UIButton *)sender
{
    
    PdfViewVC *objV=[[PdfViewVC alloc]initWithNibName:@"PdfViewVC" bundle:nil];
    objV.strUrl=sender.accessibilityLabel;
    
    [self.navigationController pushViewController:objV animated:true];
    
}


-(void)CallClientMethod:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *tmpID = button.accessibilityLabel;
    NSDictionary *tmpSelectedBioDictionary;
    
    for (NSDictionary *tmpDic in arrBio) {
        NSString *tmpIDStr =[NSString stringWithFormat:@"%@",[tmpDic valueForKey:@"id"]];
        if ([tmpID isEqualToString:tmpIDStr]) {
            tmpSelectedBioDictionary=[NSDictionary dictionaryWithDictionary:tmpDic];
            break;
        }
    }
    NSString *mobileNumberStr=[NSString stringWithFormat:@"%@",[tmpSelectedBioDictionary valueForKey:@"phone_mobile"]];
    
    if (mobileNumberStr.length==0) {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"" message:@"Invalida number or need to add number to call." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
        return;
    }
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",mobileNumberStr]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
        {
      UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
        }
}
-(IBAction)openEmailComposer:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *tmpID = button.accessibilityLabel;
    NSDictionary *tmpSelectedBioDictionary;
    
    for (NSDictionary *tmpDic in arrBio) {
        NSString *tmpIDStr =[NSString stringWithFormat:@"%@",[tmpDic valueForKey:@"id"]];
        if ([tmpID isEqualToString:tmpIDStr]) {
            tmpSelectedBioDictionary=[NSDictionary dictionaryWithDictionary:tmpDic];
            break;
        }
    }
    NSString *toEmailID=[NSString stringWithFormat:@"%@",[tmpSelectedBioDictionary valueForKey:@"email"]];
    NSString *ccEmailID=[NSString stringWithFormat:@"%@",[tmpSelectedBioDictionary valueForKey:@"cc_email"]];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[toEmailID]];
        [composeViewController setCcRecipients:@[ccEmailID]];
        
            //        [composeViewController setSubject:@"example subject"];
        [self.navigationController presentViewController:composeViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
        //Add an alert in case of failure
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
