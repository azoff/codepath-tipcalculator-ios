//
//  TipViewController.m
//  tipcalculator
//
//  Created by Jonathan Azoff on 2/17/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipSelectionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipSelectionSegment;
@property (weak, nonatomic) IBOutlet UISlider *tipSelectionSlider;
@property (weak, nonatomic) IBOutlet UILabel *tipTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipTotalHelperLabel;
@property (weak, nonatomic) IBOutlet UILabel *billTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *billTotalHelperLabel;

- (IBAction)onSegmentChanged;
- (IBAction)onBillAmountChanged;
- (IBAction)onViewTap:(id)sender;
- (IBAction)updateValues;
- (void) animateHelperAlpha:(int)alpha;
- (void) animateHelperAlpha:(int)alpha withDuration:(float)duration;

@end

@implementation TipViewController

NSNumberFormatter *formatter;
NSArray *segments;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    segments = @[@(10), @(15), @(20)];
    
    [self animateHelperAlpha:0 withDuration:0];
    
}

- (void)didReceiveMemoryWarning
{
    
    formatter = nil;
    segments = nil;
    
    [super didReceiveMemoryWarning];
    
}

- (IBAction)updateValues
{
    // get tip amount, update label
    int tipAmount = self.tipSelectionSlider.value;
    self.tipSelectionLabel.text = [NSString stringWithFormat:@"%u%% Tip", tipAmount];
    
    // update segment selection
    self.tipSelectionSegment.selectedSegmentIndex = -1;
    for (int index=0; index < segments.count; index++) {
        if (tipAmount == [segments[index] intValue]) {
            self.tipSelectionSegment.selectedSegmentIndex = index;
            break;
        }
    }
    
    // don't update on invalid values
    float billAmount = [self.billTextField.text floatValue];
    if (billAmount < 0) return;
    
    // calculate tip total
    float f_tipTotal = tipAmount/100.0*billAmount;
    NSNumber *tipTotal = [[NSNumber alloc] initWithFloat:f_tipTotal];
    self.tipTotalLabel.text = [formatter stringFromNumber:tipTotal];
    
    // calculate bill total
    NSNumber *billTotal = [[NSNumber alloc] initWithFloat:(f_tipTotal+billAmount)];
    self.billTotalLabel.text = [formatter stringFromNumber:billTotal];
    
}

- (IBAction)onBillAmountChanged {
    [self animateHelperAlpha:1];
    [self updateValues];
}

- (IBAction)onSegmentChanged {
    self.tipSelectionSlider.value = [segments[self.tipSelectionSegment.selectedSegmentIndex] floatValue];
    [self updateValues];
}

- (IBAction)onViewTap:(id)sender {
    [self.view endEditing:YES];
}

- (void) animateHelperAlpha:(int)alpha {
    [self animateHelperAlpha:alpha withDuration:0.75];
}

- (void)animateHelperAlpha:(int)alpha withDuration:(float)duration {
    [UIView animateWithDuration:duration animations:^(void) {
        self.tipTotalLabel.alpha  = alpha;
        self.billTotalLabel.alpha = alpha;
        self.tipTotalHelperLabel.alpha = alpha;
        self.billTotalHelperLabel.alpha = alpha;
    }];
}

@end
