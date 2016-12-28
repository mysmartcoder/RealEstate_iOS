                  //
//  Utility.m
//  Kinderopvang
//
//  Created by NLS17 on 18/07/14.
//  Copyright (c) 2014 NexusLinkServices. All rights reserved.
//

#import "Utility.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "NYAlertViewController.h"
@implementation Utility
+(void)setNavigationBar:(UINavigationController *)navController
{
    
    [navController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,
      [UIFont fontWithName:FONT_LIGHT size:20],
      NSFontAttributeName, nil]];
    navController.navigationBar.translucent=NO;
    [navController.navigationBar setTintColor:[UIColor whiteColor]];
    navController.navigationBar.barTintColor=NAVBARCLOLOR;
         // navController.navigationBar.shadowImage=[[UIImage alloc] init];
    //[navController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //navController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    float shadowOffset = 1;
    
        // Make sure that the offset doesn't exceed 3 or drop below 0.5
    shadowOffset = MIN(MAX(shadowOffset, 0), 0.5);
    
        //Ensure that the shadow radius is between 1 and 3
    float shadowRadius = MIN(MAX(shadowOffset, 0), 0);
    
        //apply the offset and radius
    navController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0.5);
    navController.navigationBar.layer.shadowRadius = shadowRadius;
    navController.navigationBar.layer.shadowColor = [UIColor whiteColor].CGColor;
    navController.navigationBar.layer.shadowOpacity = 1.0;



}

+(UIView *)setStatusOfWorkWithColor:(UIColor *)color
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    [view.layer setBorderWidth:1.0];
    [view.layer setBorderColor:NAVBARCLOLOR.CGColor];
    [view.layer setCornerRadius:8.0];
    view.layer.masksToBounds=true;
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(2, 2, 12, 12)];
    [lbl.layer setCornerRadius:6.0];
    lbl.layer.masksToBounds=true;
    [lbl
     setBackgroundColor:color];
    [view addSubview:lbl];
    return view;
    
}




+ (UIImage *)imageWithColor:(NSString *)colorcode {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[self getColor:colorcode] CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message
{
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
}

+(void)showAlertWithwithMessage:(NSString *)message;
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = @"Real Estat";
    alertViewController.message = message;
    
    
    alertViewController.titleFont = [UIFont fontWithName:FONT_REGULAR size:16.0];
    alertViewController.messageFont = [UIFont fontWithName:FONT_REGULAR size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:FONT_REGULAR size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:FONT_REGULAR size:alertViewController.cancelButtonTitleFont.pointSize];
    
    alertViewController.alertViewBackgroundColor = [UIColor whiteColor];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = GREEN_THEMECOLOR;
    alertViewController.messageColor = [UIColor darkGrayColor
                                        ];
    
    alertViewController.buttonColor = NAVBARCLOLOR;
    alertViewController.buttonTitleColor = [UIColor whiteColor];
    
    alertViewController.cancelButtonColor = NAVBARCLOLOR;
    alertViewController.cancelButtonTitleColor = [UIColor whiteColor];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              [alertViewController dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertViewController animated:YES completion:nil];
    
}

+(UIColor*)getColor:(NSString*)colorcode
{
    NSString *cString = [[colorcode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(UIImage *)getBackgroundImage{
   if(IS_IPHONE){
   if(HEIGHT < 500) return [UIImage imageNamed:@"Default@2x"];
   else if(HEIGHT >600) return [UIImage imageNamed:@"Default@3x.png"];
   else return [UIImage imageNamed:@"Default-568h@2x.png"];
    }else
        return [UIImage imageNamed:@"Default~ipad.png"];
    
}

+(UIImage *)changeImageColorWithColor:(UIColor *)color withImageName:(NSString *)imageName;{
    
    UIImage *image=[UIImage imageNamed:imageName];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage scale:1.0 orientation: UIImageOrientationDownMirrored];
    return flippedImage;
}


+(UIImage *)changeImageColorWithColor:(UIColor *)color withImage:(UIImage *)image;{
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage scale:1.0 orientation: UIImageOrientationDownMirrored];
    return flippedImage;
}


+(BOOL)isValidateEmail:(NSString *)emailId {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailId];
}

+(BOOL)isInternetConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
+(void)showinternetErrorMessage
{
    [Utility showAlertWithTitle:@"error" withMessage:@"internet_msg"];
}

