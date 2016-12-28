    //
    //  AddAppointment.m
    //  Real Estat
    //
    //  Created by NLS32-MAC on 28/04/16.
    //  Copyright © 2016 . All rights reserved.
    //

#import "EditClientVC.h"
#import "Utility.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "AddAppointment.h"
#import "ClientSearch.h"
#import "DropDownListView.h"
#import "NSObject+SBJSON.h"
#import "UITextView+Placeholder.h"
#import "ClientDetailTableViewCell.h"
@interface EditClientVC ()<kDropDownListViewDelegate,CLIENTSELECT>
{
    DropDownListView * Dropobj;
    
}
@end

@implementation EditClientVC
@synthesize downPicker;
@synthesize dictInfo;
@synthesize isEditable,scrollViewForTbl,btnBgView,saveBtnTapped,isDataEditable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
//    tblDataArray=[[NSMutableArray alloc] initWithArray:@[@{@"Title":@"All About you…",@"Data":@[@""]},@{@"Title":@"Child(ren) and ages :",@"Data":@[@"",@""]},@{@"Title":@"About your work life…",@"Data":@[@"",@"",@"",@""]},@{@"Title":@"Tell us a bit about the house you would love to find!",@"Data":@[@"",@"",@""]},@{@"Title":@"Style of house :",@"Data":@[@"",@"",@"",@"",@""]}]];
    tblDataArray=[[NSMutableArray alloc] init];
    [tblDataArray mutableCopy];
    
    
    saveBtnTapped.layer.cornerRadius=3.0f;
    
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
    
    if(self.isEditable==true){
        btnSave.hidden=true;
    }
    if ([isDataEditable isEqualToString:@"No"]) {
        [btnBgView setHidden:YES];
    }
    [self getAppointmentField];
    
}

