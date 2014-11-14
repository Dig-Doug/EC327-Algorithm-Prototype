//
//  PageParser.h
//  WordLister
//
//  Created by Doug on 11/13/14.
//  Copyright (c) 2014 Doug Roeper. All rights reserved.
//

#ifndef WordLister_PageParser_h
#define WordLister_PageParser_h

#import <UIKit/UIKit.h>

@interface PageParser : NSObject

+(NSDictionary *)parseString:(NSString *)aPageString;

@end


#endif