/*+ (void)executeRequestwithServicetype:(NSString *)serviceType withPostString:(NSString *)postString withBlock:(void (^)(NSMutableDictionary *dictresponce,NSError *error))block {
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,serviceType];
   // NSLog(@"url %@  post string %@",urlStr,postString);
    NSURL *url1=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url1];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60.0];
  //  NSString *postLength = [NSString stringWithFormat:@"%d",[postString length]];
    [request setValue:TOKEN forHTTPHeaderField:@"x-auth-token"];
   // [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSError *error1;
                               if(data==nil){
                                  // NSLog(@"Error Responce : %@",error);
                                   block(nil,error);
                               }else{
                                  // NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                   NSMutableDictionary * innerJson = [NSJSONSerialization                                                JSONObjectWithData:data options:kNilOptions error:&error1];
                                   block(innerJson,error); // Call back the block passed into your method
                               }
                           }];
    
}
*/

+ (void)executeGetRequestwithServicetype:(NSString *)serviceType withBlock:(void (^)(NSMutableDictionary *dictresponce,NSError *error))block {
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,serviceType];
    NSLog(@"SERVICE URL CALLED : *************\n \n   %@  \n \n \n*****************",urlStr);
    NSURL *url1=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"SERVICE URL CALLED : *************\n \n   %@  \n \n \n*****************",url1);

    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url1];
    [request setHTTPMethod:@"POST"];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    request = [mutableRequest copy];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if(error){
                                   STOPLOADING()
                                   block(nil,error);
                                   return ;
                               }
                               NSError *error1;
                               
                               if(data==nil){
                                   block(nil,error);
                               }else{
                                   NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                   NSMutableDictionary * innerJson = [NSJSONSerialization                                                JSONObjectWithData:data options:kNilOptions error:&error1];
                                   block(innerJson,error); // Call back the block passed into your method
                               }
                           }];
    
}



+ (void)executeRequestwithUrl:(NSString *)urlStr  withBlock:(void (^)(NSMutableDictionary *dictresponce,NSError *error))block {
    
       NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
   
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSError *error1;
                               if(data==nil){
                                                                      STOPLOADING()
                                  // NSLog(@"Error Responce : %@",error);
                                   block(nil,error);
                               }else{
                                   
                                   NSMutableDictionary * innerJson = [NSJSONSerialization                                                JSONObjectWithData:data options:kNilOptions error:&error1];
                                   block(innerJson,error); // Call back the block passed into your method
                               }
                           }];
    
}
// Get Today's Date
+(NSString *)getTodayDate{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/YY"];
    return  [dateFormatter stringFromDate:currDate];
}
+ (void)executeRequestwithServicetype:(NSString *)serviceType withDictionary:(NSMutableDictionary *)dict  withBlock:(void (^)(NSMutableDictionary *dictresponce,NSError *error))block {
 
    NSError *error = Nil;
    NSMutableDictionary *requestdict=[[NSMutableDictionary alloc]init];
    [requestdict setObject:serviceType forKey:@"name"];
   /* if (![serviceType isEqualToString:LOGIN_Key])
    {
        [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"daycare_id"] forKey:@"daycare_id"];
    }*/
    [requestdict setObject:dict forKey:@"body"];
   NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestdict options:kNilOptions error:&error];
     NSString *str=[[NSString alloc]initWithData:requestData encoding:NSUTF8StringEncoding];
   // NSLog(@"json body: %@",str);
        // NSData* responseData = nil;
    NSURL *url1=[NSURL URLWithString:[WEBSERVICE_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url1];
    NSString *bodydata=[NSString stringWithFormat:@"json=%@",str];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60.0];
    NSData *req=[NSData dataWithBytes:[bodydata UTF8String] length:[bodydata length]];
    [request setHTTPBody:req];
        [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSError *error1;
                             if(data==nil){
                                                                    STOPLOADING()
                                   block(nil,error);
                               }else{
                              // NSLog(@"Responce : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                               NSMutableDictionary * innerJson = [NSJSONSerialization                                                JSONObjectWithData:data options:kNilOptions error:&error1];
                               block(innerJson,error); // Call back the block passed into your method
                               }
}];

}


