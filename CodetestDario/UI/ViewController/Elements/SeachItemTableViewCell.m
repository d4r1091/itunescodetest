//
//  SeachItemTableViewCell.m
//  CodetestDario
//
//  Created by Dario Carlomagno on 26/01/16.
//  Copyright © 2016 Me. All rights reserved.
//

#import "SeachItemTableViewCell.h"
#import "SearchItem.h"

@interface SeachItemTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (strong, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *trackNameLabel;

@end

@implementation SeachItemTableViewCell

- (void)bindDataWithObject:(id)obj {
    
    if ([obj isKindOfClass:[SearchItem class]]) {
        
        SearchItem *aSearchItem = (SearchItem *)obj;
        // avoid orrible "(null)" strings
        if (aSearchItem.artistName.length>0) {
            _artistNameLabel.text = aSearchItem.artistName;
        } else {
            // TODO: insert a Localizable.strings
            _artistNameLabel.text = @"No artist name provided";
        }
        
        if (aSearchItem.trackName.length>0) {
            _trackNameLabel.text = aSearchItem.trackName;
        } else {
            // TODO: insert a Localizable.strings
            _trackNameLabel.text = @"No track name provided";
        }
        
        // i prefer to call the "async donwload" method for retrieve thumbanil into ViewController beacuse is inherited to "NetworkManager instance" and is not so good to intert a "network stuff into a data model or ui model".
    }
}

- (void)updateImage:(UIImage *)image {
    _thumbnailImage.image = image;
}

@end
