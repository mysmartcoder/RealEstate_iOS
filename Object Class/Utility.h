//
//  Utility.h
//  Kinderopvang
//
//  Created by NLS17 on 18/07/14.
//  Copyright (c) 2014 NexusLinkServices. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Static.h"
#import "Reachability.h"
#import <UIKit/UIKit.h>
#define MESSAGE_COMPOSER_HEIGHT 40.0

@interface Utility : NSObject
+(NSString *)getTodayDate;

+(void)setNavigationBar:(UINavigationController *)navController;
+(UIColor*)getColor:(NSString*)colorcode;
+(UIImage *)getBackgroundImage;
+(UIImage *)changeImageColorWithColor:(UIColor *)color withImageName:(NSString *)imageName;
+(BOOL)isValidateEmail:(NSString *)emailId;
+(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message;
+(void)showAlertWithwithMessage:(NSString *)message;
/*+ (void)executeRequestwithServicetype:(NSString *)serviceType withDictionary:(NSMutableDictionary *)dict  withBlock:(void (^)(NSMutableDictionary *dictresponce,NSError *error))block ;
+ (void)executeParentRequestwithServicetype:(NSString *)serviceType withDictionary:(NSMutableDictionary *)dict  withBlock:(void (^)(NSMutableDictionary *dictresponce,NSError *error))block;*/
+(NSString *)uploadImage:(NSString*)requestURL image:(UIImage*)image;
+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;
+(BOOL)isInternetConnected;
+(void)showinternetErrorMessage;
+ (UIImage*)resizeImageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+(UIImage *)changeImageColorWithColor:(UIColor *)color withImage:(UIImage *)image;
/*+ (void)executeRequestwithServicetype:(NSString *)serviceType withPostString:(NSString *)postString withBlock:(void (^)(NSMutableDictionary *dictresponce,NSError *error))block ;*/
+ (UIImage *)imageWithColor:(NSString *)colorcode;
/*+ (void)executeRequestwithUrl:(NSString *)urlStr  withBlock:(void (^)(NSMutableDictionary *dictresponce,NSError *error))block ;*/
+ (void)executeGetRequestwithServicetype:(NSString *)serviceType withBlock:(void (^)(NSMutableDictionary *dictresponce,NSError *error))block;
+ (id)cleanJsonToObject:(id)data;
+(UIColor *)getRandomColor;
+(NSMutableDictionary *)removeNullFromDict:(NSMutableDictionary *)dict;
+(int)numberOfDaysBetween:(NSString *)startDate and:(NSString *)endDate;
+(BOOL)isEmptyString:(NSString *)str;

+(NSString *)decodeHTMLEntities:(NSString *)string ;


@end
