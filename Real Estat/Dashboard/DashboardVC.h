//
//  DashboardVC.h
//  Real Estat
//
//  Created by NLS32-MAC on 25/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIDocumentInteractionControllerDelegate>
{
    IBOutlet UITableView *tblView;
    
        //Strategist
    NSMutableArray *arrHistory,*arrFollowUpdata,*arrInfo;
    
        // Client
    NSMutableArray *arrEvent,*arrBio,*arrStrategist,*arrFeedback;
    
        //AGENT
    NSMutableArray *arrAgent;
    NSMutableArray *arrDropDownVal;
    IBOutlet UIView *notesView;
    IBOutlet UITextView *txtNotes;
    IBOutlet UIView *headerView;
}
@property (strong,nonatomic)UIDocumentInteractionController *documentInteractionController;

- (IBAction)saveNotes:(id)sender;
- (IBAction)cancelNotes:(id)sender;
@end
