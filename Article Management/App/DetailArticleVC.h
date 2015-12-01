//
//  DetailArticleVC.h
//  Article Management
//
//  Created by Lun Sovathana on 11/29/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface DetailArticleVC : UIViewController

@property Article *data;

- (IBAction)backAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDate;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
- (IBAction)moreAction:(id)sender;

@end
