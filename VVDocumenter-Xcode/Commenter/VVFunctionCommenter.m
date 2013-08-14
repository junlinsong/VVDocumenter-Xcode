//
//  VVFunctionCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVFunctionCommenter.h"

@implementation VVFunctionCommenter

-(id)initWithIndentString:(NSString *)indent codeString:(NSString *)code
{
    if (self = [super initWithIndentString:indent codeString:code]) {
        self.commenterType = @"function";
        self.hasDiscussion = YES;
    }
    return self;
}

-(void) captureReturnType
{
    NSArray *arr = [self.code componentsSeparatedByString:@"("];
    if (arr.count > 0 && ![arr[0] vv_matchesPatternRegexPattern:@"void"]) {
        self.hasReturn = YES;
    }
}

-(void) captureParameters
{
    [self parseArguments];
}

-(NSString *) document
{
    [self captureReturnType];
    [self captureParameters];
    
    return [super document];
}

@end
