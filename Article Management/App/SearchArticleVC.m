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
}

@end

@implementation SearchArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set delegate
    self.tableArticle.delegate = self;
    self.tableArticle.dataSource = self;
    self.searchControll.delegate = self;
    
    cm = [[ConnectionManager alloc] init];
    cm.delegate = self;
    
    // add indicator to view
    [self.headerView addSubview:self.searchIndicator];
    
    // focus uisearch
    [self.searchControll becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)searchArticle:(NSString *)keyword{
    NSDictionary *reqData = [[NSDictionary alloc] initWithObjects:@[@"10", @"1"] forKeys:@[@"row", @"pageCount"]];

    [cm requestData:reqData withKey:[NSString stringWithFormat:@"/api/article/search/%@", keyword]];
}

-(void)responseData:(NSDictionary *)dataDictionary{
    
    
    if ([[dataDictionary  valueForKeyPath:@"MESSAGE"] isEqualToString:@"RECORD NOT FOUND"]) {
        // stop animate
        [self.searchIndicator stopAnimating];
        // inform user
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"No article found!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        // show alert
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.searchIndicator stopAnimating];
            // clear data
            data = nil;
            // reload table
            [self.tableArticle reloadData];
            [self presentViewController:alert animated:YES completion:nil];
            [self.searchControll becomeFirstResponder];
        });
        
        
        return;
    }
    
    data = [[NSMutableArray alloc] init];
    // add data to object
    for (NSArray *arr in [dataDictionary objectForKey:@"RES_DATA"]) {
        Article *article = [[Article alloc] initWithObject:arr];
        // add article to collection
        [data insertObject:article atIndex:0];
        //NSLog(@"count: %d", (int)[data count]);
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.searchIndicator stopAnimating];
        [self.tableArticle reloadData];
    });
    //NSLog(@"Data: %@", dataDictionary);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [data count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleCell *cell = [self.tableArticle dequeueReusableCellWithIdentifier:@"articleCell" forIndexPath:indexPath];
    cell.titleLabel.text = [[data objectAtIndex:indexPath.row] artTitle];
    cell.descriptionLabel.text = [[data objectAtIndex:indexPath.row] artDescription];
    cell.publishDateLabel.text = [[data objectAtIndex:indexPath.row] artPublishDate];
    //cell.imageView.image = [UIImage imageNamed:[[[data objectForKey:@"RES_DATA"] objectAtIndex:indexPath.row] valueForKeyPath:@"image"]];
    cell.imageView.image = [UIImage imageNamed:@"default.jpg"];
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
