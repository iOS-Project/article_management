//
//  ConnectionManager.m
//  Article Management
//
//  Created by Lun Sovathana on 11/28/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "ConnectionManager.h"

@interface ConnectionManager(){
    
}

@end

@implementation ConnectionManager

-(id)init{
    self = [super init];
    if (self != nil) {
        self.basedUrl = @"http://hrdams.herokuapp.com";
    }
    return self;
}

-(void)requestData:(NSDictionary *)dataDictionary withKey:(NSString *)key{
    // create url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.basedUrl, key]];
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
        if (data.length>0) {
            // convert json data to dictionary
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //NSLog(@"%@", dictionaryData);
            [self.delegate responseData:dataDictionary];
        }
        
    }];
    [task resume];
    
}

-(void)uploadImage:(UIImage *)image withKey:(NSString *)key{
    // url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.basedUrl, key]];
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

    // image
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    //[request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"imageFormKey"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //NSLog(@"Post Length: %lu", (unsigned long)[body length]);
    
    // create session
    NSURLSession *session = [NSURLSession sharedSession];
    // create session data task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSLog(@"%@", data);
        if (data.length >0) {
            // convert json data to dictionary
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //NSLog(@"%@", dictionaryData);
            [self.delegate responseImage:dataDictionary];
        }
        
    }];
    [task resume];
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if(data.length > 0)
//        {
//            //success
//        }
//    }];
    
    
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"%@", error);
}

@end