+ (void)executeParentRequestwithServicetype:(NSString *)serviceType withDictionary:(NSMutableDictionary *)dict  withBlock:(void (^)(NSMutableDictionary *dictresponce,NSError *error))block {
    
    NSError *error = Nil;
    NSMutableDictionary *requestdict=[[NSMutableDictionary alloc]init];
    [requestdict setObject:serviceType forKey:@"name"];
    [requestdict setObject:dict forKey:@"body"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestdict options:kNilOptions error:&error];
    NSString *str=[[NSString alloc]initWithData:requestData encoding:NSUTF8StringEncoding];
   //// NSLog(@"json body: %@",str);
   //    NSData* responseData = nil;
    NSURL *url1=[NSURL URLWithString:[WEBSERVICE_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url1];
    NSString *bodydata=[NSString stringWithFormat:@"json=%@",str];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60.0];
    NSData *req=[NSData dataWithBytes:[bodydata UTF8String] length:[bodydata length]];
    [request setHTTPBody:req];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSError *error1;
                               if(data==nil){
                                                                      STOPLOADING()
                                   block(nil,error);
                               }else{
                               //   // NSLog(@"Responce : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                   NSMutableDictionary * innerJson = [NSJSONSerialization
                                                                      JSONObjectWithData:data options:kNilOptions error:&error1];
                                   block(innerJson,error); // Call back the block passed into your method
                               }
                           }];
    
}

+(NSString *)uploadImage:(NSString*)requestURL image:(UIImage*)image
{
  
    image=[UIImage imageNamed:@"apple1.jpg"];    NSData *imageData = [UIImagePNGRepresentation(image) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *imageString=[[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    
    NSError *error = Nil;
    NSMutableDictionary *requestdict=[[NSMutableDictionary alloc]init];
     //   [requestdict setObject:@"save_image" forKey:@"name"];

    [requestdict setObject:imageString forKey:@"content"];
    [requestdict setObject:@"apple1.jpg" forKey:@"name"];
  //  [requestdict setObject:dicData forKey:@"body"];

    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestdict options:kNilOptions error:&error];
    NSString *str=[[NSString alloc]initWithData:requestData encoding:NSUTF8StringEncoding];
        // NSData* responseData = nil;
    NSString *mainurl=@"http://kinderopvangapp.eu/api/uploadimg.php";
    NSURL *url1=[NSURL URLWithString:[mainurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //  responseData = [NSMutableData data] ;
    
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url1];
    NSString *bodydata=[NSString stringWithFormat:@"json=%@",str];
    [request setHTTPMethod:@"POST"];
    NSData *req=[NSData dataWithBytes:[bodydata UTF8String] length:[bodydata length]];
    [request setHTTPBody:req];
     [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                             // // NSLog(@"dataAsString %@", [NSString stringWithUTF8String:[data bytes]]);
                               NSError *error1;
                               NSMutableDictionary * innerJson = [NSJSONSerialization
                                                                  JSONObjectWithData:data options:kNilOptions error:&error1];
                              // NSLog(@"Responce %@   Error %@",innerJson,error);
                               // Call back the block passed into your method
                           }];

    return nil;
}
+(void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

+ (UIImage*)resizeImageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



+(BOOL)isRecordFound:(NSMutableDictionary *)dictresponce;
{
    NSMutableArray *arrRecords=[dictresponce objectForKey:@"records"];
    if(arrRecords.count==0)
    {
        [Utility showAlertWithwithMessage:@"No records found"];
        return false;
    }else
        return true;
}

+ (id)cleanJsonToObject:(id)data {
    NSError* error;
    if (data == (id)[NSNull null]){
        return [[NSObject alloc] init];
    }
    id jsonObject;
    if ([data isKindOfClass:[NSData class]]){
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    } else {
        jsonObject = data;
    }
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [jsonObject mutableCopy];
        for (int i = array.count-1; i >= 0; i--) {
            id a = array[i];
            if (a == (id)[NSNull null]){
                [array removeObjectAtIndex:i];
            } else {
                array[i] = [self cleanJsonToObject:a];
            }
        }
        return array;
    } else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictionary = [jsonObject mutableCopy];
        for(NSString *key in [dictionary allKeys]) {
            id d = dictionary[key];
            if (d == (id)[NSNull null]){
                dictionary[key] = @"";
            } else {
                dictionary[key] = [self cleanJsonToObject:d];
            }
        }
        return dictionary;
    } else {
        return jsonObject;
    }
}


+(UIColor *)getRandomColor
{
    while (1) {
        CGFloat red =  (CGFloat)arc4random()/(CGFloat)RAND_MAX;
        CGFloat blue = (CGFloat)arc4random()/(CGFloat)RAND_MAX;
        CGFloat green = (CGFloat)arc4random()/(CGFloat)RAND_MAX;
        CGFloat gray = 0.299 * red + 0.587 * green + 0.114 * blue;
        if (gray < 0.6) {
            return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        }
    }
}


+(NSMutableDictionary *)removeNullFromDict:(NSMutableDictionary *)dict
{
    NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
    for (NSString * key in [dict allKeys])
        {
        if (![[dict objectForKey:key] isKindOfClass:[NSNull class]])
            [prunedDictionary setObject:[dict objectForKey:key] forKey:key];
        }
    return prunedDictionary;
}
+(int)numberOfDaysBetween:(NSString *)startDate and:(NSString *)endDate {
    


NSDateFormatter *f = [[NSDateFormatter alloc] init];
[f setDateFormat:@"dd-MMM-yyyy"];
NSDate *startDate1 = [f dateFromString:startDate];
NSDate *endDate1 = [f dateFromString:endDate];

NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                    fromDate:startDate1
                                                      toDate:endDate1
                                                     options:NSCalendarWrapComponents];
    return components.day;

}


