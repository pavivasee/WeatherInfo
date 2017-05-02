//
//  WeatherInfoClient.m
//  WeatherInfo
//
//  Created by Vijayakumar C on 27/4/17.
//  Copyright (c) 2017 Jabil. All rights reserved.
//

#import "WeatherInfoClient.h"

@implementation WeatherInfoClient

+(WeatherInfoClient*)sharedWeatherInfoClient{
    static WeatherInfoClient *_sharedWeatherInfoClient = nil;
    
    static dispatch_once_t dispatch_t;
    dispatch_once(&dispatch_t, ^{
        _sharedWeatherInfoClient = [[ WeatherInfoClient alloc] init];
        _sharedWeatherInfoClient  = [_sharedWeatherInfoClient initWithBaseURL:[WeatherInfoClient baseURL]];
        
        
    });
    return _sharedWeatherInfoClient;
}

+(NSURL*)baseURL{
    return [NSURL URLWithString:
            [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/", WIKeyAPI]];
}

-(id) initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if(self){
        [self setDefaultHeader:@"Accept" value:@"Application/json"];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return self;
}

-(void) requestWeatherInfoBasedOnCoordinate:(CLLocationCoordinate2D)coordinate completion:(WeatherInfoRequestCompletionBlock)completion{
    NSString *path = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self setResponse:[NSJSONSerialization
                              JSONObjectWithData:responseObject
                              options:NSJSONReadingMutableLeaves
                              error:nil]];
       // NSLog(@"%@", self.response);
        completion(YES, self.response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO, nil);
    }];
}











@end
