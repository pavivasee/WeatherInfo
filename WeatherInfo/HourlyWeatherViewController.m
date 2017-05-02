//
//  HourlyWeatherViewController.m
//  WeatherInfo
//
//  Created by Vijayakumar C on 27/4/17.
//  Copyright (c) 2017 Jabil. All rights reserved.
//

#import "HourlyWeatherViewController.h"
#import "WeatherInfoClient.h"
#import "WeatherInfoTableViewController.h"

@interface HourlyWeatherViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableViewHourlyWeatherInfo;
@property (strong, nonatomic) NSMutableArray *hourlyWeatherInfo;
@property (strong, nonatomic) WeatherInfoTableViewController *tableViewController;
@property (strong, nonatomic) NSString *summary;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationInfo;

@end

@implementation HourlyWeatherViewController


- (id) initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.hourlyWeatherInfo = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeatherInfoDataReceived) name:WIDataReceivedNotification object:nil];

        [self.tabBarItem setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor blueColor], NSFontAttributeName:[UIFont systemFontOfSize:20.0f]} forState:UIControlStateNormal];

    }
    return self;
}

- (void) viewDidLoad{
    
    self.tableViewController = [[WeatherInfoTableViewController alloc] initWithTableView:self.tableViewHourlyWeatherInfo];
    [self WeatherInfoDataReceived];
    [self.tableViewController dataDidChange:self.hourlyWeatherInfo summary:self.summary];
    
    self.lblLocationInfo.backgroundColor = [UIColor clearColor];
    self.lblLocationInfo.numberOfLines = 3;
    self.lblLocationInfo.font = [UIFont boldSystemFontOfSize: 14.0f];
    self.lblLocationInfo.textAlignment = NSTextAlignmentCenter;
    self.lblLocationInfo.textColor = [UIColor blueColor];
    self.lblLocationInfo.backgroundColor = [UIColor grayColor];
    self.lblLocationInfo.backgroundColor =  [UIColor colorWithRed:14.0/255 green:122.0/255 blue:254.0/255 alpha:1.0];

}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar.topItem setTitle:@"Hourly Weather Info"];
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) WeatherInfoDataReceived{
    
    [self.hourlyWeatherInfo removeAllObjects];
    self.summary = [[[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"hourly"] objectForKey:@"summary"];
    NSArray *arrayHourlyData = [[[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"hourly"] objectForKey:@"data"];
    [arrayHourlyData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for (NSString* key in [obj allKeys])
            {
                [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:key,WIKeyKey,
                                                    [NSString stringWithFormat:@"%@",[obj objectForKey:key]], WIKeyValue,nil]];
            }
            [self.hourlyWeatherInfo addObject:array];
        }
    }];
    [self.tableViewController dataDidChange:self.hourlyWeatherInfo summary:self.summary];
    NSString *title = [NSString stringWithFormat:@"latitude %@\nlongitude %@\ntimezone %@",
                       [[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"latitude"],
                       [[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"longitude"],
                       [[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"timezone"]];
    
    
    self.lblLocationInfo.text = title;

}

@end
