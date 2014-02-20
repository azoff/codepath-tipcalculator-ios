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
@property (weak, nonatomic) IBOutlet UILabel *tipHelperLabel;

- (IBAction)onTap:(id)sender;
- (void)updateValues;

@end

@implementation TipViewController

#define SEGMENT_COUNT 3
NSNumberFormatter *formatter;
int segments[SEGMENT_COUNT] = {10, 15, 20};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tip Calc";
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return self;
}

- (void)finalize {
    free(segments);
    [super finalize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateValues
{
    // get tip amount, update label
    int tipAmount = self.tipSelectionSlider.value;
    self.tipSelectionLabel.text = [NSString stringWithFormat:@"%u%% Tip", tipAmount];
    
    // update segment selection
    for (int index=0; index < SEGMENT_COUNT; index++) {
        if (tipAmount == segments[index]) {
            self.tipSelectionSegment.selectedSegmentIndex = index;
            break;
        }
    }
    
    // hide or show the total based off of the bill amount
    float billAmount = [self.billTextField.text floatValue];
    if (billAmount <= 0) {
        self.tipTotalLabel.alpha  = 0;
        self.tipHelperLabel.alpha = 0;
        return;
    } else {
        self.tipTotalLabel.alpha  = 1;
        self.tipHelperLabel.alpha = 1;
    }
    
    // calculate the total
    NSNumber *total = [[NSNumber alloc] initWithFloat:((tipAmount/100.0)*billAmount)];
    self.tipTotalLabel.text = [formatter stringFromNumber:total];
    
}

- (IBAction)onTap:(id)sender
{
    [self.view endEditing:YES];
    [self updateValues];
}

@end
