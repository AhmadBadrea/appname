//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<animated_rating_stars/AnimatedRatingStarsPlugin.h>)
#import <animated_rating_stars/AnimatedRatingStarsPlugin.h>
#else
@import animated_rating_stars;
#endif

#if __has_include(<image_picker_ios/FLTImagePickerPlugin.h>)
#import <image_picker_ios/FLTImagePickerPlugin.h>
#else
@import image_picker_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AnimatedRatingStarsPlugin registerWithRegistrar:[registry registrarForPlugin:@"AnimatedRatingStarsPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
}

@end
