//
//  FilePrint.m
//
//  Created by Lê Hà Thành on 10/24/16.
//  Copyright © 2016 Lê Hà Thành. All rights reserved.
//

#import "FilePrint.h"

@implementation FilePrint

-(instancetype)initWithString:(NSString *)path
{
    self = [super init];
    if (self) {
        NSArray *nameFile = [path componentsSeparatedByString:@"/"];
        NSInteger indexName = [nameFile count] - (int)1;
        NSArray *nameAndType = [nameFile[indexName] componentsSeparatedByString:@"."];
        _fileOfType = nameAndType[1];
        _path = path;
    }
    return self;
}

@end
