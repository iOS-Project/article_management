//
//  User.h
//  Article Management
//
//  Created by Lun Sovathana on 12/3/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property(strong, nonatomic)NSNumber *uID;
@property(strong, nonatomic)NSString *username;
@property(strong, nonatomic)NSString *password;
@property(strong, nonatomic)NSString *roles;
@property BOOL enabled;
@property(strong, nonatomic)UIImage *photo;
@property(strong, nonatomic)NSString *photoUrl;
@property(strong, nonatomic)NSString *registerDate;

// constructor
-(id)initWithObject:(NSArray*)user;

@end
