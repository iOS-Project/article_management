//
//  Article.h
//  Article Management
//
//  Created by Lun Sovathana on 11/30/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Article : NSObject
@property(strong, nonatomic)NSNumber* artID;
@property(strong, nonatomic)NSString* artTitle;
@property(strong, nonatomic)NSString* artDescription;
@property(strong, nonatomic)NSString* artPublishDate;
@property(strong, nonatomic)UIImage* artImage;
@property(strong, nonatomic)NSString* artImageURL;
@property(strong, nonatomic)NSNumber* userID;
@property BOOL enable;

-(id)initWithObject:(NSArray*)array;
@end
