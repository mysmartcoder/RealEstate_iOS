//
//  ClientDetailTableViewCell.m
//  Real Estat
//
//  Created by NLS42-MAC on 01/09/16.
//  Copyright © 2016 . All rights reserved.
//

#import "ClientDetailTableViewCell.h"

@implementation ClientDetailTableViewCell
@synthesize titleTbl,inputTxtFld,textView;
- (void)awakeFromNib {
    [super awakeFromNib];
    inputTxtFld.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    inputTxtFld.layer.borderWidth=0.7f;
    inputTxtFld.layer.borderColor=[UIColor lightGrayColor].CGColor;
    inputTxtFld.layer.cornerRadius=3.0f;
    inputTxtFld.backgroundColor=[UIColor colorWithWhite:0.949 alpha:1.000];
    inputTxtFld.textColor=[UIColor grayColor];
    inputTxtFld.autocorrectionType=UITextAutocorrectionTypeNo;
    
    textView.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    textView.layer.borderWidth=1.0f;
    textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    textView.layer.cornerRadius=3.0f;
    textView.backgroundColor=[UIColor colorWithWhite:0.949 alpha:1.000];
    textView.textColor=[UIColor grayColor];
    textView.autocorrectionType=UITextAutocorrectionTypeNo;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
