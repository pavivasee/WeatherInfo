//
//  WeatherInfaTableViewController.h
//  WeatherInfo
//
//  Created by Vijayakumar C on 28/4/17.
//  Copyright (c) 2017 Jabil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherInfoTableViewController : NSObject<UITableViewDelegate, UITableViewDataSource>

- (id) initWithTableView:(UITableView*)tableView;
- (void) dataDidChange:(NSArray*)weatherInfo summary:(NSString*)summary;

@end
