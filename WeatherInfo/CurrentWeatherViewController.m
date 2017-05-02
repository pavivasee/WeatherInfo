//
//  ViewController.m
//  WeatherInfo
//
//  Created by Vijayakumar C on 27/4/17.
//  Copyright (c) 2017 Jabil. All rights reserved.
//

#import "CurrentWeatherViewController.h"
#import "WeatherInfoClient.h"
#import "WeatherInfoTableViewCell.h"

@interface CurrentWeatherViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) NSDictionary *location;
@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *currentWeatherInfo;

@property (weak, nonatomic) IBOutlet UITableView *tableViewCurrentWeatherInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationInfo;

- (void) fetachWeatherInfo;

@end

@implementation CurrentWeatherViewController

- (id) initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.currentWeatherInfo = [[NSMutableArray alloc] init];
        self.location = [[NSDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeatherInfoDataReceived) name:WIDataReceivedNotification object:nil];

        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];

        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];

        [self.tabBarItem setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor blueColor],
                                                   NSFontAttributeName: [UIFont systemFontOfSize:20.0f]} forState:UIControlStateNormal];

    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [ self.navigationController.navigationBar setTitleTextAttributes :@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25], NSForegroundColorAttributeName:[UIColor blueColor]}];

    self.navigationController.navigationBar.topItem.rightBarButtonItem =
                                                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                            target:self/*[[UIApplication sharedApplication] delegate]*/
                                                            action:@selector(fetachWeatherInfo)];
    self.tableViewCurrentWeatherInfo.delegate = self;
    self.tableViewCurrentWeatherInfo.dataSource = self;

    self.lblLocationInfo.backgroundColor = [UIColor clearColor];
    self.lblLocationInfo.numberOfLines = 3;
    self.lblLocationInfo.font = [UIFont boldSystemFontOfSize: 14.0f];
    self.lblLocationInfo.textAlignment = NSTextAlignmentCenter;
    self.lblLocationInfo.textColor = [UIColor blueColor];
    self.lblLocationInfo.backgroundColor =  [UIColor colorWithRed:14.0/255 green:122.0/255 blue:254.0/255 alpha:1.0];
    
    [self fetachWeatherInfo];

}

- (void) viewWillAppear:(BOOL)animated{

    [self.navigationController.navigationBar.topItem setTitle:@"Current Weather Info"];
    
}

- (void) dealloc{

    [self.locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations objectAtIndex:0];
    
    if (currentLocation != nil) {
        NSString *latitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
        
        if ( ![latitude isEqualToString:[self.location objectForKey:WIKeyLatitude]] ||
             ![longitude isEqualToString:[self.location objectForKey:WIKeyLongitude]]) {

            NSDictionary *location = @{ WIKeyLatitude : latitude,
                                        WIKeyLongitude : longitude };
            self.location = location;
            [self fetachWeatherInfo];
            
        }
     }
 }

-(void) fetachWeatherInfo{
    
    [[WeatherInfoClient sharedWeatherInfoClient] requestWeatherInfoBasedOnCoordinate:CLLocationCoordinate2DMake([[self.location objectForKey:WIKeyLatitude] floatValue], [[self.location objectForKey:WIKeyLongitude] floatValue]) completion:^(BOOL status, id info) {

        if (status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:WIDataReceivedNotification object:nil];
        }
        
    }];
    
}

-(void)WeatherInfoDataReceived{
    
    [self.currentWeatherInfo removeAllObjects];
    NSDictionary *dictWeatherInfo = [[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"currently"];
    
    for (NSString* key in [dictWeatherInfo allKeys])
    {
        [self.currentWeatherInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:key,WIKeyKey,
                                            [NSString stringWithFormat:@"%@",[dictWeatherInfo objectForKey:key]], WIKeyValue,nil]];
    }
    [self.tableViewCurrentWeatherInfo reloadData];
    
    NSString *title = [NSString stringWithFormat:@"latitude %@\nlongitude %@\ntimezone %@",
                       [[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"latitude"],
                       [[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"longitude"],
                       [[[WeatherInfoClient sharedWeatherInfoClient] response] objectForKey:@"timezone"]];


    self.lblLocationInfo.text = title;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor grayColor];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.currentWeatherInfo count];
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor lightGrayColor];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CurrentTableViewCell"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
        
    }
    NSDictionary *dicWeatherInfo = [self.currentWeatherInfo objectAtIndex:indexPath.row];
    
    NSString *weatherInfo = [ NSString stringWithString:[NSString stringWithFormat:@"%@ %@" ,[dicWeatherInfo objectForKey:WIKeyKey],[dicWeatherInfo objectForKey:WIKeyValue]  ]];
    
    NSMutableAttributedString *attributedWeatherInfo = [[NSMutableAttributedString alloc] initWithString:weatherInfo];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
    [attributedWeatherInfo setAttributes:attributes range:NSMakeRange(0, [[dicWeatherInfo objectForKey:WIKeyKey] length])];

    [cell.textLabel setAttributedText:attributedWeatherInfo];
    return cell;
}

@end
