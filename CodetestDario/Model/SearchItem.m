//
//  SearchItem.m
//  CodetestDario
//
//  Created by Dario Carlomagno on 25/01/16.
//  Copyright © 2016 Me. All rights reserved.
//

#import "SearchItem.h"
#import "Constants.h"

@implementation SearchItem
{
    NSString *_artistName;
    NSString *_albumName;
    NSString *_trackName;
    NSString *_thumbnailUrlString;
    NSString *_price;
    NSDate * _releaseDate;
    NSDateFormatter *dateFormatter;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {

    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
        _artistName = dictionary[kiTunesArtistName];
        _albumName = dictionary[kiTunesAlbumName];
        _trackName = dictionary[kiTunesTrackName];
        _thumbnailUrlString = dictionary[kiTunesThumbnailUrl];
        _price = [dictionary[kiTunesPrice] stringValue];
        
        // format receiver date
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *tempDate = [dateFormatter dateFromString:dictionary[kiTunesReleaseDate]];
        
        // change to well readable date format linke 1 January 1970
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        _releaseDate = tempDate;
    }
    return self;
}

- (NSString *)artistName {
    return _artistName;
}

- (NSString *)albumName {
    return _albumName;
}

- (NSDate *)releaseDate {
    return _releaseDate;
}

- (NSString *)price {
    return _price;
}

- (NSString *)trackName {
    return _trackName;
}

- (NSString *)thumbnailUrlString {
    return _thumbnailUrlString;
}

- (NSString *)releaseDateAsString {
    return [dateFormatter stringFromDate:_releaseDate];
}


@end
