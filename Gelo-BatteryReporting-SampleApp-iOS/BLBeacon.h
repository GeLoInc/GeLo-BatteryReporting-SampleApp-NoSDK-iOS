//
//  BLBeacon.h
//  Gelo-BatteryReporting-SampleApp-iOS
//
//  Created by Thomas Peterson on 4/20/15.
//  Copyright (c) 2015 Thomas Peterson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLBeacon : NSObject

@property NSUInteger major;
@property NSUInteger minor;
@property NSUInteger batteryLife;
@property NSInteger rssi;
@property NSUInteger identifier;

- (id)initWithData:(NSData *)data signalStrength:(NSInteger)signal;
- (void)updateRSSI:(NSInteger)newRSSI;

@end
