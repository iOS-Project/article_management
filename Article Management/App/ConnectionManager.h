//
//  ConnectionManager.h
//  Article Management
//
//  Created by Lun Sovathana on 11/28/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ConnectionManagerDelegate;

@interface ConnectionManager : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate>

@property(nonatomic, weak)id<ConnectionManagerDelegate>delegate;
@property(nonatomic, strong)NSString *basedUrl;

-(void)requestData:(NSDictionary *)dataDictionary withKey:(NSString *)key;
-(void)uploadImage:(UIImage *)image withKey:(NSString *)key;

@end

@protocol ConnectionManagerDelegate <NSObject>

@required
-(void)responseData:(NSDictionary *)dataDictionary;
@optional
-(void)responseImage:(NSDictionary *)dataDictionary;

@end
