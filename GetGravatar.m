//
//  GetGravatar.m
//  GetGravatar
//
//  Created by Philip Willoughby on 2009-12-15.
//  Copyright Philip Willoughby 2009 2010. All rights reserved.
//

#import "GetGravatar.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (md5)

- (NSString *)md5 {
    const char *src = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(src, (CC_LONG)strlen(src), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15] ];
}

@end

@implementation GetGravatar

- (NSString *)actionProperty
{
    //NSLog(@"actionProperty");
    return kABEmailProperty;
}

- (NSString *)titleForPerson:(ABPerson *)person identifier:(NSString *)identifier
{
    //NSLog(@"titleForPerson:%p identifier:%@",person,identifier);
    ABMultiValue* values = [person valueForProperty:[self actionProperty]];
    NSString* value = [values valueForIdentifier:identifier];

    return [NSString stringWithFormat:@"Get gravatar for %@", value];    
}

- (void)performActionForPerson:(ABPerson *)person identifier:(NSString *)identifier
{
    //NSLog(@"performActionForPerson:%p identifier:%@",person,identifier);
    ABMultiValue* values = [person valueForProperty:[self actionProperty]];
    NSString* value = [[values valueForIdentifier:identifier] lowercaseString];
    //NSLog(@"Email address: %@",value);
    
    NSString *URLString = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=512&r=x&d=404", [value md5]];

    NSURL *gravatarURL = [NSURL URLWithString:URLString];
    //NSLog(@"Requesting Gravatar from %@",gravatarURL);
    
    NSHTTPURLResponse* gravatarResponse;
    
    NSData* image = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:gravatarURL] returningResponse:&gravatarResponse error:NULL];
    //NSLog(@"Response is %@",gravatarResponse);
    //NSLog(@"Status code is %u",[gravatarResponse statusCode]);
    //NSLog(@"Image data address is %p");
    if (image != nil && ([gravatarResponse statusCode] != 404))
    {
        [person setImageData:image];
    }
}

// Optional. Your action will always be enabled in the absence of this method. As
// above, this method is passed information about the data item rolled over.
- (BOOL)shouldEnableActionForPerson:(ABPerson *)person identifier:(NSString *)identifier
{
    //NSLog(@"shouldEnableActionForPerson:%p identifier:%@",person,identifier);
    return YES;
}

@end
