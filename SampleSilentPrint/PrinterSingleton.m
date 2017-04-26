//
//  PrinterSingleton.m
//
//  Created by Lê Hà Thành on 11/9/16.
//  Copyright © 2016 Lê Hà Thành. All rights reserved.
//

#import "PrinterSingleton.h"

@implementation PrinterSingleton
/*-(id) init:(UIPrinter*) printer
{
    if (self = [super init])
    {
        _printerShare = printer;
    }
    return self;
}*/


+ (PrinterSingleton *)sharedInstance
{
    static PrinterSingleton *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PrinterSingleton alloc] init];
    });
    return _sharedInstance;
}

/*
-(instancetype)initWith:(UIPrinter *)printerName
{
    self = [super init];
    if (self) {
        _printerShare = printerName;
    }
    return self;

}*/



@end