+(BOOL)isEmptyString:(NSString *)str
{
    NSString *rawString = str;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        return true;
        
    }else
        {
        return false;
        }
    
   
}


+(NSString *)decodeHTMLEntities:(NSString *)string {
    
    
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
        // ISO 8859-1 Symbols
    string = [string stringByReplacingOccurrencesOfString:@"&iexcl;" withString:@"¡"];
    string = [string stringByReplacingOccurrencesOfString:@"&cent;" withString:@"¢"];
    string = [string stringByReplacingOccurrencesOfString:@"&pound;" withString:@"£"];
    string = [string stringByReplacingOccurrencesOfString:@"&curren;" withString:@"¤"];
    string = [string stringByReplacingOccurrencesOfString:@"&yen;" withString:@"¥"];
    string = [string stringByReplacingOccurrencesOfString:@"&brvbar;" withString:@"¦"];
    string = [string stringByReplacingOccurrencesOfString:@"&sect;" withString:@"§"];
    string = [string stringByReplacingOccurrencesOfString:@"&uml;" withString:@"¨"];
    string = [string stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"];
    string = [string stringByReplacingOccurrencesOfString:@"&ordf;" withString:@"ª"];
    string = [string stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    string = [string stringByReplacingOccurrencesOfString:@"&not;" withString:@"¬"];
    string = [string stringByReplacingOccurrencesOfString:@"&shy;" withString:@"    "];
    string = [string stringByReplacingOccurrencesOfString:@"&reg;" withString:@"®"];
    string = [string stringByReplacingOccurrencesOfString:@"&macr;" withString:@"¯"];
    string = [string stringByReplacingOccurrencesOfString:@"&deg;" withString:@"°"];
    string = [string stringByReplacingOccurrencesOfString:@"&plusmn;" withString:@"±"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup2;" withString:@"²"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup3;" withString:@"³"];
    string = [string stringByReplacingOccurrencesOfString:@"&acute;" withString:@"´"];
    string = [string stringByReplacingOccurrencesOfString:@"&micro;" withString:@"µ"];
    string = [string stringByReplacingOccurrencesOfString:@"&para;" withString:@"¶"];
    string = [string stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    string = [string stringByReplacingOccurrencesOfString:@"&cedil;" withString:@"¸"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup1;" withString:@"¹"];
    string = [string stringByReplacingOccurrencesOfString:@"&ordm;" withString:@"º"];
    string = [string stringByReplacingOccurrencesOfString:@"&raquo;" withString:@"»"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac14;" withString:@"¼"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac12;" withString:@"½"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac34;" withString:@"¾"];
    string = [string stringByReplacingOccurrencesOfString:@"&iquest;" withString:@"¿"];
    string = [string stringByReplacingOccurrencesOfString:@"&times;" withString:@"×"];
    string = [string stringByReplacingOccurrencesOfString:@"&divide;" withString:@"÷"];
    
        // ISO 8859-1 Characters
    string = [string stringByReplacingOccurrencesOfString:@"&Agrave;" withString:@"À"];
    string = [string stringByReplacingOccurrencesOfString:@"&Aacute;" withString:@"Á"];
    string = [string stringByReplacingOccurrencesOfString:@"&Acirc;" withString:@"Â"];
    string = [string stringByReplacingOccurrencesOfString:@"&Atilde;" withString:@"Ã"];
    string = [string stringByReplacingOccurrencesOfString:@"&Auml;" withString:@"Ä"];
    string = [string stringByReplacingOccurrencesOfString:@"&Aring;" withString:@"Å"];
    string = [string stringByReplacingOccurrencesOfString:@"&AElig;" withString:@"Æ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ccedil;" withString:@"Ç"];
    string = [string stringByReplacingOccurrencesOfString:@"&Egrave;" withString:@"È"];
    string = [string stringByReplacingOccurrencesOfString:@"&Eacute;" withString:@"É"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ecirc;" withString:@"Ê"];
    string = [string stringByReplacingOccurrencesOfString:@"&Euml;" withString:@"Ë"];
    string = [string stringByReplacingOccurrencesOfString:@"&Igrave;" withString:@"Ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&Iacute;" withString:@"Í"];
    string = [string stringByReplacingOccurrencesOfString:@"&Icirc;" withString:@"Î"];
    string = [string stringByReplacingOccurrencesOfString:@"&Iuml;" withString:@"Ï"];
    string = [string stringByReplacingOccurrencesOfString:@"&ETH;" withString:@"Ð"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ntilde;" withString:@"Ñ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ograve;" withString:@"Ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&Oacute;" withString:@"Ó"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ocirc;" withString:@"Ô"];
    string = [string stringByReplacingOccurrencesOfString:@"&Otilde;" withString:@"Õ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ouml;" withString:@"Ö"];
    string = [string stringByReplacingOccurrencesOfString:@"&Oslash;" withString:@"Ø"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ugrave;" withString:@"Ù"];
    string = [string stringByReplacingOccurrencesOfString:@"&Uacute;" withString:@"Ú"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ucirc;" withString:@"Û"];
    string = [string stringByReplacingOccurrencesOfString:@"&Uuml;" withString:@"Ü"];
    string = [string stringByReplacingOccurrencesOfString:@"&Yacute;" withString:@"Ý"];
    string = [string stringByReplacingOccurrencesOfString:@"&THORN;" withString:@"Þ"];
    string = [string stringByReplacingOccurrencesOfString:@"&szlig;" withString:@"ß"];
    string = [string stringByReplacingOccurrencesOfString:@"&agrave;" withString:@"à"];
    string = [string stringByReplacingOccurrencesOfString:@"&aacute;" withString:@"á"];
    string = [string stringByReplacingOccurrencesOfString:@"&acirc;" withString:@"â"];
    string = [string stringByReplacingOccurrencesOfString:@"&atilde;" withString:@"ã"];
    string = [string stringByReplacingOccurrencesOfString:@"&auml;" withString:@"ä"];
    string = [string stringByReplacingOccurrencesOfString:@"&aring;" withString:@"å"];
    string = [string stringByReplacingOccurrencesOfString:@"&aelig;" withString:@"æ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ccedil;" withString:@"ç"];
    string = [string stringByReplacingOccurrencesOfString:@"&egrave;" withString:@"è"];
    string = [string stringByReplacingOccurrencesOfString:@"&eacute;" withString:@"é"];
    string = [string stringByReplacingOccurrencesOfString:@"&ecirc;" withString:@"ê"];
    string = [string stringByReplacingOccurrencesOfString:@"&euml;" withString:@"ë"];
    string = [string stringByReplacingOccurrencesOfString:@"&igrave;" withString:@"ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&iacute;" withString:@"í"];
    string = [string stringByReplacingOccurrencesOfString:@"&icirc;" withString:@"î"];
    string = [string stringByReplacingOccurrencesOfString:@"&iuml;" withString:@"ï"];
    string = [string stringByReplacingOccurrencesOfString:@"&eth;" withString:@"ð"];
    string = [string stringByReplacingOccurrencesOfString:@"&ntilde;" withString:@"ñ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ograve;" withString:@"ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&oacute;" withString:@"ó"];
    string = [string stringByReplacingOccurrencesOfString:@"&ocirc;" withString:@"ô"];
    string = [string stringByReplacingOccurrencesOfString:@"&otilde;" withString:@"õ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ouml;" withString:@"ö"];
    string = [string stringByReplacingOccurrencesOfString:@"&oslash;" withString:@"ø"];
    string = [string stringByReplacingOccurrencesOfString:@"&ugrave;" withString:@"ù"];
    string = [string stringByReplacingOccurrencesOfString:@"&uacute;" withString:@"ú"];
    string = [string stringByReplacingOccurrencesOfString:@"&ucirc;" withString:@"û"];
    string = [string stringByReplacingOccurrencesOfString:@"&uuml;" withString:@"ü"];
    string = [string stringByReplacingOccurrencesOfString:@"&yacute;" withString:@"ý"];
    string = [string stringByReplacingOccurrencesOfString:@"&thorn;" withString:@"þ"];
    string = [string stringByReplacingOccurrencesOfString:@"&yuml;" withString:@"ÿ"];
        // Reserved Characters in HTML
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
        // ISO 8859-1 Symbols
    string = [string stringByReplacingOccurrencesOfString:@"&iexcl;" withString:@"¡"];
    string = [string stringByReplacingOccurrencesOfString:@"&cent;" withString:@"¢"];
    string = [string stringByReplacingOccurrencesOfString:@"&pound;" withString:@"£"];
    string = [string stringByReplacingOccurrencesOfString:@"&curren;" withString:@"¤"];
    string = [string stringByReplacingOccurrencesOfString:@"&yen;" withString:@"¥"];
    string = [string stringByReplacingOccurrencesOfString:@"&brvbar;" withString:@"¦"];
    string = [string stringByReplacingOccurrencesOfString:@"&sect;" withString:@"§"];
    string = [string stringByReplacingOccurrencesOfString:@"&uml;" withString:@"¨"];
    string = [string stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"];
    string = [string stringByReplacingOccurrencesOfString:@"&ordf;" withString:@"ª"];
    string = [string stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    string = [string stringByReplacingOccurrencesOfString:@"&not;" withString:@"¬"];
    string = [string stringByReplacingOccurrencesOfString:@"&shy;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&reg;" withString:@"®"];
    string = [string stringByReplacingOccurrencesOfString:@"&macr;" withString:@"¯"];
    string = [string stringByReplacingOccurrencesOfString:@"&deg;" withString:@"°"];
    string = [string stringByReplacingOccurrencesOfString:@"&plusmn;" withString:@"±"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup2;" withString:@"²"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup3;" withString:@"³"];
    string = [string stringByReplacingOccurrencesOfString:@"&acute;" withString:@"´"];
    string = [string stringByReplacingOccurrencesOfString:@"&micro;" withString:@"µ"];
    string = [string stringByReplacingOccurrencesOfString:@"&para;" withString:@"¶"];
    string = [string stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    string = [string stringByReplacingOccurrencesOfString:@"&cedil;" withString:@"¸"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup1;" withString:@"¹"];
    string = [string stringByReplacingOccurrencesOfString:@"&ordm;" withString:@"º"];
    string = [string stringByReplacingOccurrencesOfString:@"&raquo;" withString:@"»"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac14;" withString:@"¼"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac12;" withString:@"½"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac34;" withString:@"¾"];
    string = [string stringByReplacingOccurrencesOfString:@"&iquest;" withString:@"¿"];
    string = [string stringByReplacingOccurrencesOfString:@"&times;" withString:@"×"];
    string = [string stringByReplacingOccurrencesOfString:@"&divide;" withString:@"÷"];
    
        // ISO 8859-1 Characters
    string = [string stringByReplacingOccurrencesOfString:@"&Agrave;" withString:@"À"];
    string = [string stringByReplacingOccurrencesOfString:@"&Aacute;" withString:@"Á"];
    string = [string stringByReplacingOccurrencesOfString:@"&Acirc;" withString:@"Â"];
    string = [string stringByReplacingOccurrencesOfString:@"&Atilde;" withString:@"Ã"];
    string = [string stringByReplacingOccurrencesOfString:@"&Auml;" withString:@"Ä"];
    string = [string stringByReplacingOccurrencesOfString:@"&Aring;" withString:@"Å"];
    string = [string stringByReplacingOccurrencesOfString:@"&AElig;" withString:@"Æ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ccedil;" withString:@"Ç"];
    string = [string stringByReplacingOccurrencesOfString:@"&Egrave;" withString:@"È"];
    string = [string stringByReplacingOccurrencesOfString:@"&Eacute;" withString:@"É"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ecirc;" withString:@"Ê"];
    string = [string stringByReplacingOccurrencesOfString:@"&Euml;" withString:@"Ë"];
    string = [string stringByReplacingOccurrencesOfString:@"&Igrave;" withString:@"Ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&Iacute;" withString:@"Í"];
    string = [string stringByReplacingOccurrencesOfString:@"&Icirc;" withString:@"Î"];
    string = [string stringByReplacingOccurrencesOfString:@"&Iuml;" withString:@"Ï"];
    string = [string stringByReplacingOccurrencesOfString:@"&ETH;" withString:@"Ð"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ntilde;" withString:@"Ñ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ograve;" withString:@"Ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&Oacute;" withString:@"Ó"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ocirc;" withString:@"Ô"];
    string = [string stringByReplacingOccurrencesOfString:@"&Otilde;" withString:@"Õ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ouml;" withString:@"Ö"];
    string = [string stringByReplacingOccurrencesOfString:@"&Oslash;" withString:@"Ø"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ugrave;" withString:@"Ù"];
    string = [string stringByReplacingOccurrencesOfString:@"&Uacute;" withString:@"Ú"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ucirc;" withString:@"Û"];
    string = [string stringByReplacingOccurrencesOfString:@"&Uuml;" withString:@"Ü"];
    string = [string stringByReplacingOccurrencesOfString:@"&Yacute;" withString:@"Ý"];
    string = [string stringByReplacingOccurrencesOfString:@"&THORN;" withString:@"Þ"];
    string = [string stringByReplacingOccurrencesOfString:@"&szlig;" withString:@"ß"];
    string = [string stringByReplacingOccurrencesOfString:@"&agrave;" withString:@"à"];
    string = [string stringByReplacingOccurrencesOfString:@"&aacute;" withString:@"á"];
    string = [string stringByReplacingOccurrencesOfString:@"&acirc;" withString:@"â"];
    string = [string stringByReplacingOccurrencesOfString:@"&atilde;" withString:@"ã"];
    string = [string stringByReplacingOccurrencesOfString:@"&auml;" withString:@"ä"];
    string = [string stringByReplacingOccurrencesOfString:@"&aring;" withString:@"å"];
    string = [string stringByReplacingOccurrencesOfString:@"&aelig;" withString:@"æ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ccedil;" withString:@"ç"];
    string = [string stringByReplacingOccurrencesOfString:@"&egrave;" withString:@"è"];
    string = [string stringByReplacingOccurrencesOfString:@"&eacute;" withString:@"é"];
    string = [string stringByReplacingOccurrencesOfString:@"&ecirc;" withString:@"ê"];
    string = [string stringByReplacingOccurrencesOfString:@"&euml;" withString:@"ë"];
    string = [string stringByReplacingOccurrencesOfString:@"&igrave;" withString:@"ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&iacute;" withString:@"í"];
    string = [string stringByReplacingOccurrencesOfString:@"&icirc;" withString:@"î"];
    string = [string stringByReplacingOccurrencesOfString:@"&iuml;" withString:@"ï"];
    string = [string stringByReplacingOccurrencesOfString:@"&eth;" withString:@"ð"];
    string = [string stringByReplacingOccurrencesOfString:@"&ntilde;" withString:@"ñ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ograve;" withString:@"ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&oacute;" withString:@"ó"];
    string = [string stringByReplacingOccurrencesOfString:@"&ocirc;" withString:@"ô"];
    string = [string stringByReplacingOccurrencesOfString:@"&otilde;" withString:@"õ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ouml;" withString:@"ö"];
    string = [string stringByReplacingOccurrencesOfString:@"&oslash;" withString:@"ø"];
    string = [string stringByReplacingOccurrencesOfString:@"&ugrave;" withString:@"ù"];
    string = [string stringByReplacingOccurrencesOfString:@"&uacute;" withString:@"ú"];
    string = [string stringByReplacingOccurrencesOfString:@"&ucirc;" withString:@"û"];
    string = [string stringByReplacingOccurrencesOfString:@"&uuml;" withString:@"ü"];
    string = [string stringByReplacingOccurrencesOfString:@"&yacute;" withString:@"ý"];
    string = [string stringByReplacingOccurrencesOfString:@"&thorn;" withString:@"þ"];
    string = [string stringByReplacingOccurrencesOfString:@"&yuml;" withString:@"ÿ"];
    
    
    
    
    
    
    return string;
}

@end
