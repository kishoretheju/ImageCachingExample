//
//  KTMImageCaching.h
//
//  Created by Kishore Thejasvi on 05/10/14.
//  Copyright (c) 2014 Kishore Thejasvi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KTMImageCachingDelegate <NSObject>
@required
- (void)cachedImageData: (NSData *)imageData;
- (void)downloadedImageData: (NSData *)imageData;

@end

@interface KTMImageCaching : NSObject

@property (weak, nonatomic) id<KTMImageCachingDelegate>delegate;

/**
 *  Creates singleton instance of KTMImageCaching class
 *
 *  @return instance of KTMImageCaching class
 */
+ (instancetype)sharedInstance;

/**
 *  Loads the cache image if it exists otherwise initiates image downloading network operation.
 *
 *  @param url NSString containing URL of the image to be downloaded.
 */
- (void)downloadAndCacheImageWithURL: (NSString *)url;

@end
