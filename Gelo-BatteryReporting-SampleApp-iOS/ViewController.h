//
//  ViewController.h
//  Gelo-BatteryReporting-SampleApp-iOS
//
//  Created by Thomas Peterson on 4/20/15.
//  Copyright (c) 2015 Thomas Peterson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLBeacon.h"

@interface ViewController : UIViewController <CBCentralManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLifeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;

@end

