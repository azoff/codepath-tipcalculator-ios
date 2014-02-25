//
//  TipViewController.m
//  tipcalculator
//
//  Created by Jonathan Azoff on 2/17/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipSelectionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipSelectionSegment;
@property (weak, nonatomic) IBOutlet UISlider *tipSelectionSlider;
@property (weak, nonatomic) IBOutlet UILabel *tipTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipTotalHelperLabel;
@property (weak, nonatomic) IBOutlet UILabel *billTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *billTotalHelperLabel;

@property (readonly, nonatomic) NSNumberFormatter *formatter;
@property (readonly, nonatomic) NSArray *segments;

- (IBAction)onSegmentChanged;
- (IBAction)onBillAmountChanged;
- (IBAction)onViewTap:(id)sender;
- (IBAction)updateValues;
- (void)onSettingsButton;
- (void)animateHelperAlpha:(int)alpha;
- (void)animateHelperAlpha:(int)alpha withDuration:(float)duration;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tips";
        self.edgesForExtendedLayout = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _formatter = [[NSNumberFormatter alloc] init];
    [_formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    _segments = @[@(10), @(15), @(20)];
    
    
    // setup navigation bar
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle: @"\u2699"
                                                    style: UIBarButtonItemStylePlain
                                                    target: self
                                                    action:@selector(onSettingsButton)];
    [btn setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:24.0]}
         forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = btn;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tipSelectionSlider.value = [SettingsViewController defaultTip];
    //NSLog(@"%d", [SettingsViewController defaultTip]);
    [self updateValues];
    [self animateHelperAlpha:0 withDuration:0];
    
}

- (IBAction)updateValues
{
    // get tip amount, update label
    int tipAmount = self.tipSelectionSlider.value;
    self.tipSelectionLabel.text = [NSString stringWithFormat:@"%u%% Tip", tipAmount];
    
    // update segment selection
    self.tipSelectionSegment.selectedSegmentIndex = -1;
    for (int index=0; index < _segments.count; index++) {
        if (tipAmount == [_segments[index] intValue]) {
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
    self.tipTotalLabel.text = [_formatter stringFromNumber:tipTotal];
    
    // calculate bill total
    NSNumber *billTotal = [[NSNumber alloc] initWithFloat:(f_tipTotal+billAmount)];
    self.billTotalLabel.text = [_formatter stringFromNumber:billTotal];
    
}

- (IBAction)onBillAmountChanged {
    [self animateHelperAlpha:1];
    [self updateValues];
}

- (IBAction)onSegmentChanged {
    self.tipSelectionSlider.value = [_segments[self.tipSelectionSegment.selectedSegmentIndex] floatValue];
    [self updateValues];
}

- (IBAction)onViewTap:(id)sender {
    [self.view endEditing:YES];
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)animateHelperAlpha:(int)alpha {
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
