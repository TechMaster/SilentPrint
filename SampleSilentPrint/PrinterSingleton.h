//
//  PrinterSingleton.h
//
//  Created by Lê Hà Thành on 11/9/16.
//  Copyright © 2016 Lê Hà Thành. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PrinterSingleton : NSObject
@property (nonatomic, strong) UIPrinter *printerShare;  //Selected Printer

+(PrinterSingleton*) sharedInstance;

//-(instancetype)initWith:(UIPrinter *)printerName;
@end
