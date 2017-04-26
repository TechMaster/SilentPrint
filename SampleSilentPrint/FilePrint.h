//
//  FilePrint.h
//
//  Created by Lê Hà Thành on 10/24/16.
//  Copyright © 2016 Lê Hà Thành. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilePrint : NSObject

//@property (nonatomic,copy) NSString *nameFile;
@property (nonatomic,copy) NSString *fileOfType;
@property (nonatomic,copy) NSString *path;

-(instancetype)initWithString:(NSString*)path;
@end
