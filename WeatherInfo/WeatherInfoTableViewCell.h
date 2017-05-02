//
//  WeatherInfoTableViewCell.h
//  WeatherInfo
//
//  Created by Vijayakumar C on 27/4/17.
//  Copyright (c) 2017 Jabil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherInfoTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *keyLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

@end
