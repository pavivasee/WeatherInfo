//
//  WeatherInfoClient.h
//  WeatherInfo
//
//  Created by Vijayakumar C on 27/4/17.
//  Copyright (c) 2017 Jabil. All rights reserved.
//
#import <AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherInfoConstants.h"


typedef  void (^WeatherInfoRequestCompletionBlock)(BOOL status, id info);

@interface WeatherInfoClient : AFHTTPClient

@property(strong, nonatomic) NSDictionary *response;

+(WeatherInfoClient*)sharedWeatherInfoClient;

-(void)requestWeatherInfoBasedOnCoordinate:(CLLocationCoordinate2D)coordinate completion:(WeatherInfoRequestCompletionBlock)completion;

@end
