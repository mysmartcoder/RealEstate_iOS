//
//  LoginVC.m
//  Real Estat
//
//  Created by NLS32-MAC on 21/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import "LoginVC.h"
#import "Utility.h"
#import "Static.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ForgotPassword.h"

@interface LoginVC () <MFMailComposeViewControllerDelegate>

@end

@implementation LoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [usrName setValue:[UIColor darkGrayColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    [password setValue:[UIColor darkGrayColor]
           forKeyPath:@"_placeholderLabel.textColor"];
//   usrName.text=@"[feedback_email]";
//  password.text=@"Jungle1";
//    usrName.text=@"priyanka.patel@varianceinfotech.com";
//  password.text=@"Jungle1";
//   usrName.text=@"rahulg.variance@gmail.com";
//  password.text=@"admin";
//  usrName.text=@"linda.longo@gmail.com";//testing
//  password.text=@"Jungle1";
//    usrName.text=@"chirag";
//    password.text=@"chirag";
//   usrName.text=@"Francie Malina"; // Live Client
//    password.text=@"Jungle1"; // Live Client
//     usrName.text=@"ghanshaym";
//     password.text=@"ghanshaym";
//     usrName.text=@"rahulg.variance@gmail.com";
//     password.text=@"admin";
//
//    usrName.text=@"mrugaya@gmail.com";
//    password.text=@"Jungle1";
    
    /*
     Client
     ----------------
     Username: testingclientross@gmail.com
     Password: skj378.s3,jsk9
     Access Key = luUx6v4zvxkIsRR
     
     rahulg.variance@gmail.com
     admin
     
     Username = ramijhusain.meman@varianceinfotech.com
     Password = Jungle1
     
     Jen Birmingham
     
     initial_Contact('6407','1840','initial')
     
     Role : Client
     --------------
     Username : priyanka.patel@varianceinfotech.com
     Password : Jungle1
     
     client :-
     alkakapoor@gmail.com
     skj378.s3,jsk9
     7778001505
     strategist
     
     Agent Login
     chirag/chirag
    
    ghanshaym/ghanshaym
     
     Role : Client
     --------------
     Username : priyanka.patel@varianceinfotech.com
     Password : Jungle1
     
     Role : Agent
     --------------
     chirag/chirag
     ghanshaym/ghanshaym
     
     Role : Strategies
     -------------------
     [feedback_email]
     Jungle1
     
    */
    
    [btnLogin.layer setCornerRadius:4.0];
    [btnLogin.layer setBorderColor:[UIColor whiteColor].CGColor];
    [btnLogin.layer setBorderWidth:1.0];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)forgotPasswordClicked:(id)sender {
    [self.navigationController pushViewController:[[ForgotPassword alloc]initWithNibName:@"ForgotPassword" bundle:nil] animated:true];
}

- (IBAction)btnLoginClicked:(id)sender {
    
    if([usrName.text isEqualToString:@""]){
        [Utility showAlertWithwithMessage:@"Please enter user name"];
        return;
    }
    if([password.text isEqualToString:@""]){
        [Utility showAlertWithwithMessage:@"Please enter password"];
        return;
    }
     /* 
      operation = login
    username = username
    password = password  */
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:LOGIN forKey:OPERATION];
    [dict setObject:usrName.text forKey:@"username"];
    [dict setObject:password.text forKey:@"password"];
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                NSMutableDictionary *dictlog=[[responseObject valueForKey:@"result"] valueForKey:@"login"];
                [[NSUserDefaults standardUserDefaults]setObject:[dictlog valueForKey:@"session"] forKey:KEY_TOKEN];
                [[NSUserDefaults standardUserDefaults]setObject:[dictlog valueForKey:@"userid"] forKey:KEY_USER_ID];
                
                NSMutableArray *arr=[[responseObject valueForKey:@"result"] valueForKey:@"modules"];
                [[NSUserDefaults standardUserDefaults]setObject:arr forKey:KEY_SIDEMENU];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self getUserIdendity];
                
            }else{
                STOPLOADING()

                [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
     
     }

- (IBAction)logMail:(id)sender {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if ([mailClass canSendMail])
        {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setSubject:@"Crash log file"];
        [picker setToRecipients:@[@"kalpit.gajera@nexuslinkservices.in" ]];

        NSFileManager* manager = [[NSFileManager alloc] init];
        
        
        NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [allPaths objectAtIndex:0];
        NSString *NoteFilePath = [documentsDirectory stringByAppendingPathComponent:@"logFile.txt"];
        
        
            NSData *myNoteData = [NSData dataWithContentsOfFile:NoteFilePath];
            [picker addAttachmentData:myNoteData mimeType:@"text/plain" fileName:@"logFile.txt"];
        
        
        
        
            // Fill out the email body text
        NSString *emailBody = @"Log File!";
        [picker setMessageBody:emailBody isHTML:NO];
        
        [self.navigationController presentModalViewController:picker animated:YES];
        
        
        }
}

- (IBAction)btnGettingStarted:(id)sender {
    [[UIApplication sharedApplication] openURL:[[NSURL alloc]initWithString:@"[home_url]"]];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:true completion:nil];
    }

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

-(void)getUserIdendity
{
   /* User Rolename
    -------------
    URL : [api_url]
    Parameter Pass
    ------------------
    _operation = detailRecords
    _session = session (from Login)
    roleid = 1 */
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_USER_DETAIL forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:@"1" forKey:@"roleid"];
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                NSMutableDictionary *dictlog=[responseObject valueForKey:@"result"] ;
                [[NSUserDefaults standardUserDefaults]setObject:[dictlog valueForKey:@"rolename"] forKey:KEY_ROLE];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[AppDelegate initAppdelegate]setDashBoard];

            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    

}


@end
