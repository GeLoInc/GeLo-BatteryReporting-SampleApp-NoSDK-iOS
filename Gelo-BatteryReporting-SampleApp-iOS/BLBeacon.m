//
//  BLBeacon.m
//  Gelo-BatteryReporting-SampleApp-iOS
//
//  Created by Thomas Peterson on 4/20/15.
//  Copyright (c) 2015 Thomas Peterson. All rights reserved.
//

#import "BLBeacon.h"

@implementation BLBeacon

- (id)initWithData:(NSData *)data signalStrength:(NSInteger)signal {
    if (self = [super init]) {
        NSUInteger major = 0;
        NSUInteger minor = 0;
        NSUInteger bl = 0;
        [data getBytes:&major range:NSMakeRange(sizeof(uint16_t), sizeof(uint16_t))];
        [data getBytes:&minor range:NSMakeRange(sizeof(uint16_t)*2, sizeof(uint16_t))];
        [data getBytes:&bl range:NSMakeRange(sizeof(uint16_t)*3, sizeof(uint8_t))];
        
        self.major = major;
        self.minor = minor;
        self.batteryLife = bl;
        self.rssi = signal;
        self.identifier = (self.major << 16) | (self.minor);
    }
    
    return self;
}

- (void)updateRSSI:(NSInteger)newRSSI {
    self.rssi = newRSSI;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[BLBeacon class]]) {
        BLBeacon *other = object;
        return self.identifier == other.identifier;
    }
    return NO;
}

@end