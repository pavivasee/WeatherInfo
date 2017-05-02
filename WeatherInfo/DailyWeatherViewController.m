//
//  DailyWeatherViewController.m
//  WeatherInfo
//
//  Created by Vijayakumar C on 27/4/17.
//  Copyright (c) 2017 Jabil. All rights reserved.
//

#import "DailyWeatherViewController.h"
#import "WeatherInfoClient.h"
#import "WeatherInfoTableViewController.h"
@interface DailyWeatherViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableViewDailyWeatherInfo;
@property (strong, nonatomic) NSMutableArray *dailyWeatherInfo;
@property (strong, nonatomic) NSString *summary;

@property (strong, nonatomic) WeatherInfoTableViewController *tableViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationInfo;

@end

@implementation DailyWeatherViewController

- (id) initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.dailyWeatherInfo = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeatherInfoDataReceived) name:WIDataReceivedNotification object:nil];
        
        [self.tabBarItem setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor blueColor], NSFontAttributeName: [UIFont fontWithName:@"Arial" size:20]} forState:UIControlStateNormal];

    }
    return self;
}

- (void) viewDidLoad{
    
    self.tableViewController = [[WeatherInfoTableViewController alloc] initWithTableView:self.tableViewDailyWeatherInfo];
    [self WeatherInfoDataReceived];
    [self.tableViewController dataDidChange:self.dailyWeatherInfo summary:self.summary];
    
    self.lblLocationInfo.backgroundColor = [UIColor clearColor];
    self.lblLocationInfo.numberOfLines = 3;
    self.lblLocationInfo.font = [UIFont boldSystemFontOfSize: 14.0f];
    self.lblLocationInfo.textAlignment = NSTextAlignmentCenter;
    self.lblLocationInfo.textColor = [UIColor blueColor];
    self.lblLocationInfo.backgroundColor = [UIColor grayColor];
    self.lblLocationInfo.backgroundColor =  [UIColor colorWithRed:14.0/255 green:122.0/255 blue:254.0/255 alpha:1.0];

    
}

-(void) viewWillAppear:(BOOL)animated{
 
    [self.navigationController.navigationBar.topItem setTitle:@"Daily Weather Info"];
}

- (void) dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) WeatherInfoDataReceived{
    
    NSArray *arrayHourlyData = [[[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"daily"] objectForKey:@"data"];
    
    self.summary = [[[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"daily"] objectForKey:@"summary"];
    
    [self.dailyWeatherInfo removeAllObjects];
    [arrayHourlyData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for (NSString* key in [obj allKeys])
            {
                [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:key,WIKeyKey,
                                  [NSString stringWithFormat:@"%@",[obj objectForKey:key]], WIKeyValue,nil]];
            }
            [self.dailyWeatherInfo addObject:array];
        }
    }];
    
    [self.tableViewController dataDidChange:self.dailyWeatherInfo summary:self.summary];
    
    NSString *title = [NSString stringWithFormat:@"latitude %@\nlongitude %@\ntimezone %@",
                       [[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"latitude"],
                       [[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"longitude"],
                       [[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"timezone"]];
    
    
    self.lblLocationInfo.text = title;
    
}

@end
