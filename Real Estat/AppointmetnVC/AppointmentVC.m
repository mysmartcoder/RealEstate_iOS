//
//  AppointmentVC.m
//  Real Estat
//
//  Created by NLS32-MAC on 21/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import "AppointmentVC.h"
#import "Utility.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "AddAppointment.h"
#import "AppointmentDetailVC.h"

@interface AppointmentVC (PrivateMethods)
@property (readonly) MAEvent *event;
@property (readonly) MAEventKitDataSource *eventKitDataSource;
@end


@implementation AppointmentVC
@synthesize calendar;

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utility setNavigationBar:self.navigationController];
    self.edgesForExtendedLayout=0;
//    self.title=@"Appointment";
    [self.navigationItem setTitleView:segment];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAppointmentButton)]];
    bg_weekView.hidden=true;
    
    
    [self performSelector:@selector(getAllCurrentMonthEvent) withObject:nil afterDelay:0.2 ];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addAppointmentButton
{
    [self.navigationController pushViewController:[[AddAppointment alloc]initWithNibName:@"AddAppointment" bundle:nil] animated:true];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark- Calender type change method
- (IBAction)changeCalType:(id)sender {
    if(segment.selectedSegmentIndex==0){
    FSCalendarScope selectedScope = FSCalendarScopeMonth;
        //    FSCalendarScopeWeek;
    [calendar setScope:selectedScope animated:true];
        bg_weekView.hidden=true;
        monthView.hidden=false;
        bg_dayView.hidden=true;
    }
    
    if(segment.selectedSegmentIndex==1){
        bg_weekView.hidden=false;
        monthView.hidden=true;
        bg_dayView.hidden=true;
        [self getEventForDateFrom:weekView.week];
    }
    if(segment.selectedSegmentIndex==2){
        bg_weekView.hidden=false;
        monthView.hidden=true;
        bg_dayView.hidden=false;
        
    
    /* The default is not to autoscroll, so let's override the default here */
    dayView.autoScrollToFirstEvent = YES;
    }
}



- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
//    calendarHeightConstraint.constant = CGRectGetHeight(bounds);
    [self.view layoutIfNeeded];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"did select date %@",[calendar stringFromDate:date format:@"yyyy/MM/dd"]);
    [arrAllEventData removeAllObjects];
    
    for(int i=0;i<arrEventData.count;i++){
        NSMutableDictionary *dict=[arrEventData objectAtIndex:i];
        if([[dict valueForKey:@"eventstartdate"]isEqualToString:[self.calendar stringFromDate:date format:@"yyyy-MM-dd"]]){
            [arrAllEventData addObject:dict];
            
        }
    }
    [tblEvents reloadData];
    

//    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
//    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [selectedDates addObject:[calendar stringFromDate:date format:@"yyyy/MM/dd"]];
//    }];
//    NSLog(@"selected dates is %@",selectedDates);

    
    
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
}
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date;
{
    NSInteger eventCount=0;
    for(int i=0;i<arrEventData.count;i++){
        NSMutableDictionary *dict=[arrEventData objectAtIndex:i];
        if([[dict valueForKey:@"eventstartdate"]isEqualToString:[calendar stringFromDate:date format:@"yyyy-MM-dd"]]){
            eventCount++;
            break;
        }
    }
    
    return eventCount;
}

#pragma mark- WEEK VIEW METHODS
#ifdef USE_EVENTKIT_DATA_SOURCE






- (NSArray *)weekView:(MAWeekView *)weekView eventsForDate:(NSDate *)startDate {
    return [self.eventKitDataSource weekView:weekView eventsForDate:startDate];
}

#else
- (void)weekView:(MAWeekView *)weekView weekDidChange:(NSDate *)week;
{
    [self getEventForDateFrom:week];
    
}
static int counter = 7 * 5;

