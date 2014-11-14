//
//  ViewController.m
//  WordLister
//
//  Created by Doug on 11/13/14.
//  Copyright (c) 2014 Doug Roeper. All rights reserved.
//

#import "ViewController.h"

#import "PageParser.h"

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
    self.parse.enabled = false;
    self.results.text = @"Parsing...";
    [self.url resignFirstResponder];
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(parseThread) userInfo:nil repeats:NO];
}

-(void)parseThread
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.wikipedia.org/wiki/%@", self.url.text];
    
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
