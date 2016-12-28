//
//  AgentDisplayCell.m
//  Real Estat
//
//  Created by NLS32-MAC on 11/05/16.
//  Copyright © 2016 . All rights reserved.
//

#import "AgentDisplayCell.h"

@implementation AgentDisplayCell
@synthesize userImage,name_usr,city,mail,btnHavemade,btnClientScheduling,btnNotRespomsive,btnSchedule,btnChooseRank,btnProfile,selectOption,dealClose,btnNotes,btnSaveRecord;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.selectOption.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [self.selectOption.layer setBorderWidth:1.0];
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
   
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

- (IBAction)btnSelectoption:(id)sender {
}
@end
