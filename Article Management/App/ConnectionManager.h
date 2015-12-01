//
//  ConnectionManager.h
//  Article Management
//
//  Created by Lun Sovathana on 11/28/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionManagerDelegate;

@interface ConnectionManager : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate>

@property(nonatomic, weak)id<ConnectionManagerDelegate>delegate;

-(void)requestData:(NSDictionary *)dataDictionary withKey:(NSString *)key;

@end

@protocol ConnectionManagerDelegate <NSObject>

@required
-(void)responseData:(NSDictionary *)dataDictionary;

@end
