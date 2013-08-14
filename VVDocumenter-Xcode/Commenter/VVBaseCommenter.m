//
//  VVBaseCommenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVBaseCommenter.h"
#import "VVArgument.h"
#import "VVDocumenterSetting.h"

@interface VVBaseCommenter()

@property (nonatomic, copy) NSString *space;
@end

@implementation VVBaseCommenter

-(id) initWithIndentString:(NSString *)indent codeString:(NSString *)code
{
    self = [super init];
    if (self) {
        self.indent = indent;
        self.code = code;
        self.arguments = [NSMutableArray array];
        self.space = [[VVDocumenterSetting defaultSetting] spacesString];
    }
    return self;
}

-(NSString *) startComment
{
    NSMutableString *startString = [NSMutableString string];

    //firstLine
    [startString appendFormat:@"%@/*!\n",self.indent];
    
    if ([[VVDocumenterSetting defaultSetting] showEditor]) {
        [startString appendFormat:@"%@%@ %@ ****** %@ ******\n",self.indent,self.prefixString,self.space,self.editorString];
    }
    
    //secondLine
    [startString appendFormat:@"%@%@@%@\n",self.indent,self.prefixString,self.commenterType];
    //thirdLine
    [startString appendFormat:@"%@%@@abstract%@<#%@#>\n",self.indent,self.prefixString,self.space,@"abstract"];

    if (self.hasDiscussion) {
        [startString appendFormat:@"%@%@@discussion%@<#%@#>\n",self.indent,self.prefixString,self.space,@"discussion"];
    }    
    return startString;
}

-(NSString *) argumentsComment
{
    if (self.arguments.count == 0)
        return @"";
    
    // start of with an empty line
    NSMutableString *result = [NSMutableString string];
    
    int longestNameLength = [[self.arguments valueForKeyPath:@"@max.name.length"] intValue];
    
    for (VVArgument *arg in self.arguments)
    {
        NSString *paddedName = [arg.name stringByPaddingToLength:longestNameLength withString:@" " startingAtIndex:0];
        
        [result appendFormat:@"%@@param %@ <#%@ description#>\n", self.prefixString, paddedName, arg.name];
    }
    return result;
}

-(NSString *) returnComment
{
    if (!self.hasReturn) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"%@@return <#return value description#>\n", self.prefixString];
    }
}

-(NSString *) endComment
{
    return [NSString stringWithFormat:@"%@ */",self.indent];
}

-(NSString *) document
{
    return [NSString stringWithFormat:@"%@%@%@%@",[self startComment],
                                                  [self argumentsComment],
                                                  [self returnComment],
                                                  [self endComment]];
}

-(NSString *) emptyLine
{
    return [NSString stringWithFormat:@"%@\n", self.prefixString];
}

-(NSString *) prefixString
{
    if ([[VVDocumenterSetting defaultSetting] prefixWithStar]) {
        return [NSString stringWithFormat:@"%@ *%@", self.indent, self.space];
    }
    else {
        return [NSString stringWithFormat:@"%@ ", self.indent];
    }
}

- (NSString *)editorString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate new]];
    return [NSString stringWithFormat:@"%@added by %@ on %@", self.indent,NSUserName(),dateString];
}

-(void) parseArguments
{
    [self.arguments removeAllObjects];
    NSArray * braceGroups = [self.code vv_stringsByExtractingGroupsUsingRegexPattern:@"\\(([^\\(\\)]*)\\)"];
    if (braceGroups.count > 0) {
        NSString *argumentGroupString = braceGroups[0];
        NSArray *argumentStrings = [argumentGroupString componentsSeparatedByString:@","];
        for (NSString *argumentString in argumentStrings) {
            VVArgument *arg = [[VVArgument alloc] init];
            argumentString = [argumentString vv_stringByReplacingRegexPattern:@"\\s+$" withString:@""];
            argumentString = [argumentString vv_stringByReplacingRegexPattern:@"\\s+" withString:@" "];
            NSMutableArray *tempArgs = [[argumentString componentsSeparatedByString:@" "] mutableCopy];
            while ([[tempArgs lastObject] isEqualToString:@" "]) {
                [tempArgs removeLastObject];
            }
            arg.name = [tempArgs lastObject];

            [tempArgs removeLastObject];
            arg.type = [tempArgs componentsJoinedByString:@" "];
            
            VVLog(@"arg type: %@", arg.type);
            VVLog(@"arg name: %@", arg.name);
            
            [self.arguments addObject:arg];
        }
    }

}
@end
