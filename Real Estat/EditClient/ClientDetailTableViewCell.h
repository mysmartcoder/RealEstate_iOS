//
//  ClientDetailTableViewCell.h
//  Real Estat
//
//  Created by NLS42-MAC on 01/09/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleTbl;

@property (strong, nonatomic) IBOutlet UITextField *inputTxtFld;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@end
