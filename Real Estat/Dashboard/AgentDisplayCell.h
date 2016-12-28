//
//  AgentDisplayCell.h
//  Real Estat
//
//  Created by NLS32-MAC on 11/05/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface AgentDisplayCell : UITableViewCell

@property (strong, nonatomic) IBOutlet AsyncImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *name_usr;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *mail;
@property (strong, nonatomic) IBOutlet UIButton *btnHavemade;
@property (strong, nonatomic) IBOutlet UIButton *btnClientScheduling;
@property (strong, nonatomic) IBOutlet UIButton *btnNotRespomsive;
@property (strong, nonatomic) IBOutlet UIButton *btnSchedule;
@property (strong, nonatomic) IBOutlet UIButton *btnNotes;
@property (strong, nonatomic) IBOutlet UIButton *btnChooseRank;
@property (strong, nonatomic) IBOutlet UIButton *btnProfile;
@property (strong, nonatomic) IBOutlet UIButton *selectOption;
@property (strong, nonatomic) IBOutlet UIButton *dealClose;

@property (strong, nonatomic) IBOutlet UIButton *btnSaveRecord;

@end
