//
//  ViewController.h
//  WordLister
//
//  Created by Doug on 11/13/14.
//  Copyright (c) 2014 Doug Roeper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, retain)IBOutlet UITextField *url;
@property (nonatomic, retain)IBOutlet UITextView *results;
@property (nonatomic, retain)IBOutlet UILabel *wordCount;
@property (nonatomic, retain)IBOutlet UIButton *parse;
@property (nonatomic, retain)IBOutlet UISegmentedControl *webpage;

-(IBAction)closeKeyboard:(id)sender;


@end

