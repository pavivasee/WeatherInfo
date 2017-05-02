//
//  WeatherInfoTableViewCell.m
//  WeatherInfo
//
//  Created by Vijayakumar C on 27/4/17.
//  Copyright (c) 2017 Jabil. All rights reserved.
//

#import "WeatherInfoTableViewCell.h"

@implementation WeatherInfoTableViewCell
@synthesize keyLabel = _keyLabel,valueLabel = _valueLabel;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
