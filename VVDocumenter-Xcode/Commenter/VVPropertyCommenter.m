//
//  VVPropertyCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVPropertyCommenter.h"

@implementation VVPropertyCommenter

-(id)initWithIndentString:(NSString *)indent codeString:(NSString *)code
{
    if (self = [super initWithIndentString:indent codeString:code]) {
        self.commenterType = @"property";
        self.hasDiscussion = NO;
    }
    return self;
}



@end
