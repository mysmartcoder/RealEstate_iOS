//
//  AppointmentDetailVC.h
//  Real Estat
//
//  Created by NLS42-MAC on 07/06/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentDetailVC : UIViewController
{
    
    IBOutlet UITextField *assignTo;
    IBOutlet UITextField *sub;
    IBOutlet UITextField *startdate;
    IBOutlet UITextField *endDate;
    IBOutlet UITextField *actType;
}
@property (strong,nonatomic)NSMutableDictionary *dictData;
@end
