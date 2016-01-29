//
//  MasterViewController.m
//  CodetestDario
//
//  Created by Dario Carlomagno on 25/01/16.
//  Copyright © 2016 Me. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "NetworkManager.h"
#import "SearchItem.h"
#import "Constants.h"
#import "SeachItemTableViewCell.h"
#import "Utils.h"

@interface MasterViewController () <UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (void)fillItemsWithResults:(NSArray *)results;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // TODO: on ipad, check how to hide master view with animation
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SeachItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    SearchItem *object = self.objects[indexPath.row];
    [cell bindDataWithObject:object];
    
    [[NetworkManager sharedManager] loadImageWithUrl:[object thumbnailUrlString]
                                 andComplentionBlock:^(NSData *imageData) {
                                     if (imageData) {
                                         UIImage *downloadedImage = [UIImage imageWithData:imageData];
                                         [cell updateImage:downloadedImage];
                                         [object.imageCache setObject:downloadedImage forKey:object.thumbnailUrlString];
                                     }
                                 }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.activityIndicator.isAnimating)
        return 50.0f;
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.activityIndicator.isAnimating)
        return self.activityIndicator;
    return nil;
}


#pragma mark - SearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString *searchedSentence = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    // TODO: probably there is a more efficient way to show an indicator view, but this is more quickly
    [self.activityIndicator startAnimating];
    [self.tableView reloadData];
    
    // FEEDBACK from UKCompany
    // Use of ‘self’ within blocks captures self and causes a retain cycle
    // USE __block for ever
    
    __block MasterViewController *_self = self;
    
    [[NetworkManager sharedManager] getItunesMatchedResultsWithQueryString:searchedSentence
                                                       andComplentionBlock:^(NSArray *foundResults, NSError *error) {
                                                           if (error) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   [_self reloadTableAndStopActivityIndicator];
                                                                   [[Utils sharedUtils] showGenericAlertWithMessage:[error localizedDescription]
                                                                                                   inViewController:_self];
                                                               });
                                                           } else {
                                                               // show results
                                                               [_self fillItemsWithResults:foundResults];
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   [_self reloadTableAndStopActivityIndicator];
                                                               });
                                                           }
                                                           
                                                       }];
    [searchBar endEditing:YES];
}

- (void)reloadTableAndStopActivityIndicator {
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
}

- (void)fillItemsWithResults:(NSArray *)results {
    // TODO: probably would be better to port into UI Layer only the array with suggested/required info's like: artistName, trackName, thumbUrl. BUT if I want to add a new info into my "SearchItem model", I'll only add a new property, without changing the way I raise-up items. Could be decided at production time ;)
    
    self.objects = [NSMutableArray array];
    for (NSDictionary *aRawItem in results) {
        SearchItem *anItem = [[SearchItem alloc] initWithDictionary:aRawItem];
        [self.objects addObject:anItem];
    }
}

@end
