//
//  ViewController.m
//  SampleSilentPrint
//
//  Created by Lê Hà Thành on 4/25/17.
//  Copyright © 2017 Lê Hà Thành. All rights reserved.
//

#import "ViewController.h"
#import "SilentPrint.h"
#import "PrinterSingleton.h"
#import "FilePrint.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (nonatomic, strong) SilentPrint *silentPrint;
@property (nonatomic, strong) PrinterSingleton *sharePrint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)actionButton:(id)sender {
    self.sharePrint = [PrinterSingleton sharedInstance];
    self.silentPrint = [SilentPrint new];
    [self.silentPrint configureSilentPrint:self.scanButton.frame
                                    inView:self.view
                                completion:^{
                                        NSLog(@"%@",self.sharePrint.printerShare.displayName);
                                }];
}
- (IBAction)printFile:(id)sender {
    NSArray *filePaths = @[
                           [[NSBundle mainBundle] pathForResource:@"1" ofType:@"pdf"],
                           [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"],
                           [[NSBundle mainBundle] pathForResource:@"3" ofType:@"html"]
                           ];
    
    
    
    if (!self.silentPrint || !self.sharePrint.printerShare) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error whe"
                                                                       message:@"Alert message"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self.silentPrint silentPrint:filePaths timeInterval:1000];
    }
    
}



@end