-(void)SetScrollContentOffset{
    [_tblView reloadData];
    
    saveDataArray=[[NSMutableArray alloc]init];
    for (NSDictionary *tmpDic in tblDataArray) {
        [saveDataArray addObjectsFromArray:[tmpDic valueForKey:@"Data"]];
    }
   
    if ([[dictResponce valueForKey:@"result"] valueForKey:@"record"]) {
        NSMutableArray *tmpStorageArray=[[NSMutableArray alloc]init];
        
    for (NSDictionary *tmpDataDic in saveDataArray) {
        NSMutableDictionary *dataStoreDic=[[NSMutableDictionary alloc]initWithDictionary:tmpDataDic];
        NSDictionary *dic=[[dictResponce valueForKey:@"result"] valueForKey:@"record"] ;
        NSString *tmpStr=[NSString stringWithFormat:@"%@",[dic valueForKey:[NSString stringWithFormat:@"%@",[tmpDataDic valueForKey:@"Key"]]]];
        [dataStoreDic setValue:tmpStr forKey:@"TextFieldStr"];
        [tmpStorageArray addObject:dataStoreDic];
      }
        
        saveDataArray=[NSMutableArray arrayWithArray:tmpStorageArray];
        [saveDataArray mutableCopy];
    }
    if ([isDataEditable isEqualToString:@"No"]) {
        [btnBgView setHidden:YES];
        [scrollViewForTbl setContentSize:CGSizeMake(self.scrollViewForTbl.frame.size.width, _tblView.contentSize.height)];
        [_tblView setFrame:CGRectMake(_tblView.frame.origin.x, _tblView.frame.origin.y, _tblView.frame.size.width, _tblView.contentSize.height)];
    }else{
        [scrollViewForTbl setContentSize:CGSizeMake(self.scrollViewForTbl.frame.size.width, _tblView.contentSize.height+self.btnBgView.frame.size.height+20)];
        [_tblView setFrame:CGRectMake(_tblView.frame.origin.x, _tblView.frame.origin.y, _tblView.frame.size.width, _tblView.contentSize.height)];
        [btnBgView setFrame:CGRectMake(btnBgView.frame.origin.x, CGRectGetMaxY(_tblView.frame)+10, btnBgView.frame.size.width, btnBgView.frame.size.height)];
    }
    
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
            [self getBookWithData];
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                dictResponce=responseObject;
                NSMutableArray *arrFields=[[[dictResponce valueForKey:@"result"] valueForKey:@"describe"] valueForKey:@"fields"];
                if(arrFields.count >0){
                    [self getClientDetails];
                    
                    NSMutableArray *section1Array=[[NSMutableArray alloc]initWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
                    NSMutableArray *section2Array=[[NSMutableArray alloc]initWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
                    NSMutableArray *section3Array=[[NSMutableArray alloc]initWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
                    NSMutableArray *section4Array=[[NSMutableArray alloc]initWithArray:@[@"",@"",@"",@""]];
                    NSMutableArray *section5Array=[[NSMutableArray alloc]initWithArray:@[@"",@"",@"",@"",@"",@""]];

                    for(NSMutableDictionary *arrDic in arrFields){
                        NSMutableDictionary *tmpDic=[[NSMutableDictionary alloc]init];
                        
                            //Section 1 Data
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"firstname"]){
                            [tmpDic setValue:@"firstname" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];
                            [section1Array replaceObjectAtIndex:0 withObject:tmpDic];
//                            [section1Array addObject:tmpDic];
                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"lastname"]){
                            [tmpDic setValue:@"lastname" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
//                            [section1Array addObject:tmpDic];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section1Array replaceObjectAtIndex:1 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"homephone"]){
                            [tmpDic setValue:@"homephone" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                                // [section1Array addObject:tmpDic];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [tmpDic setValue:@"Phone" forKey:@"KeyboardType"];

                            
                            [section1Array replaceObjectAtIndex:2 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"mobile"]){
                            [tmpDic setValue:@"mobile" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section1Array addObject:tmpDic];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [tmpDic setValue:@"Phone" forKey:@"KeyboardType"];

                            [section1Array replaceObjectAtIndex:3 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"email"]){
                            [tmpDic setValue:@"email" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section1Array addObject:tmpDic];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [tmpDic setValue:@"Email" forKey:@"KeyboardType"];

                            [section1Array replaceObjectAtIndex:4 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_753"]){
                            [tmpDic setValue:@"cf_753" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section1Array addObject:tmpDic];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];

                            [section1Array replaceObjectAtIndex:5 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_941"]){
                            [tmpDic setValue:@"cf_941" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section1Array addObject:tmpDic];
                            [tmpDic setValue:@"Email" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section1Array replaceObjectAtIndex:6 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_943"]){
                            [tmpDic setValue:@"cf_943" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section1Array addObject:tmpDic];
                            [tmpDic setValue:@"Phone" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section1Array replaceObjectAtIndex:7 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_945"]){
                            [tmpDic setValue:@"cf_945" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section1Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section1Array replaceObjectAtIndex:8 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_759"]){
                            [tmpDic setValue:@"cf_759" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section1Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section1Array replaceObjectAtIndex:9 withObject:tmpDic];

                        }
                        
                            //Section 2 data
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_823"]){
                            [tmpDic setValue:@"cf_823" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section2Array addObject:tmpDic];
                            [tmpDic setValue:@"Number" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section2Array replaceObjectAtIndex:0 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_819"]){
                            [tmpDic setValue:@"cf_819" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section2Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section2Array replaceObjectAtIndex:1 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_825"]){
                            [tmpDic setValue:@"cf_825" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section2Array addObject:tmpDic];
                            [tmpDic setValue:@"Number" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section2Array replaceObjectAtIndex:2 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_children_name_second"]){
                            [tmpDic setValue:@"cf_children_name_second" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

//                            [section2Array addObject:tmpDic];
                            [section2Array replaceObjectAtIndex:3 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_children_age_second"]){
                            [tmpDic setValue:@"cf_children_age_second" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section2Array addObject:tmpDic];
                            [tmpDic setValue:@"Number" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section2Array replaceObjectAtIndex:4 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_children_name_third"]){
                            [tmpDic setValue:@"cf_children_name_third" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section2Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section2Array replaceObjectAtIndex:5 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_children_age_third"]){
                            [tmpDic setValue:@"cf_children_age_third" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section2Array addObject:tmpDic];
                            [tmpDic setValue:@"Number" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section2Array replaceObjectAtIndex:6 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_children_name_four"]){
                            [tmpDic setValue:@"cf_children_name_four" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section2Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section2Array replaceObjectAtIndex:7 withObject:tmpDic];

                        }

                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_children_age_four"]){
                            [tmpDic setValue:@"cf_children_age_four" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section2Array addObject:tmpDic];
                            [tmpDic setValue:@"Number" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section2Array replaceObjectAtIndex:8 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_829"]){
                            [tmpDic setValue:@"cf_829" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

//                            [section2Array addObject:tmpDic];
                            [section2Array replaceObjectAtIndex:9 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_831"]){
                            [tmpDic setValue:@"cf_831" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

//                            [section2Array addObject:tmpDic];
                            [section2Array replaceObjectAtIndex:10 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_833"]){
                            [tmpDic setValue:@"cf_833" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

//                            [section2Array addObject:tmpDic];
                            [section2Array replaceObjectAtIndex:11 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_852"]){
                            [tmpDic setValue:@"cf_852" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

//                            [section2Array addObject:tmpDic];
                            [section2Array replaceObjectAtIndex:12 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_856"]){
                            [tmpDic setValue:@"cf_856" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

//                            [section2Array addObject:tmpDic];
                            [section2Array replaceObjectAtIndex:13 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_858"]){
                            [tmpDic setValue:@"cf_858" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

//                            [section2Array addObject:tmpDic];
                            [section2Array replaceObjectAtIndex:14 withObject:tmpDic];

                        }

                        
                            //Section 3 data
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_862"]){
                            [tmpDic setValue:@"cf_862" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section3Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

                            [section3Array replaceObjectAtIndex:0 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_864"]){
                            [tmpDic setValue:@"cf_864" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section3Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

                            [section3Array replaceObjectAtIndex:1 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_866"]){
                            [tmpDic setValue:@"cf_866" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section3Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

                            [section3Array replaceObjectAtIndex:2 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_870"]){
                            [tmpDic setValue:@"cf_870" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

//                            [section3Array addObject:tmpDic];
                            [section3Array replaceObjectAtIndex:3 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_882"]){
                            [tmpDic setValue:@"cf_882" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

//                            [section3Array addObject:tmpDic];
                            [section3Array replaceObjectAtIndex:4 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_884"]){
                            [tmpDic setValue:@"cf_884" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

//                            [section3Array addObject:tmpDic];
                            [section3Array replaceObjectAtIndex:5 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_947"]){
                            [tmpDic setValue:@"cf_947" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

//                            [section3Array addObject:tmpDic];
                            [section3Array replaceObjectAtIndex:6 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_949"]){
                            [tmpDic setValue:@"cf_949" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

//                            [section3Array addObject:tmpDic];
                            [section3Array replaceObjectAtIndex:7 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_951"]){
                            [tmpDic setValue:@"cf_951" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

//                            [section3Array addObject:tmpDic];
                            [section3Array replaceObjectAtIndex:8 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_953"]){
                            [tmpDic setValue:@"cf_953" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

//                            [section3Array addObject:tmpDic];
                            [section3Array replaceObjectAtIndex:9 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_957"]){
                            [tmpDic setValue:@"cf_957" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

//                            [section3Array addObject:tmpDic];
                            [section3Array replaceObjectAtIndex:10 withObject:tmpDic];

                        }
                        
                            //Section 4 Data
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_bedrooms"]){
                            [tmpDic setValue:@"cf_bedrooms" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section4Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section4Array replaceObjectAtIndex:0 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_bathrooms"]){
                            [tmpDic setValue:@"cf_bathrooms" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section4Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section4Array replaceObjectAtIndex:1 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_land"]){
                            [tmpDic setValue:@"cf_land" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section4Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section4Array replaceObjectAtIndex:2 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_proximity_to_town"]){
                            [tmpDic setValue:@"cf_proximity_to_town" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section4Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"No" forKey:@"TextField"];

                            [section4Array replaceObjectAtIndex:3 withObject:tmpDic];

                        }
                        
                            //Section 5 Data
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_pool_or_pool_site"]){
                            [tmpDic setValue:@"cf_pool_or_pool_site" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

//                            [section5Array addObject:tmpDic];
                            [section5Array replaceObjectAtIndex:0 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_house_price"]){
                            [tmpDic setValue:@"cf_house_price" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Number" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

//                            [section5Array addObject:tmpDic];
                            [section5Array replaceObjectAtIndex:1 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_condo_or_townhouse"]){
                            [tmpDic setValue:@"cf_condo_or_townhouse" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section5Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section5Array replaceObjectAtIndex:2 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_house_renovate"]){
                            [tmpDic setValue:@"cf_house_renovate" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section5Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section5Array replaceObjectAtIndex:3 withObject:tmpDic];

                        }
                        
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_house_who_told_about"]){
                            [tmpDic setValue:@"cf_house_who_told_about" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//                            [section5Array addObject:tmpDic];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section5Array replaceObjectAtIndex:4 withObject:tmpDic];

                        }
                        if([[arrDic valueForKey:@"name"]isEqualToString:@"cf_house_additional"]){
                            [tmpDic setValue:@"cf_house_additional" forKey:@"Key"];
                            [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
                            [tmpDic setValue:@"Default" forKey:@"KeyboardType"];
                            [tmpDic setValue:@"Yes" forKey:@"TextField"];

                            [section5Array replaceObjectAtIndex:5 withObject:tmpDic];

//                            [section5Array addObject:tmpDic];
                        }
                    }
                    
                    
                    tblDataArray=[[NSMutableArray alloc] initWithArray:@[@{@"Title":@"All About you…",@"Data":section1Array},@{@"Title":@"Child(ren) and ages :",@"Data":section2Array},@{@"Title":@"About your work life…",@"Data":section3Array},@{@"Title":@"Tell us a bit about the house you would love to find!",@"Data":section4Array},@{@"Title":@"Style of house :",@"Data":section5Array}]];

                    [self SetScrollContentOffset];
                    
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
//-(NSMutableDictionary *)parseData :(NSDictionary *)tmpdic{
//    
//    
//    
//    
//    
//    
//    /*
//    if([[tmpdic valueForKey:@"name"]isEqualToString:@"firstname"]){
//        firstName.accessibilityHint=@"firstname";
//    }
//    
//    if([[tmpdic valueForKey:@"name"]isEqualToString:@"lastname"]){
//        lastname.accessibilityHint=@"lastname";
//    }
//    
//    if([[tmpdic valueForKey:@"label"]isEqualToString:@"Appointment Type"]){
//        txtType.text=[[tmpdic valueForKey:@"type"] valueForKey:@"defaultValue"];
//        arrvalueType=[[tmpdic valueForKey:@"type"] valueForKey:@"picklistValues"];
//    }
//    if([[tmpdic valueForKey:@"name"]isEqualToString:@"salutationtype"]){
//        arrSalute=[[tmpdic valueForKey:@"type"] valueForKey:@"picklistValues"];
//        txtMr.accessibilityHint=@"salutationtype";
//    }
//    if([[tmpdic valueForKey:@"name"]isEqualToString:@"cf_house_price"]){
//        arrPrice=[[tmpdic valueForKey:@"type"] valueForKey:@"picklistValues"];
//        price.accessibilityHint=@"cf_house_price";
//    }
//    
//    if([[tmpdic valueForKey:@"name"]isEqualToString:@"phone"]){
//        officePhone.accessibilityHint=@"phone";
//    }
//    
//    
//    if([[tmpdic valueForKey:@"label"]isEqualToString:@"Organization Name"]){
//        org.accessibilityHint=[tmpdic valueForKey:@"name"];
//    }
//    
//    if([[tmpdic valueForKey:@"label"]isEqualToString:@"Primary Email"]){
//        email.accessibilityHint=[tmpdic valueForKey:@"name"];
//    }
//    if([[tmpdic valueForKey:@"label"]isEqualToString:@"Strategist"]){
//        strategist.accessibilityHint=[tmpdic valueForKey:@"name"];
//    }
//    if([[tmpdic valueForKey:@"label"]isEqualToString:@"Spouse Phone"]){
//        spoucePhone.accessibilityHint=[tmpdic valueForKey:@"name"];
//    }
//    if([[tmpdic valueForKey:@"label"]isEqualToString:@"Client Notes"]){
//        clientNotes.accessibilityHint=[tmpdic valueForKey:@"name"];
//    }
//    if([[tmpdic valueForKey:@"label"]isEqualToString:@"Agent Notes"]){
//        agentNotes.accessibilityHint=[tmpdic valueForKey:@"name"];
//    }
//    if([[tmpdic valueForKey:@"label"]isEqualToString:@"Assigned To"]){
//        assignTo.accessibilityHint=[tmpdic valueForKey:@"name"];
//    }
//    if([[tmpdic valueForKey:@"label"]isEqualToString:@"Price"]){
//        price.accessibilityHint=[tmpdic valueForKey:@"name"];
//    }
//    */
//    return tmpDic;
//}


-(void)getClientDetails{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:FETCH_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    if([self.dictInfo valueForKey:@"id"]){
    [dict setObject:[self.dictInfo valueForKey:@"id"] forKey:@"record"];
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
                    
                    if([arrFields valueForKey:price.accessibilityHint]){
                        
                        price.text=[arrFields valueForKey:price.accessibilityHint];
                    }
                    if([arrFields valueForKey:firstName.accessibilityHint]){
                        
                        firstName.text=[arrFields valueForKey:firstName.accessibilityHint];
                    }
                    if([arrFields valueForKey:lastname.accessibilityHint]){
                        
                        lastname.text=[arrFields valueForKey:lastname.accessibilityHint];
                    }
                    if([arrFields valueForKey:officePhone.accessibilityHint]){
                        
                        officePhone.text=[arrFields valueForKey:officePhone.accessibilityHint];
                    }
                    
                    if([arrFields valueForKey:org.accessibilityHint]){
                        if([[arrFields valueForKey:org.accessibilityHint] isKindOfClass:[NSMutableDictionary class]]){
                            org.text=[[arrFields valueForKey:org.accessibilityHint] valueForKey:@"label"];

                        }
                    }
                    if([arrFields valueForKey:email.accessibilityHint]){
                        
                        email.text=[arrFields valueForKey:email.accessibilityHint];
                    }
                    if([arrFields valueForKey:strategist.accessibilityHint]){
                        if([[arrFields valueForKey:strategist.accessibilityHint] isKindOfClass:[NSMutableDictionary class]]){
                            strategist.text=[[arrFields valueForKey:strategist.accessibilityHint] valueForKey:@"label"];
                            strategist.accessibilityLabel=[[arrFields valueForKey:strategist.accessibilityHint] valueForKey:@"value"];
                        }
                    }
                    if([arrFields valueForKey:spoucePhone.accessibilityHint]){
                        
                        spoucePhone.text=[arrFields valueForKey:spoucePhone.accessibilityHint];
                    }
                    
                    if([arrFields valueForKey:clientNotes.accessibilityHint]){
                        
                        clientNotes.text=[arrFields valueForKey:clientNotes.accessibilityHint];
                    }
                    if([arrFields valueForKey:agentNotes.accessibilityHint]){
                        
                        agentNotes.text=[arrFields valueForKey:agentNotes.accessibilityHint];
                    }
                    
                    if([arrFields valueForKey:assignTo.accessibilityHint]){
                        if([[arrFields valueForKey:assignTo.accessibilityHint] isKindOfClass:[NSMutableDictionary class]]){
                            assignTo.text=[[arrFields valueForKey:assignTo.accessibilityHint] valueForKey:@"label"];
                            assignTo.accessibilityLabel=[[arrFields valueForKey:assignTo.accessibilityHint] valueForKey:@"value"];
                        }
                    }
                    if([arrFields valueForKey:price.accessibilityHint]){
                        
                        price.text=[arrFields valueForKey:price.accessibilityHint];
                    }
                    
                    [self SetScrollContentOffset];
                }

                    //                arrEvent;
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    
    

}

-(void)getBookWithData{
    
    
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
     [dict setObject:clientNotes.text forKey:clientNotes.accessibilityHint];
     [dict setObject:agentNotes.text forKey:agentNotes.accessibilityHint];
     [dict setObject:spoucePhone.text forKey:spoucePhone.accessibilityHint];
     [dict setObject:assignTo.accessibilityLabel forKey:assignTo.accessibilityHint];
     [dict setObject:price.text forKey:price.accessibilityHint];

     */
    
    NSString *organisationStr=@"";
    NSString *agentnoteStr=@"";

    NSMutableArray *arrFields=[[dictResponce valueForKey:@"result"] valueForKey:@"record"] ;
    if(arrFields.count >0){
        if([arrFields valueForKey:org.accessibilityHint]){
            if([[arrFields valueForKey:org.accessibilityHint] isKindOfClass:[NSMutableDictionary class]]){
               organisationStr=[[arrFields valueForKey:org.accessibilityHint] valueForKey:@"label"];
            }
            
        }
        if([arrFields valueForKey:agentNotes.accessibilityHint]){
            agentnoteStr=[arrFields valueForKey:agentNotes.accessibilityHint];
        }
    }

    
    
    if([txtAvailablity.text isEqualToString:@""]){
        [Utility showAlertWithwithMessage:@"Please select availability time"];
        return;
    }
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:txtMr.text forKey:@"salutationtype"];
    [dict setObject:firstName.text forKey:@"firstname"];
    [dict setObject:lastname.text forKey:@"lastname"];
    [dict setObject:officePhone.text forKey:@"phone"];
    
//    [dict setObject:org.text forKey:org.accessibilityHint];
    [dict setObject:organisationStr forKey:org.accessibilityHint];

    [dict setObject:email.text forKey:@"email"];
    [dict setObject:strategist.accessibilityLabel forKey:@"strategist"];
    [dict setObject:clientNotes.text forKey:@"cf_876"];
//    [dict setObject:agentNotes.text forKey:@"cf_880"];
    [dict setObject:agentnoteStr forKey:@"cf_880"];

    [dict setObject:assignTo.accessibilityLabel forKey:@"assigned_user_id"];
    [dict setObject:price.text forKey:@"cf_house_price"];
    
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
/*
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
 */
-(void)textFieldDidEndEditing:(UITextField *)textField{

    
    if ([textField.accessibilityHint isEqualToString:@"email"]) {
        if (textField.text.length>0) {
            BOOL isValid=[Utility isValidateEmail:textField.text];
            if (!isValid) {
                textField.text=@"";
                [textField resignFirstResponder];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
      
    }else if ([textField.accessibilityHint isEqualToString:@"cf_941"]){
        if (textField.text.length>0) {
            BOOL isValid=[Utility isValidateEmail:textField.text];
            if (!isValid) {
                textField.text=@"";

                [textField resignFirstResponder];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
    }
    NSMutableArray *tmpLoopingArray=[[NSMutableArray alloc]initWithArray:saveDataArray];
    [tmpLoopingArray mutableCopy];
    int tmpIndex=0;
    for (NSDictionary *tmpDic in tmpLoopingArray) {
        NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]initWithDictionary:tmpDic];
        NSString *tmpKeyStr=[NSString stringWithFormat:@"%@",[tmpDic valueForKey:@"Key"]];
        
        
        if ([tmpKeyStr isEqualToString:textField.accessibilityHint]) {
            NSLog(@"Key str : %@",tmpKeyStr);
            NSLog(@"accessibilityHint : %@",textField.accessibilityHint);
            [dataDic setValue:textField.text forKey:@"TextFieldStr"];
            [saveDataArray replaceObjectAtIndex:tmpIndex withObject:dataDic];
        }
        
        
        tmpIndex++;
    }

    [textField resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
    NSMutableArray *tmpLoopingArray=[[NSMutableArray alloc]initWithArray:saveDataArray];
    [tmpLoopingArray mutableCopy];
    int tmpIndex=0;
    for (NSDictionary *tmpDic in tmpLoopingArray) {
        NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]initWithDictionary:tmpDic];
        NSString *tmpKeyStr=[NSString stringWithFormat:@"%@",[tmpDic valueForKey:@"Key"]];
        
        if ([tmpKeyStr isEqualToString:textView.accessibilityHint]) {
            
            if ([textView.text isEqualToString:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"TitleLbl"]]]) {
                textView.text = @"";
            }
            
            
//            NSLog(@"Key str : %@",tmpKeyStr);
//            NSLog(@"accessibilityHint : %@",textView.accessibilityHint);
//            [dataDic setValue:textView.text forKey:@"TextFieldStr"];
//            [saveDataArray replaceObjectAtIndex:tmpIndex withObject:dataDic];
        }
        tmpIndex++;
    }
    [textView becomeFirstResponder];

}

//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:@""]) {
//        textView.text = @"placeholder text here...";
//        textView.textColor = [UIColor lightGrayColor]; //optional
//    }
//    [textView resignFirstResponder];
//}
-(void)textViewDidEndEditing:(UITextView *)textView{
        NSMutableArray *tmpLoopingArray=[[NSMutableArray alloc]initWithArray:saveDataArray];
        [tmpLoopingArray mutableCopy];
        int tmpIndex=0;
        for (NSDictionary *tmpDic in tmpLoopingArray) {
            NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]initWithDictionary:tmpDic];
            NSString *tmpKeyStr=[NSString stringWithFormat:@"%@",[tmpDic valueForKey:@"Key"]];
            
            if ([tmpKeyStr isEqualToString:textView.accessibilityHint]) {
                NSLog(@"Key str : %@",tmpKeyStr);
                NSLog(@"accessibilityHint : %@",textView.accessibilityHint);
                [dataDic setValue:textView.text forKey:@"TextFieldStr"];
                [saveDataArray replaceObjectAtIndex:tmpIndex withObject:dataDic];
                if ([textView.text isEqualToString:@""]) {
                    textView.text = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"TitleLbl"]];
                }
            }
            tmpIndex++;
        }
        [textView resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}

-(void)cancelNumberPad
{
    [self.view endEditing:YES];
}
-(void)doneWithNumberPad
{
    [self.view endEditing:YES];

}
#pragma mark - Table view Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tblDataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *tmpDataDic= [[[tblDataArray objectAtIndex:indexPath.section] valueForKey:@"Data"] objectAtIndex:indexPath.row];
    NSString *tmpStr= [tmpDataDic valueForKey:@"TextField"];
    if ([tmpStr isEqualToString:@"Yes"]) {
        return 75;
    }else{
        return 125;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view ;
    /* Create custom view to display section header... */
    UILabel *label;
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 38)];
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 38)];
    label.numberOfLines=0;
    label.text=[NSString stringWithFormat:@"%@",[[tblDataArray objectAtIndex:section] valueForKey:@"Title"]];
    [label setFont:[UIFont fontWithName:FONT_REGULAR size:17]];
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentLeft;
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    NSLog(@"%@",[[tblDataArray objectAtIndex:section] valueForKey:@"Data"]);
    
//    int tmpCount=(int)[[[tblDataArray objectAtIndex:section] valueForKey:@"Data"] count];
    return [[[tblDataArray objectAtIndex:section] valueForKey:@"Data"] count];
//    if(section == 0){
//        return  materialTblArray.count;
//    }else if(section == 1){
//        return toolTblArray.count;
//    }else {
//        return otherInvoicesTblArray.count;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        ClientDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClientDetailTableViewCell"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ClientDetailTableViewCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
    NSDictionary *tmpDataDic= [[[tblDataArray objectAtIndex:indexPath.section] valueForKey:@"Data"] objectAtIndex:indexPath.row];
    
    if ([[tmpDataDic valueForKey:@"KeyboardType"] isEqualToString:@"Number"]) {
        cell.inputTxtFld.keyboardType=UIKeyboardTypeNumberPad;
    }else if ([[tmpDataDic valueForKey:@"KeyboardType"] isEqualToString:@"Email"]) {
        cell.inputTxtFld.keyboardType=UIKeyboardTypeEmailAddress;

    }else if ([[tmpDataDic valueForKey:@"KeyboardType"] isEqualToString:@"Phone"]) {
        cell.inputTxtFld.keyboardType=UIKeyboardTypePhonePad;
    }else{
        cell.inputTxtFld.keyboardType=UIKeyboardTypeDefault;
    }
        cell.titleTbl.text=[NSString stringWithFormat:@"%@",[tmpDataDic valueForKey:@"TitleLbl"]];
        cell.inputTxtFld.placeholder=[NSString stringWithFormat:@"%@",[tmpDataDic valueForKey:@"TitleLbl"]];
        cell.inputTxtFld.accessibilityHint=[NSString stringWithFormat:@"%@",[tmpDataDic valueForKey:@"Key"]];
    cell.textView.accessibilityHint=[NSString stringWithFormat:@"%@",[tmpDataDic valueForKey:@"Key"]];
    if ([[dictResponce valueForKey:@"result"] valueForKey:@"record"]) {
        NSDictionary *dic=[[dictResponce valueForKey:@"result"] valueForKey:@"record"] ;
        NSString *tmpStr=[NSString stringWithFormat:@"%@",[dic valueForKey:[NSString stringWithFormat:@"%@",[tmpDataDic valueForKey:@"Key"]]]];
        if (tmpStr.length>0) {
            cell.inputTxtFld.text=tmpStr;
            cell.textView.text=tmpStr;
        }else{
            cell.inputTxtFld.text=@"";
//            cell.textView.text=@"";
            cell.textView.text=[NSString stringWithFormat:@"%@",[tmpDataDic valueForKey:@"TitleLbl"]];
            cell.inputTxtFld.placeholder=[NSString stringWithFormat:@"%@",[tmpDataDic valueForKey:@"TitleLbl"]];
        }
    }
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.tintColor=NAVBARCLOLOR;
    numberToolbar.items = [NSArray arrayWithObjects:
//                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    cell.inputTxtFld.inputAccessoryView = numberToolbar;
    
    cell.textView.inputAccessoryView = numberToolbar;

//    if([[arrDic valueForKey:@"label"]isEqualToString:@"cf_house_additional"]){
//        [tmpDic setValue:@"cf_house_additional" forKey:@"Key"];
//        [tmpDic setValue:[NSString stringWithFormat:@"%@",[arrDic valueForKey:@"label"]] forKey:@"TitleLbl"];
//        [section5Array addObject:tmpDic];
//    }
    

    
    if ([isDataEditable isEqualToString:@"No"]) {
        cell.inputTxtFld.userInteractionEnabled=NO;
        cell.textView.userInteractionEnabled=NO;
    }else{
        cell.inputTxtFld.userInteractionEnabled=YES;
        cell.textView.userInteractionEnabled=YES;
    }
    
    NSString *tmpStr= [tmpDataDic valueForKey:@"TextField"];
    if ([tmpStr isEqualToString:@"Yes"]) {
        cell.inputTxtFld.hidden=NO;
        cell.textView.hidden=YES;

    }else{
        cell.inputTxtFld.hidden=YES;
        cell.textView.hidden=NO;
    }
    
        return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



- (IBAction)saveBtnTapped:(id)sender {

//    {
//    Key = "cf_house_price";
//    TextFieldStr = "";
//    TitleLbl = Price;
//    },
    
    NSMutableDictionary *sendDataDic=[[NSMutableDictionary alloc]init];
    for (NSDictionary *dictionary in saveDataArray) {
        [sendDataDic setValue:[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"TextFieldStr"]] forKey:[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Key"]]];
    }
    if ([[dictResponce valueForKey:@"result"] valueForKey:@"record"]) {
        NSDictionary *dataDic=[[dictResponce valueForKey:@"result"] valueForKey:@"record"] ;
        [sendDataDic setValue:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"salutationtype"]] forKey:@"salutationtype"];
        
        [sendDataDic setValue:[NSString stringWithFormat:@"%@",[[dataDic valueForKey:@"strategist"] valueForKey:@"value"]] forKey:@"strategist"];
        [sendDataDic setValue:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"cf_876"]] forKey:@"cf_876"];
        [sendDataDic setValue:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"cf_880"]] forKey:@"cf_880"];

        [sendDataDic setValue:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"cf_943"]] forKey:@"cf_943"];
       
        [sendDataDic setValue:[NSString stringWithFormat:@"%@",[[dataDic valueForKey:@"assigned_user_id"] valueForKey:@"value"]] forKey:@"assigned_user_id"];
            //Organisation name
        [sendDataDic setValue:[NSString stringWithFormat:@"%@",[[dataDic valueForKey:@"account_id"] valueForKey:@"value"]] forKey:@"account_id"];
        

    }
    
  /*
    NSString *organisationStr=@"";
    NSString *agentnoteStr=@"";

    NSMutableArray *arrFields=[[dictResponce valueForKey:@"result"] valueForKey:@"record"] ;
    if(arrFields.count >0){
        if([arrFields valueForKey:org.accessibilityHint]){
            if([[arrFields valueForKey:org.accessibilityHint] isKindOfClass:[NSMutableDictionary class]]){
                organisationStr=[[arrFields valueForKey:org.accessibilityHint] valueForKey:@"label"];
            }
            
        }
        if([arrFields valueForKey:agentNotes.accessibilityHint]){
            agentnoteStr=[arrFields valueForKey:agentNotes.accessibilityHint];
        }
    }
    if([txtAvailablity.text isEqualToString:@""]){
        [Utility showAlertWithwithMessage:@"Please select availability time"];
        return;
    }
   NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:txtMr.text forKey:@"salutationtype"];
    [dict setObject:firstName.text forKey:@"firstname"];
    [dict setObject:lastname.text forKey:@"lastname"];
    [dict setObject:officePhone.text forKey:@"phone"];
        //    [dict setObject:org.text forKey:org.accessibilityHint];
    [dict setObject:organisationStr forKey:org.accessibilityHint];
    [dict setObject:email.text forKey:@"email"];
    [dict setObject:strategist.accessibilityLabel forKey:@"strategist"];
    [dict setObject:clientNotes.text forKey:@"cf_876"];
        //    [dict setObject:agentNotes.text forKey:@"cf_880"];
    [dict setObject:agentnoteStr forKey:@"cf_880"];
    [dict setObject:spoucePhone.text forKey:@"cf_943"];
    [dict setObject:assignTo.accessibilityLabel forKey:@"assigned_user_id"];
    [dict setObject:price.text forKey:@"cf_house_price"];
  */
    
    
//    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:sendDataDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    

    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *dictPost=[[NSMutableDictionary alloc]init];
    [dictPost setObject:ADD_APPT_RECORD forKey:OPERATION];
    [dictPost setObject:TOKEN forKey:@"session"];
    [dictPost setObject:@"Contacts" forKey:@"module"];
        // [dictPost setObject:dict forKey:@"values"];
  [dictPost setObject:sendDataDic forKey:@"values"];

    
    
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

- (IBAction)canBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