- (NSArray *)weekView:(MAWeekView *)weekView eventsForDate:(NSDate *)startDate {
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for(int i=0;i<arrWeekEvent.count;i++){
        NSMutableDictionary *dic=[arrWeekEvent objectAtIndex:i];
        
        NSString *eveSt=[self.calendar stringFromDate:startDate format:@"yyyy-MM-dd"];;
        if([eveSt isEqualToString:[dic valueForKey:@"eventstartdate"]]){
        MAEvent *event = [[MAEvent alloc] init];
        event.backgroundColor = [UIColor purpleColor] ;
        event.textColor = [UIColor whiteColor];
        event.allDay = NO;
        event.userInfo = dic;
        
        event.title = [dic valueForKey:@"label"];
        
        NSString *dateStart=[NSString stringWithFormat:@"%@ %@",[dic valueForKey:@"eventstartdate"],[dic valueForKey:@"eventstarttime"]];
        NSDate *date=[self.calendar dateFromString:dateStart format:@"yyyy-MM-dd HH:mm:ss"];
        
        
        event.start = date;
        
        event.end =[self.calendar dateFromString:[NSString stringWithFormat:@"%@ %@",[dic valueForKey:@"eventenddate"],[dic valueForKey:@"eventendtime"]] format:@"yyyy-MM-dd HH:mm:ss"] ;
        [arr addObject:event];
        }
    }

    
    return arr;
}

#endif

- (MAEvent *)event {
    static int counter;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:[NSString stringWithFormat:@"number %i", counter++] forKey:@"test"];
    
    MAEvent *event = [[MAEvent alloc] init];
    event.backgroundColor = [UIColor purpleColor];
    event.textColor = [UIColor whiteColor];
    event.allDay = NO;
    event.userInfo = dict;
    return event;
}

- (MAEventKitDataSource *)eventKitDataSource {
    if (!_eventKitDataSource) {
        _eventKitDataSource = [[MAEventKitDataSource alloc] init];
    }
    return _eventKitDataSource;
}

/* Implementation for the MAWeekViewDelegate protocol */

- (void)weekView:(MAWeekView *)weekView eventTapped:(MAEvent *)event {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.start];
    NSString *eventInfo = [NSString stringWithFormat:@"Event tapped: %02i:%02i. Userinfo: %@", [components hour], [components minute], [event.userInfo objectForKey:@"test"]];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:event.title
//                                                    message:eventInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
}

- (void)weekView:(MAWeekView *)weekView eventDragged:(MAEvent *)event {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.start];
    NSString *eventInfo = [NSString stringWithFormat:@"Event dragged to %02i:%02i. Userinfo: %@", [components hour], [components minute], [event.userInfo objectForKey:@"test"]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:event.title
                                                    message:eventInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}




#pragma mark- DAY VIEW DELEGATE
/* Implementation for the MADayViewDataSource protocol */

static NSDate *date = nil;

#ifdef USE_EVENTKIT_DATA_SOURCE

- (NSArray *)dayView:(MADayView *)dayView eventsForDate:(NSDate *)startDate {
    return [self.eventKitDataSource dayView:dayView eventsForDate:startDate];
}

#else
- (NSArray *)dayView:(MADayView *)dayView eventsForDate:(NSDate *)startDate {
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for(int i=0;i<arrEventData.count;i++){
        NSMutableDictionary *dic=[arrEventData objectAtIndex:i];
        
        NSString *eveSt=[self.calendar stringFromDate:startDate format:@"yyyy-MM-dd"];;
        if([eveSt isEqualToString:[dic valueForKey:@"eventstartdate"]]){
            MAEvent *event = [[MAEvent alloc] init];
            event.backgroundColor = [UIColor purpleColor] ;
            event.textColor = [UIColor whiteColor];
            event.allDay = NO;
            event.userInfo = dic;
            
            event.title = [dic valueForKey:@"label"];
            
            NSString *dateStart=[NSString stringWithFormat:@"%@ %@",[dic valueForKey:@"eventstartdate"],[dic valueForKey:@"eventstarttime"]];
            NSDate *date=[self.calendar dateFromString:dateStart format:@"yyyy-MM-dd HH:mm:ss"];
            
            
            event.start = date;
            
            event.end =[self.calendar dateFromString:[NSString stringWithFormat:@"%@ %@",[dic valueForKey:@"eventenddate"],[dic valueForKey:@"eventendtime"]] format:@"yyyy-MM-dd HH:mm:ss"] ;
            [arr addObject:event];
        }
    }
    
    
    return arr;
}
#endif





