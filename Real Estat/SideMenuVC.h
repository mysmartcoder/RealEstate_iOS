//
//  SideMenuVC.h
//  RojMel
//
//  Created by NLS32-MAC on 27/07/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblView;
    
}
@end
