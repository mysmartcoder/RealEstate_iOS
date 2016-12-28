//
//  FollowupDateVC.h
//  Real Estat
//
//  Created by NLS32-MAC on 25/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientsVC : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet UILabel *lblNorecord;
    IBOutlet UITableView *tblView;
    NSMutableArray *arrFollowUpdata;
    NSArray *searchResults;

}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarFortbl;
@property (assign,nonatomic)BOOL isStrategist;
@end
