//
//  SearchItem.h
//  CodetestDario
//
//  Created by Dario Carlomagno on 25/01/16.
//  Copyright © 2016 Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SearchItem : NSObject

@property (nonatomic, readonly) NSString *artistName;
@property (nonatomic, readonly) NSString *albumName;
@property (nonatomic, readonly) NSString *trackName;
@property (nonatomic, readonly) UIImage  *thumbnail;
@property (nonatomic, readonly) NSString *price;
@property (nonatomic, readonly) NSDate   *releaseDate;
@property (nonatomic, strong)   NSCache *imageCache;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)releaseDateAsString;
- (NSString *)thumbnailUrlString;

@end
