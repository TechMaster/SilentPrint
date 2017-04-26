//
//  SilentPrint.m
//
//  Created by Lê Hà Thành on 10/24/16.
//  Copyright © 2016 Lê Hà Thành. All rights reserved.
//

#import "SilentPrint.h"
#import "PrinterSingleton.h"

@implementation SilentPrint

NSInteger numOfFile = 0;

@synthesize sharePrint, filePrints, printInteraction, silent;


// cài đặt máy in
// hiện popup vị trí CGRect ở view
-(void)configureSilentPrint:(CGRect)rect inView:(UIView *)view completion:(void (^)(void))completionBlock
{
    sharePrint = [PrinterSingleton sharedInstance];
    // khởi tạo singleton
    
    UIPrinterPickerController *printerPicker = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
    //The selected printer. Set this before presenting the UI to show the currently selected printer. Use this to determine which printer the user selected.
    
    // hàm này trả về print được chọn
    
    [printerPicker presentFromRect: rect inView: view animated: NO
                 completionHandler: ^(UIPrinterPickerController *printerPickerController, BOOL didSelect, NSError *error) {
                     // nếu có lỗi
                     if (error != nil) {
                         NSLog(@"Error %@",error);
                     }
                     // nếu printer đc chọn
                     if (didSelect) {
                         // gắn vào singleton
                         sharePrint.printerShare = printerPickerController.selectedPrinter;
                         completionBlock();
                     } else {
                         // người dùng k click chọn printer
                         NSLog(@"Printer is not selected");
                         
                     }
                 }];
}

// truyền vào 1 mảng các file để in với thời gian timeInterval (e k rõ thời gian này để làm gì)
-(void) silentPrint:(NSArray *)filePaths timeInterval:(NSInteger)interval
{
    
    sharePrint = [PrinterSingleton sharedInstance];
    // kiểu tra xem đã chọn máy in chưa
    if (sharePrint.printerShare != nil){
        NSLog(@"File print %@", filePaths);
        
        NSMutableArray *arrayPrint = [NSMutableArray arrayWithCapacity:[filePaths count]];
        
        
        for (NSString *path in filePaths) {            
            [arrayPrint addObject:[[FilePrint alloc] initWithString: path]];
        }
        
        // gán mảng vào filePrints để có thể dùng trong class
        
        filePrints = [NSArray arrayWithArray:arrayPrint];

        // bắt đầu in file đầu tiên
        [self printFile: 0 timeInterval: interval];
    } else {
        // Báo lỗi là chưa chọn máy in
        NSLog(@"Please config printer in General Setting");
    }
}

-(void)printFile:(NSInteger)fileNums timeInterval:(NSInteger)interval
{
    // lấy file theo fileNums
    FilePrint *file = filePrints[fileNums];
    // lấy kiểu file
    NSString *fileOfType = [file fileOfType];
    
    printInteraction = [UIPrintInteractionController sharedPrintController];
    
    // lấy info theo kiểu file
    UIPrintInfo *info = [self printerInfo: fileOfType];
    printInteraction.printInfo = info;
    
    NSLog(@"Printing.....");
    if ([fileOfType isEqualToString:@"pdf"]) {
        // in file pdf
        printInteraction.printingItem = [self printPDF: [file path]];
    } else if ([fileOfType isEqualToString:@"jpg"]){
        // in file jpg
        printInteraction.printingItem = [self printImage: [file path]];
    } else if ([fileOfType isEqualToString:@"html"] || [fileOfType isEqualToString:@"txt"]) {
        // in file html
        printInteraction.printFormatter = [self printHTML: [file path]];
    } else {
        // ngoài các kiểu trên thì báo lỗi
        NSLog(@"Cannot print the file. %@ is not supported ", fileOfType);
    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        // bắt đầu in mà k hiện UI
        [printInteraction printToPrinter: sharePrint.printerShare
                       completionHandler:^(UIPrintInteractionController  *printInteractionController, BOOL completed, NSError *error) {
                           // nếu lỗi thì
                           if (error != nil) {
                               NSDictionary *dataDict = @{
                                                          @"eventType": @"printFailed",
                                                          @"errorReason": error};
                               [self postNotificationCenter:dataDict];
                           } else if (completed) {
                               // kiểu tra biên interval
                               // thông báo qua USERDefault
                               if (interval != 0){
                                   float floatFileNums = [[NSNumber numberWithInteger: (int)fileNums + 1] floatValue];
                                   float floatFilePrint = [[NSNumber numberWithInteger:[filePrints count]] floatValue];
                                   float precent = floatFileNums / floatFilePrint * 100;
                                   
                                   
                                   NSString *string1 = [NSString stringWithFormat:@"%d of files printed", (int)fileNums+1];
                                   NSString *string2 = [NSString stringWithFormat:@" %f %% complete", precent];
                                   NSArray *eventData = [NSArray arrayWithObjects:string1 ,string2, nil];
                                   NSArray *eventType = [NSArray arrayWithObjects:@"numberFinished", @"precentDone", nil];
                                   NSDictionary *dataDict = @{
                                                              @"eventType": eventType,
                                                              @"eventData": eventData
                                                              };
                                   
                                   [self postNotificationCenter:dataDict];
                               } else {
                                   
                                   NSDictionary *dataDict = @{
                                                              @"eventType": @"numberFinished",
                                                              @"eventData": [NSNumber numberWithInteger:(int)fileNums + 1]};
                                   
                                   [self postNotificationCenter:dataDict];
                               }
                               
                               if ((int)fileNums >= (int)[filePrints count] - (int)1) {
                                   NSLog(@"Print complete");
                                   NSDictionary *dataDict = @{
                                                              @"eventType": @"printComplete",
                                                              @"eventData": @"Success"};
                                   [self postNotificationCenter:dataDict];
                                   return ;
                               }
                               // in file tiếp theo
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self printFile:fileNums+1 timeInterval:interval];
                                   
                               });
                           }
                       }];
    });
}

// setup info
-(UIPrintInfo *)printerInfo:(NSString *)outputType
{
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    if ([outputType compare:@"jpg"]) {
        printInfo.outputType = UIPrintInfoOutputPhoto;
    } else {
        printInfo.outputType = UIPrintInfoOutputGeneral;
    }
    
    printInfo.jobName = @"Print Job";
    return printInfo;
}


-(NSURL *)printPDF:(NSString *)namePDF
{
    return [NSURL fileURLWithPath: namePDF];
}

-(UIImage *)printImage:(NSString *)nameImage
{
    NSString *urlString = [nameImage stringByAppendingString:@".jpg"];
    return [UIImage imageNamed: urlString];
}

-(UIMarkupTextPrintFormatter *)printHTML:(NSString *)currentFilePath
{
    NSLog(@"%@", currentFilePath);
    NSString* content1 = [NSString stringWithContentsOfFile:currentFilePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:NULL];
    
    UIMarkupTextPrintFormatter *htmlFormatter = [[UIMarkupTextPrintFormatter alloc]
                                                 initWithMarkupText:content1];
    htmlFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    
    // iOS 10.0
    //    htmlFormatter.perPageContentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0);
    return htmlFormatter;
}

-(void)postNotificationCenter:(NSDictionary *)dataDict
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"silentPrintProgress"
                                                       object:nil
                                                     userInfo:dataDict];
}

@end
