//
//  DetailViewController.m
//  CodetestDario
//
//  Created by Dario Carlomagno on 25/01/16.
//  Copyright © 2016 Me. All rights reserved.
//

#import "DetailViewController.h"
#import "SearchItem.h"
#import "NetworkManager.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *releaseDate;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem && [self.detailItem isKindOfClass:[SearchItem class]]) {
        SearchItem *anItem = (SearchItem *)self.detailItem;
        self.trackName.text = anItem.trackName;
        self.albumName.text = anItem.albumName;
        self.artistName.text = anItem.artistName;
        self.price.text = [NSString stringWithFormat:@"$ %@", anItem.price];
        self.releaseDate.text = [anItem releaseDateAsString];
        [self showThumbnailForItem:anItem];
    }
}

- (void)showThumbnailForItem:(SearchItem *)item {
    if ([item.imageCache objectForKey:item.thumbnailUrlString]) {
        self.thumbnail.image = [item.imageCache objectForKey:item.thumbnailUrlString];
    } else {
        [[NetworkManager sharedManager] loadImageWithUrl:item.thumbnailUrlString
                                     andComplentionBlock:^(NSData *imageData) {
                                         // show downloaded image
                                         if (imageData) {
                                             self.thumbnail.image = [UIImage imageWithData:imageData];
                                         }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    // TODO: in ipad, create a kind o "placeholder view" that replace actual
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
