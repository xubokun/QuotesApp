//
//  QuotesModel.m
//  Lab3
//
//  Created by Michael on 2/25/15.
//  Copyright (c) 2015 Bokun Xu. All rights reserved.
//

#import "QuotesModel.h"

// Keys for dictionary
NSString *const QuoteKey = @"quote";
NSString *const AnswerKey = @"author";

// Filename for data - quotes plist
NSString *const QuotesPlist = @"quotes.plist";
NSString *const FavoritesPlist = @"favorites.plist";

// class extension
@interface QuotesModel ()
// private properties
@property (strong, nonatomic) NSMutableArray *quotes;
@property (strong, nonatomic) NSMutableArray *favorites;
@property NSUInteger currentIndex;
@property (strong, nonatomic) NSString *quoteFilePath;
@property (strong, nonatomic) NSString *favoritesFilePath;

@end

@implementation QuotesModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _quoteFilePath = [documentsDirectory stringByAppendingPathComponent:QuotesPlist];
        _favoritesFilePath = [documentsDirectory stringByAppendingPathComponent:FavoritesPlist];
        _quotes = [NSMutableArray arrayWithContentsOfFile:_quoteFilePath];
        _favorites = [NSMutableArray arrayWithContentsOfFile:_favoritesFilePath];
        
        if (!_quotes) { // no file
            // create quotes array
            
            NSDictionary *quotesDict1 = @{
                                          @"quote" : @"Life is about making an impact, not making an income",
                                          @"author" : @"Kevin Kruse"
                                          };
            NSDictionary *quotesDict2 = @{
                                          @"quote" : @"Whatever the mind of man can conceive and believe, it can achieve.",
                                          @"author" : @"Napoleon Hill"
                                          };
            NSDictionary *quotesDict3 = @{
                                          @"quote" : @"You miss 100% of the shots you don't take.",
                                          @"author" : @"Wayne Gretzky"
                                          };
            
            _quotes = [[NSMutableArray alloc] init];
            [_quotes addObject:quotesDict1];
            [_quotes addObject:quotesDict2];
            [_quotes addObject:quotesDict3];
        }
        
        if (!_favorites) { // no file
            //create favorites array
            _favorites = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSInteger) getCurrentindex {
    return self.currentIndex;
}

- (NSDictionary *) randomQuote {
    if([self numberOfQuotes] > 0){
        NSUInteger num = random() % [self numberOfQuotes];
        self.currentIndex = num;
        return [self quoteAtIndex:self.currentIndex];
    }
    
    return @{
                                @"quote": @"No Quotes",
                                @"author": @"No Authors"
                                };
}

- (NSDictionary *) currentQuote {
    if([self numberOfQuotes] > 0){
        return [self quoteAtIndex:self.currentIndex];
    }
    
    return @{
             @"quote": @"No Quotes",
             @"author": @"No Authors"
             };
}

- (NSUInteger) numberOfQuotes {
    return [self.quotes count];
}

- (NSUInteger) numberOfFavorites {
    return [self.favorites count];
}

- (NSDictionary *) quoteAtIndex: (NSUInteger) index {
    
    return [self.quotes objectAtIndex:index];
}

- (NSDictionary *) favoriteAtIndex: (NSUInteger) index {
    return [self.favorites objectAtIndex:index];
}

- (void) insertQuote: (NSString *) quote author: (NSString *) author atIndex: (NSUInteger) index {
    if (index <= self.quotes.count) {
        NSDictionary *quoteDict = @{
                                    @"quote":quote,
                                    @"author":author
                                    };
        [self.quotes insertObject: quoteDict atIndex:index];
        [self save];
    }
}

- (void) insertFavorite: (NSString *) quote author: (NSString *) author atIndex: (NSUInteger) index {
    if (index <= self.favorites.count) {
        NSDictionary *quoteDict = @{
                                    @"quote":quote,
                                    @"author":author
                                    };
        [self.favorites insertObject: quoteDict atIndex:index];
        [self save];
    }
}

- (void) removeQuoteAtIndex: (NSUInteger) index {
    if (index < self.quotes.count) {
//        if (index == 0) {
//            self.currentIndex = 0;
//        } else {
//            self.currentIndex = index - 1;
//        }
        [self.quotes removeObjectAtIndex:index];
        [self save];
    }
}

- (void) removeFavoriteAtIndex: (NSUInteger) index {
    if (index < self.favorites.count) {
        //        if (index == 0) {
        //            self.currentIndex = 0;
        //        } else {
        //            self.currentIndex = index - 1;
        //        }
        [self.favorites removeObjectAtIndex:index];
        [self save];
    }
}


- (NSDictionary *) nextQuote {
    //NSUInteger num;
    
    if (self.currentIndex == self.quotes.count - 1) {
        self.currentIndex = 0;
        //num = 0;
    } else {
        //num = self.currentIndex + 1;
        self.currentIndex = self.currentIndex + 1;
    }
    //return self.quotes[num];
    //return [self.quotes objectAtIndex:num];
    return [self.quotes objectAtIndex:self.currentIndex];
}

- (NSDictionary *) prevQuote {
    //NSUInteger num;
    
    if (self.currentIndex == 0) {
        //num = [self numberOfQuotes] - 1;
        self.currentIndex = [self numberOfQuotes] - 1;
    } else {
        //num = self.currentIndex - 1;
        self.currentIndex = self.currentIndex - 1;
    }
    //return self.quotes[num];
    //return [self.quotes objectAtIndex:num];
    return [self.quotes objectAtIndex:self.currentIndex];
}

- (void) save {
    [self.quotes writeToFile:self.quoteFilePath atomically:YES];
    [self.favorites writeToFile:self.favoritesFilePath atomically:YES];
}

+ (instancetype) sharedModel {
    static QuotesModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

@end
