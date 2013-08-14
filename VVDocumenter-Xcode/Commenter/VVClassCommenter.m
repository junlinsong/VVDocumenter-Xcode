//
//  VVClassCommenter.m
//  VVDocumenter-Xcode
//
//  Created by jun on 8/14/13.
//  Copyright (c) 2013 OneV's Den. All rights reserved.
//

#import "VVClassCommenter.h"

@implementation VVClassCommenter

-(id)initWithIndentString:(NSString *)indent codeString:(NSString *)code
{
    if (self = [super initWithIndentString:indent codeString:code]) {
        self.commenterType = @"class";
        self.hasDiscussion = NO;
    }
    return self;
}

@end
