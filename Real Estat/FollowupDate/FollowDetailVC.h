//
//  FollowDetailVC.h
//  Real Estat
//
//  Created by NLS42-MAC on 31/05/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"

@interface FollowDetailVC : UIViewController
{
    
    IBOutlet UITextField *assignTo;
    IBOutlet UITextField *dateOfCall;
}
@property (strong,nonatomic)NSMutableDictionary *dict;
@end
