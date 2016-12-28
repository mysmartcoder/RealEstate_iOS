//
//  AppDelegate.h
//  Real Estat
//
//  Created by NLS32-MAC on 21/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"


#define SHOWLOADING(strText) [(AppDelegate *)[[UIApplication sharedApplication]delegate]performSelectorOnMainThread:@selector(showCustomProgressViewWithText:) withObject:strText waitUntilDone:NO];
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define STOPLOADING() [(AppDelegate *)[[UIApplication sharedApplication]delegate]performSelector:@selector(hideCustomProgressView) withObject:nil afterDelay:0.5];


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIView *lightBoxView,*progressView;

}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JASidePanelController *viewController;
@property (strong,nonatomic)NSMutableDictionary *dictCurrentoption,*objDictTown;

+(AppDelegate *)initAppdelegate;
-(void)showCustomProgressViewWithText:(NSString *)strText;
-(void)hideCustomProgressView;
-(void)setRightPanel:(NSMutableDictionary *)dictOption;
-(void)setDashBoard;
-(void)setLoginView;


@end

