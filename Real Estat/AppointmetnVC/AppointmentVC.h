//
//  AppointmentVC.h
//  Real Estat
//
//  Created by NLS32-MAC on 21/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "MAWeekView.h" // MAWeekViewDataSource,MAWeekViewDelegate
#import "MADayView.h" // MADayViewDataSource,MADayViewDelegate

#import "MAEvent.h"
#import "MAEventKitDataSource.h"
@class MAEventKitDataSource;


@interface AppointmentVC : UIViewController<
FSCalendarDataSource, FSCalendarDelegate,MAWeekViewDataSource,MAWeekViewDelegate,MADayViewDataSource,MADayViewDelegate>
{
    IBOutlet UIView *bg_dayView;
    
    IBOutlet MADayView *dayView;
    IBOutlet UIView *bg_weekView;
    IBOutlet UIView *monthView;
    IBOutlet UISegmentedControl *segment;
    MAEventKitDataSource *_eventKitDataSource;

    IBOutlet UITableView *tblEvents;
    IBOutlet MAWeekView *weekView;
    NSMutableArray *arrEventData,*arrWeekEvent,*arrDayData;
    NSMutableArray *arrAllEventData;
}
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;

@end
