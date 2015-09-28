//
//  QuotesModel.h
//  Lab3
//
//  Created by Michael on 2/25/15.
//  Copyright (c) 2015 Bokun Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuotesModel : NSObject

// pbulic properties & public method definitions

- (NSInteger) getCurrentindex;
- (NSDictionary *) currentQuote;
- (NSDictionary *) randomQuote;
- (NSUInteger) numberOfQuotes;
- (NSUInteger) numberOfFavorites;
- (NSDictionary *) quoteAtIndex: (NSUInteger) index;
- (NSDictionary *) favoriteAtIndex: (NSUInteger) index;
- (void) insertQuote: (NSString *) quote
              author: (NSString *) author
             atIndex: (NSUInteger) index;
- (void) insertFavorite: (NSString *) quote
              author: (NSString *) author
             atIndex: (NSUInteger) index;
- (void) removeQuoteAtIndex: (NSUInteger) index;
- (void) removeFavoriteAtIndex: (NSUInteger) index;
- (NSDictionary *) nextQuote;
- (NSDictionary *) prevQuote;
+ (instancetype) sharedModel;

@end
