//
//  SearchArticleVC.h
//  Article Management
//
//  Created by Lun Sovathana on 11/29/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchArticleVC : UIViewController
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchControll;
@property (weak, nonatomic) IBOutlet UITableView *tableArticle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchIndicator;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end
