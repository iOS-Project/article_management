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
    
    UIRefreshControl *refreshControll;
    
    UISwipeGestureRecognizer *swipeTopToBottom;
    
    // toast
    UIActivityIndicatorView *processIndicator;
    UIView *view;
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set delegate
    self.tableArticle.delegate = self;
    self.tableArticle.dataSource = self;
    
    // add refresh control
    refreshControll = [[UIRefreshControl alloc] init];
    refreshControll.attributedTitle = [[NSAttributedString alloc] initWithString:@"Getting Data..."];
    [refreshControll addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableArticle addSubview:refreshControll];
    
    cm = [[ConnectionManager alloc] init];
    cm.delegate = self;
    
    // add indicator to view
    [self.subView addSubview:self.indicator];
    // start animate
    [self.indicator startAnimating];
    
    // hide add button
    self.addButton.enabled = false;
    self.addButton.tintColor = [UIColor colorWithRed:(22/255.0) green:(144/255.0) blue:(67/255.0) alpha:1];
    
    // instantiate and setting swipe gesture recognizer
    swipeTopToBottom = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToLogout:)];
    [swipeTopToBottom setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.navigationBar addGestureRecognizer:swipeTopToBottom];
}

-(void)viewDidAppear:(BOOL)animated{
    //[self.tableArticle reloadData];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh:(UIRefreshControl*)refreshControl{
    [self loadData];
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
        [refreshControll endRefreshing];
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

#pragma mark - swipe to logout
-(void)swipeToLogout:(UISwipeGestureRecognizer *)gesture{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Are you sure want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addIndicator:processIndicator withMessage:@"Logging Out..."];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(dismissViewcontroller) withObject:self afterDelay:2.0];
        });
        
    }];
    
    UIAlertAction *canel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:logout];
    [alert addAction:canel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - toast
-(void)addIndicator:(UIActivityIndicatorView*)indicatorView withMessage:(NSString *)message{
    //NSLog(@"add");
    view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, self.view.frame.size.width-100.0, 50.0)];
    view.center = self.view.center;
    view.backgroundColor = [UIColor colorWithRed:(22/255.0) green:(144/255.0) blue:(67/255.0) alpha:1];
    view.layer.cornerRadius = view.frame.size.height/2;
    // activity indicator
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame = CGRectMake(view.frame.origin.x, view.frame.size.height/2-15, 30.0, 30.0);
    indicatorView.hidesWhenStopped = YES;
    
    [view addSubview:indicatorView];
    
    // add message
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(indicatorView.frame.origin.x + 30, indicatorView.frame.origin.y-5, view.frame.size.width-(indicatorView.frame.size.width + 10), 40.0)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:label.font.fontName size:15];
    label.text = message;
    [view addSubview:label];
    
    //[self.view addSubview:view];
    [self.view addSubview:view];
    [indicatorView startAnimating];
}

-(void)dismissViewcontroller{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
