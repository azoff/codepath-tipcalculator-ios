//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Jonathan Azoff on 2/24/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *defaultTipAmount;

- (BOOL)saveDefaultTip:(int)tip;
- (IBAction)onViewTap:(id)sender;

@end

@implementation SettingsViewController

+ (int)defaultTip {
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:DEFAULT_TIP_KEY];
    if (value == nil) return DEFAULT_TIP_VALUE;
    return [value floatValue];
}

- (BOOL)saveDefaultTip:(int)tip {
    
    if (tip < 0 || tip > 30)
        return NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:tip forKey:DEFAULT_TIP_KEY];
    return [defaults synchronize];
    
}

- (IBAction)onViewTap:(id)sender {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.defaultTipAmount.text = [NSString stringWithFormat:@"%d", [SettingsViewController defaultTip]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveDefaultTip:[self.defaultTipAmount.text floatValue]];
}

@end
