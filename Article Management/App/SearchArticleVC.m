//
//  SearchArticleVC.m
//  Article Management
//
//  Created by Lun Sovathana on 11/29/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "SearchArticleVC.h"
#import "ConnectionManager.h"
#import "ArticleCell.h"
#import "Article.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SearchArticleVC ()<UITableViewDataSource, UITableViewDelegate, ConnectionManagerDelegate, UISearchBarDelegate>{
    ConnectionManager *cm;
    NSMutableArray<Article *>*data;
    
    // variable for pagination
    int currentPage;
    int row;
    int totalRecord;
    
    UIRefreshControl *refreshControll;
    // indicator for pagination
    UIActivityIndicatorView *indicatorFooter;
}

@end

@implementation SearchArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set delegate
    self.tableArticle.delegate = self;
    self.tableArticle.dataSource = self;
    self.searchControll.delegate = self;
    
    data = [[NSMutableArray alloc] init];
    
    // define default value for pagination
    currentPage = 1;
    row = 10;
    
    // add refresh control
    [self headerRefreshControl];
    
    
    cm = [[ConnectionManager alloc] init];
    cm.delegate = self;
    
    // add indicator to view
    [self.headerView addSubview:self.searchIndicator];
    
    // focus uisearch
    [self.searchControll becomeFirstResponder];
    
}

#pragma mark - initialize block

/*
 * initialization refresh control for refresh data
 */
-(void)headerRefreshControl{
    refreshControll = [[UIRefreshControl alloc] init];
    refreshControll.attributedTitle = [[NSAttributedString alloc] initWithString:@"Getting Data"];
    [refreshControll addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableArticle addSubview:refreshControll];
}

/*
 * initialization block for indicator view of the pagination
 */
-(void)footerRefreshControl{
    indicatorFooter = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableArticle.frame), 44)];
    [indicatorFooter setColor:[UIColor blackColor]];
    [indicatorFooter startAnimating];
    [self.tableArticle setTableFooterView:indicatorFooter];
}

-(void)refresh:(UIRefreshControl*)refreshControl{
    [self searchArticle:self.searchControll.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)searchArticle:(NSString *)keyword{
    [self footerRefreshControl];
    NSDictionary *reqData = [[NSDictionary alloc] initWithObjects:@[@"10", @"1"] forKeys:@[@"row", @"pageCount"]];

    [cm requestData:reqData withKey:[NSString stringWithFormat:@"/api/article/search/%@", keyword]];
}

#pragma mark - request data block

-(void)responseData:(NSDictionary *)dataDictionary{
    
    
//    if ([[dataDictionary  valueForKeyPath:@"MESSAGE"] isEqualToString:@"RECORD NOT FOUND"]) {
//        // stop animate
//        [self.searchIndicator stopAnimating];
//        // inform user
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"No article found!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:ok];
//        // show alert
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            [self.searchIndicator stopAnimating];
//            // clear data
//            data = nil;
//            [refreshControll endRefreshing];
//            // reload table
//            [self.tableArticle reloadData];
//            [self presentViewController:alert animated:YES completion:nil];
//            [self.searchControll becomeFirstResponder];
//        });
//        
//        
//        return;
//    }
//    
//    data = [[NSMutableArray alloc] init];
//    // add data to object
//    for (NSArray *arr in [dataDictionary objectForKey:@"RES_DATA"]) {
//        Article *article = [[Article alloc] initWithObject:arr];
//        // add article to collection
//        [data insertObject:article atIndex:0];
//        //NSLog(@"count: %d", (int)[data count]);
//    }
//    dispatch_async(dispatch_get_main_queue(), ^(void){
//        [self.searchIndicator stopAnimating];
//        [self.tableArticle reloadData];
//    });
    if ([[dataDictionary objectForKey:@"MESSAGE"] isEqualToString:@"RECORD NOT FOUND"]) {
        return;
    }else{
        // set total record
        totalRecord = (int)[dataDictionary objectForKey:@"TOTAL_REC"];
        // add data to object
        for (NSArray *arr in [dataDictionary objectForKey:@"RES_DATA"]) {
            Article *article = [[Article alloc] initWithObject:arr];
            // add article to collection
            [data insertObject:article atIndex:0];
            //NSLog(@"%i", (int)[data count]);
        }
        
        // if no record return
        if ([data count] == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"No article found...['" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                return;
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [refreshControll endRefreshing];
            [self.tableArticle reloadData];
            
        });
    }
}

- (void)downloadImageInBackground:(Article *)article forIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(concurrentQueue, ^{
        __block NSData *dataImage = nil;
        
        dispatch_sync(concurrentQueue, ^{
            NSURL *urlImage = [NSURL URLWithString:article.artImageURL];
            dataImage = [NSData dataWithContentsOfURL:urlImage];
        });
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UITableViewCell *cell = [self.tableArticle cellForRowAtIndexPath:indexPath];
            UIImage *image = [UIImage imageWithData:dataImage];
            data[indexPath.row].artImage = image;
            cell.imageView.image = image;
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [data count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleCell *cell = [self.tableArticle dequeueReusableCellWithIdentifier:@"articleCell" forIndexPath:indexPath];
    if ([[[data objectAtIndex:indexPath.row] artTitle] isKindOfClass:[NSNull class]]) {
        cell.titleLabel.text = @"";
    }else{
        cell.titleLabel.text = [[data objectAtIndex:indexPath.row] artTitle];
    }
    
    if ([[[data objectAtIndex:indexPath.row] artDescription] isKindOfClass:[NSNull class]]) {
        cell.descriptionLabel.text = @"";
    }else{
        cell.descriptionLabel.text = [[data objectAtIndex:indexPath.row] artDescription];
    }
    
    if ([[[data objectAtIndex:indexPath.row] artPublishDate] isKindOfClass:[NSNull class]]) {
        cell.publishDateLabel.text = @"";
    }else{
        cell.publishDateLabel.text = [[data objectAtIndex:indexPath.row] artPublishDate];
    }
    
    
    if (data[indexPath.row].artImage) {
        // set the article image
        cell.imageView.image = data[indexPath.row].artImage;
    }else{
        // set default picture
        cell.imageView.image = [UIImage imageNamed:@"default.jpg"];
        // download image in background
        [self downloadImageInBackground:data[indexPath.row] forIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - Search Block
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //NSLog(@"search : %@", searchBar.text);
    // start animate
    [self.searchIndicator startAnimating];
    [self searchArticle:searchBar.text];
    
    
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchControll resignFirstResponder];
}

#pragma mark - Navigation

-(void)refreshTableVeiwList
{
    //Code here
    [self.tableArticle setContentOffset:(CGPointMake(0,self.tableArticle.contentOffset.y-indicatorFooter.frame.size.height)) animated:YES];
    if (currentPage < [self getTotalPage]) {
        currentPage++;
    }else{
        //.attributedTitle = [[NSAttributedString alloc] initWithString:@"Getting Data"];
    }
    
    // load data
    [self searchArticle:self.searchControll.text];
}
-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height)
    {
        [self refreshTableVeiwList];
    }
}

-(int)getTotalPage{
    return totalRecord/row;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