/* Implementation for the MADayViewDelegate protocol */

- (void)dayView:(MADayView *)dayView eventTapped:(MAEvent *)event {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.start];
    NSString *eventInfo = [NSString stringWithFormat:@"Hour %i. Userinfo: %@", [components hour], [event.userInfo objectForKey:@"test"]];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:event.title
//                                                    message:eventInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
}


#pragma mark - CURRENT MONTH EVENTS
-(void)getAllCurrentMonthEvent
{
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_MODULE_RECORD forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:[[AppDelegate initAppdelegate].dictCurrentoption valueForKey:@"name"] forKey:@"module"];

    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                arrEventData=[[responseObject valueForKey:@"result"] valueForKey:@"records"];
                [self.calendar reloadData];
                arrAllEventData=[[NSMutableArray alloc]initWithArray:arrEventData];
                [tblEvents reloadData];

            }
            
        }else{
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    

}

-(void)getEventForDateFrom:(NSDate *)date
{
//    [calendar stringFromDate:week format:@"yyyy-MM-dd"];

    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *componentsToAdd = [gregorian components:NSDayCalendarUnit fromDate:date];
    [componentsToAdd setDay:6];
    NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToAdd toDate:date options:0];
    
    
    SHOWLOADING(@"Loading")
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:GET_ALL_EVENTS forKey:OPERATION];
    [dict setObject:TOKEN forKey:@"session"];
    [dict setObject:[[AppDelegate initAppdelegate].dictCurrentoption valueForKey:@"name"] forKey:@"module"];
    
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
           [dict setObject:[dateFormatter stringFromDate:date] forKey:@"start_date"];
            [dict setObject:[dateFormatter stringFromDate:endOfWeek] forKey:@"end_date"];
    
    [manager POST:WEBSERVICE_URL parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        STOPLOADING()
        NSLog(@"%@",responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject valueForKey:@"success"]boolValue]==true){
                arrWeekEvent=[[responseObject valueForKey:@"result"] valueForKey:@"records"];
                [weekView reloadData];
//                [tblEvents reloadData];
            }
            
        }else{
            
            [Utility showAlertWithwithMessage:[[responseObject valueForKey:@"error"] valueForKey:@"message"]];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        STOPLOADING()
        NSLog(@"%@",error.localizedDescription);
    }];
    

    
}
#pragma mark-MonthWise calander event Tableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrAllEventData.count;
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:MyIdentifier] ;
    cell.textLabel.text =[[arrAllEventData objectAtIndex:indexPath.row] valueForKey:@"label"];
    NSString *dats1 = [[arrAllEventData objectAtIndex:indexPath.row] valueForKey:@"eventstarttime"];
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init] ;
    [dateFormatter3 setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter3 setDateFormat:@"HH:mm:ss"];
    NSDate *date1 = [dateFormatter3 dateFromString:dats1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *dateStart=[NSString stringWithFormat:@"%@ %@",[[arrAllEventData objectAtIndex:indexPath.row] valueForKey:@"eventstartdate"],[[arrAllEventData objectAtIndex:indexPath.row] valueForKey:@"eventstarttime"]];

//          cell.detailTextLabel.text =[formatter stringFromDate:date1];
    cell.detailTextLabel.text =dateStart;

    cell.textLabel.font=[UIFont fontWithName:FONT_REGULAR size:12.0];
    cell.detailTextLabel.font=[UIFont fontWithName:FONT_REGULAR size:10.0];

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    AppointmentDetailVC *objde=[[AppointmentDetailVC alloc]initWithNibName:@"AppointmentDetailVC" bundle:nil];
    objde.dictData=[arrAllEventData objectAtIndex:indexPath.row] ;
    [self.navigationController pushViewController:objde animated:true];
    
    
}
@end
