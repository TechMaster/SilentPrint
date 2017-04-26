//
//  SilentPrint.h
//
//  Created by Lê Hà Thành on 10/24/16.
//  Copyright © 2016 Lê Hà Thành. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FilePrint.h"
#import "PrinterSingleton.h"


@interface SilentPrint : NSObject

@property(nonatomic, strong) NSArray *filePrints;
@property(nonatomic, strong) UIPrintInteractionController *printInteraction;
@property(nonatomic, strong) PrinterSingleton *sharePrint;
@property(nonatomic, strong) SilentPrint *silent;

-(void)configureSilentPrint:(CGRect) rect
                     inView:(UIView*) view
                 completion:(void (^)(void))completionBlock;

-(void)silentPrint:(NSArray *)filePaths timeInterval:(NSInteger)interval;

-(void)printFile:(NSInteger)fileNums  timeInterval:(NSInteger)interval;

-(UIPrintInfo *)printerInfo:(NSString *)outputType;

-(UIMarkupTextPrintFormatter *)printHTML:(NSString *)nameHTML;
-(NSURL *)printPDF:(NSString *)namePDF;
-(UIImage *)printImage:(NSString *)nameImage;

-(void)postNotificationCenter:(NSDictionary *)dataDict;


@end
