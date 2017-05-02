//
//  WeatherInfaTableViewController.m
//  WeatherInfo
//
//  Created by Vijayakumar C on 28/4/17.
//  Copyright (c) 2017 Jabil. All rights reserved.
//

#import "WeatherInfoTableViewController.h"

@interface WeatherInfoTableViewController ()

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *summary;

@property (strong,nonatomic) UITableView *tableView;
@end

@implementation WeatherInfoTableViewController


- (id) initWithTableView:(UITableView*)tableView{
    self = [super init];
    if (self) {
        self.data = [[NSArray alloc] init];
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}


- (void) dataDidChange:(NSArray*)weatherInfo summary:(NSString*)summary{
    
    self.data = [NSArray arrayWithArray:weatherInfo];
    self.summary = summary;
    
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.data objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    CGSize maxSize = CGSizeMake(300, 1000);
    int height = 0;
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont boldSystemFontOfSize:20], NSFontAttributeName,
                                          nil];
    
    CGRect frame = [self.summary boundingRectWithSize:maxSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributesDictionary
                                              context:nil];
    height = frame.size.height;
    return height+5;
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    view.tintColor = [UIColor grayColor];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGRect frame = [self.summary boundingRectWithSize:CGSizeMake(300, 1000)
                                              options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}
                                              context:nil];
    
    UIView *wrapper = [[UIView alloc] initWithFrame:frame];
    [wrapper setBackgroundColor:[UIColor grayColor]];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
    textLabel.text = self.summary;
    [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [textLabel setNumberOfLines:0];
    
    [wrapper addSubview:textLabel];
    
    return wrapper;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section % 2 == 0)
        cell.backgroundColor = [UIColor lightGrayColor];
    else
        cell.backgroundColor = [UIColor lightTextColor];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CurrentTableViewCell"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    
    NSDictionary *dicWeatherInfo = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSString *weatherInfo = [ NSString stringWithString:[NSString stringWithFormat:@"%@ %@" ,[dicWeatherInfo objectForKey:@"key"],[dicWeatherInfo objectForKey:@"value"]  ]];
    
    NSMutableAttributedString *attributedWeatherInfo = [[NSMutableAttributedString alloc] initWithString:weatherInfo];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
    [attributedWeatherInfo setAttributes:attributes range:NSMakeRange(0, [[dicWeatherInfo objectForKey:@"key"] length])];
    
    [cell.textLabel setAttributedText:attributedWeatherInfo];
    
    
    return cell;
}

@end
