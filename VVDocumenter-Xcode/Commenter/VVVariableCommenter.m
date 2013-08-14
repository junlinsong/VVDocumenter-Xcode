//
//  VVVariableCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVVariableCommenter.h"

@implementation VVVariableCommenter

-(id)initWithIndentString:(NSString *)indent codeString:(NSString *)code
{
    if (self = [super initWithIndentString:indent codeString:code]) {
        self.commenterType = @"variable";
    }
    return self;
}

@end
