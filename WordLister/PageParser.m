//
//  PageParser.m
//  WordLister
//
//  Created by Doug on 11/13/14.
//  Copyright (c) 2014 Doug Roeper. All rights reserved.
//

#import "PageParser.h"

//<a href="/wiki/Charge-coupled_device" title="Charge-coupled device">

#define kHREF @"<a href=\"/wiki/"
#define kTITLE @"title=\""
#define kEND @"\""

@implementation PageParser
///pablo here
+(NSDictionary *)parseString:(NSString *)aPageString
{
    NSMutableDictionary *words = [NSMutableDictionary dictionary];
    
    int index = 0;
    BOOL done = NO;
    
    while (!done)
    {
        NSRange nextHREF = [aPageString rangeOfString:kHREF options:NSCaseInsensitiveSearch range:NSMakeRange(index, aPageString.length - index - 1)];
        
        if (nextHREF.location + nextHREF.length < aPageString.length)
        {
            NSRange nextTitle = [aPageString rangeOfString:kTITLE options:NSCaseInsensitiveSearch range:NSMakeRange(nextHREF.location + nextHREF.length, aPageString.length - nextHREF.location - nextHREF.length)];
            
            if (nextTitle.location + nextHREF.length < aPageString.length)
            {
                NSRange nextEnd = [aPageString rangeOfString:kEND options:NSCaseInsensitiveSearch range:NSMakeRange(nextTitle.location + nextTitle.length, aPageString.length - nextTitle.location - nextTitle.length)];
                
                if (nextEnd.location + nextEnd.length < aPageString.length)
                {
                    int wordLength = (int)(nextEnd.location - nextTitle.location - nextTitle.length);
                    NSString *word = [aPageString substringWithRange:NSMakeRange(nextTitle.location + nextTitle.length, wordLength)];
                    
                    index = (int)(nextEnd.location + nextEnd.length);
                    
                    NSLog(@"%@", word);
                    
                    if ([words objectForKey:word] == nil)
                    {
                        [words setObject:[NSNumber numberWithInt:1] forKey:word];
                    }
                    else
                    {
                        int count = [[words objectForKey:word] intValue];
                        count++;
                        [words setObject:[NSNumber numberWithInt:count] forKey:word];
                    }
                }
                else
                    done = YES;
            }
            else
                done = YES;
            
            if (index >= aPageString.length)
            {
                done = YES;
            }
        }
        else
            done = YES;
    }
    
    for (NSString *word in [words allKeys])
    {
        int count = 0;
        int index = 0;
        while (index + word.length < aPageString.length)
        {
            NSRange next = [aPageString rangeOfString:[NSString stringWithFormat:@"%@", word] options:NSCaseInsensitiveSearch range:NSMakeRange(index, aPageString.length - index - 1)];
            if (next.location != NSNotFound)
            {
                index = (int)(next.location + next.length);
                count++;
            }
            else
            {
                break;
            }
        }
        [words setObject:[NSNumber numberWithInt:count] forKey:word];
    }
    
    return [NSDictionary dictionaryWithDictionary:words];
}

@end