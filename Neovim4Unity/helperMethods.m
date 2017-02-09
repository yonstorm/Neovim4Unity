//
//  helperMethods.m
//  Neovim4Unity
//
//  Created by Joni Strömberg on 17/11/2016.
//  Copyright © 2016 Yonstorm. All rights reserved.
//

#import "helperMethods.h"

@implementation helperMethods
    +(void)logString:(NSString *)passedString
    
    {
        NSLog(@"This is the passed string '%@'", passedString);
    }
    
    +(NSNumber *)getLinenumber:(NSData *)data
    {
        unsigned char *buffer = malloc(sizeof(UInt16));
        [data getBytes: buffer range:NSMakeRange(2, sizeof(UInt16))];
        UInt16 line = *(UInt16 *)buffer;
        if (line == ((UInt16)65534)) {
            line = 0;
        }
        line += 1;
        NSLog(@"whos there !!!!!! %hu",line);
        
        return [NSNumber numberWithUnsignedInt:line];
        
    }
    
@end
