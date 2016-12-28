//
//  StrategistEditVC.h
//  Real Estat
//
//  Created by NLS32-MAC on 04/05/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StrategistEditVC : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *dictResponce;

    IBOutlet UIScrollView *scrollview;
    IBOutlet UITextField *assignedClient;
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *suburb;
    IBOutlet UITextField *agent;
    IBOutlet UITextView *txtNotes;
    
    IBOutlet UIButton *btnEdit;
    NSMutableArray *arrSuburb;
    UIView *viewbg_Popup;
    UITextField *current;
    NSMutableArray *arrWith;
    NSMutableArray *ArrAlClient;
    NSMutableArray *arrAgent;
    NSMutableArray *arrDocuments;

    IBOutlet UITableView *tblDoc;
}
@property (strong,nonatomic)NSMutableDictionary *dictInfo;

@end
