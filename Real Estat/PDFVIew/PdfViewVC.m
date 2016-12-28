//
//  PdfViewVC.m
//  Real Estat
//
//  Created by NLS32-MAC on 06/05/16.
//  Copyright © 2016 . All rights reserved.
//

#import "PdfViewVC.h"
#import "AppDelegate.h"
#import "Static.h"
#import "Utility.h"

@interface PdfViewVC ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PdfViewVC
@synthesize strUrl;
@synthesize webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utility setNavigationBar:self.navigationController];
    self.title=@"Document Detail";
    // Do any additional setup after loading the view from its nib.
    NSURL *myUrl = [NSURL URLWithString:self.strUrl];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl];
    
    [webView loadRequest:myRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    SHOWLOADING(@"Loading");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    STOPLOADING()
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    STOPLOADING()
}
/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
