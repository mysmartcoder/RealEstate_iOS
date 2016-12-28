//
//  FollowupDateVC.h
//  Real Estat
//
//  Created by NLS32-MAC on 25/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowupDateVC : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet UILabel *lblNoData;
    IBOutlet UITableView *tblView;
    NSMutableArray *arrFollowUpdata;
}

@end
