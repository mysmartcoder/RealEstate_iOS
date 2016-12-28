//
//  LoginVC.h
//  Real Estat
//
//  Created by NLS32-MAC on 21/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
@interface ForgotPassword : UIViewController <UITextFieldDelegate>
{
    
    IBOutlet UITextField *usrName;
    IBOutlet UITextField *password;
    IBOutlet UIButton *btnLogin;
    NSMutableArray *arrDropDownOption;
}
- (IBAction)forgotPasswordClicked:(id)sender;
- (IBAction)btnLoginClicked:(id)sender;
- (IBAction)logMail:(id)sender;
@end
