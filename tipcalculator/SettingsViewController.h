//
//  SettingsViewController.h
//  tipcalculator
//
//  Created by Jonathan Azoff on 2/24/14.
//  Copyright (c) 2014 Jonathan Azoff. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_TIP_KEY   @"tipSelectionSlider.value"
#define DEFAULT_TIP_VALUE 15

@interface SettingsViewController : UIViewController

+ (int)defaultTip;

@end
