//
//  ConnectionManager.m
//  Article Management
//
//  Created by Lun Sovathana on 11/28/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "ConnectionManager.h"

@implementation ConnectionManager

-(void)requestData:(NSDictionary *)dataDictionary withKey:(NSString *)key{
    // create url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hrdams.herokuapp.com%@", key]];
    //NSURL *url = [NSURL URLWithString:@"http://api.senate.gov.kh/index.php/api"];
    // create url request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // set method for request
    request.HTTPMethod = @"POST";
    // set content type
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // convert dictionary to json data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDictionary options:0 error:nil];
    // convert data to string with encoding utf-8
    NSString *stringData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSString *stringFormat= [NSString stringWithFormat:@"%@", stringData];
    // convert string with utf-8 encoding to json data
    NSData *jsonDataBody = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    // set body data
    request.HTTPBody = jsonDataBody;
    // create session
    NSURLSession *session = [NSURLSession sharedSession];
    // create session data task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        // convert json data to dictionary
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //NSLog(@"%@", dictionaryData);
        [self.delegate responseData:dataDictionary];
    }];
    [task resume];
    
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"%@", error);
}

@end
