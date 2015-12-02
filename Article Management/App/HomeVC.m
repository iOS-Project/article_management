//
//  HomeVC.m
//  Article Management
//
//  Created by Lun Sovathana on 11/28/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "HomeVC.h"
#import "ConnectionManager.h"
#import "ArticleCell.h"
#import "DetailArticleVC.h"
#import "Article.h"

@interface HomeVC ()<ConnectionManagerDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray<Article *>*data;
    ConnectionManager *cm;
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set delegate
    self.tableArticle.delegate = self;
    self.tableArticle.dataSource = self;
    
    cm = [[ConnectionManager alloc] init];
    cm.delegate = self;
    
    // add indicator to view
    [self.subView addSubview:self.indicator];
    // start animate
    [self.indicator startAnimating];
    
    // hide add button
    self.addButton.enabled = false;
    self.addButton.tintColor = [UIColor colorWithRed:(22/255.0) green:(144/255.0) blue:(67/255.0) alpha:1];
}

-(void)viewDidAppear:(BOOL)animated{
    //[self.tableArticle reloadData];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    NSDictionary *reqData = [[NSDictionary alloc] initWithObjects:@[@"10", @"1"] forKeys:@[@"row", @"pageCount"]];
    
    
        [cm requestData:reqData withKey:@"/api/article/hrd_r001"];
   
}

-(void)responseData:(NSDictionary *)dataDictionary{

    data = [[NSMutableArray alloc] init];
    // add data to object
    for (NSArray *arr in [dataDictionary objectForKey:@"RES_DATA"]) {
        Article *article = [[Article alloc] initWithObject:arr];
        // add article to collection
        [data insertObject:article atIndex:0];
        //NSLog(@"count: %d", (int)[data count]);
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
        [self.indicator stopAnimating];
        self.addButton.enabled = YES;
        self.addButton.tintColor = [UIColor whiteColor];
        [self.tableArticle reloadData];
    });
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == ((NSIndexPath*)[[self.tableArticle indexPathsForVisibleRows] lastObject]).row) {
        [self.indicator stopAnimating];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"%i", count);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detailArticleSegue" sender:[data objectAtIndex:indexPath.row]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailArticleSegue"]) {
        DetailArticleVC *detail = segue.destinationViewController;
        detail.data = sender;
    }
}


- (IBAction)openSearch:(id)sender {
    [self performSegueWithIdentifier:@"searchSegue" sender:nil];
}
- (IBAction)addArticle:(id)sender {
    [self performSegueWithIdentifier:@"addArticleSegue" sender:nil];
}
@end
