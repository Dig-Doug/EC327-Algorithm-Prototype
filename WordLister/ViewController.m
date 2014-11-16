//
//  ViewController.m
//  WordLister
//
//  Created by Doug on 11/13/14.
//  Copyright (c) 2014 Doug Roeper. All rights reserved.
//

#import "ViewController.h"

#import "PageParser.h"

#import "Common.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeKeyboard:(id)sender
{
    [self.url resignFirstResponder];
}

-(IBAction)parsePage:(id)sender
{
    //make sure we can't press parse more than once
    self.parse.enabled = false;
    //add a nice message to the screen
    self.results.text = @"Parsing...";
    //remove the keyboard
    [self.url resignFirstResponder];
    //run the parse on a separate thread
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(parseThread) userInfo:nil repeats:NO];
}

-(void)parseThread
{
    
#if kSCHOOLS == 1
    NSString *capitalized = [self.url.text lowercaseString];
    capitalized = [capitalized capitalizedString];
    
    NSString *lowercaseFirst = [self.url.text substringToIndex:1];
    lowercaseFirst = [lowercaseFirst lowercaseString];
    
    NSString *urlString = [NSString stringWithFormat:@"http://schools-wikipedia.org/wp/%@/%@.htm", lowercaseFirst, capitalized];
#else
    NSString *urlString = [NSString stringWithFormat:@"http://www.wikipedia.org/wiki/%@", self.url.text];
#endif
    
    NSError *error;
    NSString *webPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    
    if (webPage != nil)
    {
        NSLog(@"Parsing: %@", urlString);
        NSDictionary *words = [PageParser parseString:webPage];
        
        NSMutableString *results = [NSMutableString string];
        NSArray *sorted = [[words allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        for (NSString *word in sorted)
        {
            int count = [[words objectForKey:word] intValue];
            //NSLog(@"%@ - %d", word, count);
            
            [results appendFormat:@"%@ - %d \n", word, count];
        }
        
        self.results.text = results;
        self.wordCount.text = [NSString stringWithFormat:@"%d", (int)[sorted count]];
    }
    else
    {
        self.results.text = @"Error getting page";
    }
    
    self.parse.enabled = true;
}

@end
