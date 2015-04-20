//
//  ViewController.m
//  Gelo-BatteryReporting-SampleApp-iOS
//
//  Created by Thomas Peterson on 4/20/15.
//  Copyright (c) 2015 Thomas Peterson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property CBCentralManager *centralManager;
@property BLBeacon *nearestBeacon;
@property NSTimer *scanBurstTimer;
@property NSDictionary *centralOption;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centralOption = @{CBCentralManagerScanOptionAllowDuplicatesKey : [NSNumber numberWithBool:YES]};
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
}

- (void)scanBurst:(NSTimer *)timer {
    //Giving the central manager a servuice UUID is required for background scanning.
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"E0BC0FA5-57CF-0392-7E40-C44E094FE411"]] options:self.centralOption];
    self.scanBurstTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(pauseScanBurst:) userInfo:nil repeats:NO];
}

- (void)pauseScanBurst:(NSTimer *)timer {
    [self.centralManager stopScan];
    self.scanBurstTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scanBurst:) userInfo:nil repeats:NO];
}

#pragma mark - CBCentralManagerDelegate methods

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    BLBeacon *beacon = [[BLBeacon alloc] initWithData:[advertisementData objectForKey:@"kCBAdvDataManufacturerData"] signalStrength:[RSSI integerValue]];
    
    //Ensure that the central manager is reporting a valid RSSI.
    if (beacon.rssi < 0) {
        if (!self.nearestBeacon || beacon.rssi >= self.nearestBeacon.rssi) {
            self.nearestBeacon = beacon;
            [self updateViewLabels:self.nearestBeacon];
        }
        
        if ([self.nearestBeacon isEqual:beacon]) {
            [self.nearestBeacon updateRSSI:beacon.rssi];
        }
    }
}

- (void)updateViewLabels:(BLBeacon *)beacon {
    [self.majorLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)beacon.major]];
    [self.minorLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)beacon.minor]];
    [self.batteryLifeLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)beacon.batteryLife]];
    [self.rssiLabel setText:[NSString stringWithFormat:@"%ld", (long)beacon.rssi]];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStateUnsupported:
            NSLog(@"The platform doesn't support the Bluetooth Low Energy Central/Client role.");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"Bluetooth is currently powered off.");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"Bluetooth is currently powered on and available to use.");
            
            //Start scanning for beacons after we confirm bluetooth is on and available.
            [self scanBurst:nil];
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"The application is not authorized to use the Bluetooth Low Energy Central/Client role.");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"The connection with the system service was momentarily lost, update imminent.");
            break;
        default:
            NSLog(@"Unknown bluetooth state encountered...");
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
