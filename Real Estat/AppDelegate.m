//
//  AppDelegate.m
//  Real Estat
//
//  Created by NLS32-MAC on 21/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import "AppDelegate.h"
#import "Static.h"
#import "LoginVC.h"
#import "SideMenuVC.h"
#import "AppointmentVC.h"
#import "Utility.h"
#import "NYAlertViewController.h"
#import "DashboardVC.h"
#import "FollowupDateVC.h"
#import "ClientsVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize dictCurrentoption,objDictTown;
+(AppDelegate *)initAppdelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#ifdef DEBUG_MODE
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [allPaths objectAtIndex:0];
    NSString *pathForLog = [documentsDirectory stringByAppendingPathComponent:@"logFile.txt"];
    
    freopen([pathForLog cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);

    
    [self setLoginView];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)setLoginView
{
    UINavigationController *navVc=[[UINavigationController alloc]initWithRootViewController:[ [LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil]];
    navVc.navigationBarHidden=true;
    
    self.window.rootViewController=navVc;
}
-(void)setDashBoard
{
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.viewController.leftPanel =    [[UINavigationController alloc] initWithRootViewController:[[SideMenuVC alloc] initWithNibName:@"SideMenuVC" bundle:nil]];
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[DashboardVC alloc]initWithNibName:@"DashboardVC" bundle:nil]];
    [Utility setNavigationBar:self.viewController.navigationController];
    self.viewController.rightPanel =nil;
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark- SIDE VIEW METHOD
-(void)setRightPanel:(NSMutableDictionary *)dictOption
{
    dictCurrentoption=dictOption;
    
    if([[dictOption valueForKey:@"name"]isEqualToString:@"Dashboard"]){
        self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[DashboardVC alloc]initWithNibName:@"DashboardVC" bundle:nil]];
    }
    if([[dictOption valueForKey:@"name"]isEqualToString:@"Calendar"]){
    
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[AppointmentVC alloc]initWithNibName:@"AppointmentVC" bundle:nil]];
    }
    if([[dictOption valueForKey:@"label"]isEqualToString:@"Clients"] || [[dictOption valueForKey:@"label"]isEqualToString:@"Strategies"] || [[dictOption valueForKey:@"label"]isEqualToString:@"Town Feedback"]){

        self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[ClientsVC alloc]initWithNibName:@"ClientsVC" bundle:nil]];
    }
       if([[dictOption valueForKey:@"label"]isEqualToString:@"Follow Up Date"]){
                    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[FollowupDateVC alloc]initWithNibName:@"FollowupDateVC" bundle:nil]];
        
                }
    
//
//    if(tag==0){
//        self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[DashboardVC alloc]initWithNibName:@"DashboardVC" bundle:nil]];
//        
//    }
//    if(tag==4){
//        self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[FollowupDateVC alloc]initWithNibName:@"FollowupDateVC" bundle:nil]];
//        
//    }
 
   }

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);  // after animation
{
    if(buttonIndex==alertView.cancelButtonIndex){
        return;
    }
}


#pragma mark -
#pragma mark Custom Process View


-(void)showCustomProgressViewWithText:(NSString *)strText{
    
    CGRect frame;
    if (!lightBoxView) {
        lightBoxView = [[UIView alloc ]init];
        if(IS_IPAD==TRUE){
            [lightBoxView setFrame:CGRectMake(0, 0, WIDTH,HEIGHT)];
            frame = CGRectMake( (WIDTH/2-60) ,(HEIGHT/2-60),120,120);
        }
        else{
            [lightBoxView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            frame = CGRectMake( (WIDTH/2)-60 ,(HEIGHT/2)-60 ,120,120);
        }
        [lightBoxView setAlpha:0.6];
        [lightBoxView setBackgroundColor:[UIColor blackColor]];
        progressView=[[UIView alloc]initWithFrame:frame];
        [progressView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
        [progressView setUserInteractionEnabled:FALSE];
        [progressView.layer setBorderColor:NAVBARCLOLOR.CGColor];
        [progressView.layer setBorderWidth:1.0];
        [progressView.layer setCornerRadius:10];
        UILabel *lblLoading=[[UILabel alloc]initWithFrame:CGRectMake(10, 65, 100, 40)];
        [lblLoading setText:strText];
        [lblLoading setBackgroundColor:[UIColor clearColor]];
        [lblLoading setFont:[UIFont fontWithName:FONT_REGULAR size:12.0]];
        [lblLoading setTextColor:[UIColor whiteColor]];
        [lblLoading setTextAlignment:NSTextAlignmentCenter];
        [progressView addSubview:lblLoading];
        UIActivityIndicatorView *activityIndicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView setCenter:CGPointMake(60,50)];
        
        [activityIndicatorView startAnimating];
        [progressView addSubview:activityIndicatorView];
        [progressView setFrame:frame];
        [self.window.rootViewController.view setUserInteractionEnabled:TRUE];
        
    }
    [self.window addSubview:lightBoxView];
    [self.window addSubview:progressView];
}
-(void)hideCustomProgressView
{
    [progressView removeFromSuperview];
    [lightBoxView removeFromSuperview];
    lightBoxView=nil;
    progressView=nil;
}


@end

@implementation UITextField (custom)


- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,
                      bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end


