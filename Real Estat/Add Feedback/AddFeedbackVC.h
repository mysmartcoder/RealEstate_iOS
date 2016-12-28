//
//  AddFeedbackVC.h
//  Real Estat
//
//  Created by NLS42-MAC on 29/06/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
@interface AddFeedbackVC : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *townLike;
    IBOutlet UITextField *additional;
    IBOutlet UITextField *compare;
    IBOutlet UITextField *concern;
    IBOutlet UITextField *townRank;
    IBOutlet UITextField *town;
    IBOutlet UITextField *rate;
    IBOutlet UIScrollView *scrollview;
    NSMutableArray *arrWith,*ArrAlClient;
    IBOutlet UITextField *agent;
    IBOutlet RateView *rateView;
    
}

@property (strong,nonatomic)NSString *assigned_user_id;
@property (strong,nonatomic)NSString *agentName;

@property (strong,nonatomic)NSString *town_str;
- (IBAction)saveFeedback:(id)sender;
@end
