//
//  S9QRCodeImage.m
//  SlanissueToolkit
//
//  Created by Moky on 15-9-22.
//  Copyright (c) 2015 Slanissue.com. All rights reserved.
//

#import "S9Client.h"
#import "S9Image.h"
#import "S9QRCodeImage.h"

#if !TARGET_OS_WATCH
CIImage * CIImageWithQRCode(NSString * text)
{
	NSData * data = [text dataUsingEncoding:NSUTF8StringEncoding];
	CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	[filter setDefaults];
	[filter setValue:data forKey:@"inputMessage"];
	return filter.outputImage;
}
#endif

UIImage * UIImageWithQRCode(NSString * text, CGFloat size)
{
#if !TARGET_OS_WATCH
	CGFloat screenScale = [[S9Client getInstance] screenScale];
	CIImage * image = CIImageWithQRCode(text);
	return UIImageWithCIImage(image, CGSizeMake(size, size), screenScale);
#else
	return nil;
#endif
}

@implementation UIImage (QRCode)

+ (UIImage *) imageWithQRCode:(NSString *)string size:(CGFloat)size
{
	return UIImageWithQRCode(string, size);
}

+ (UIImage *) imageWithQRCode:(NSString *)string size:(CGFloat)size small:(UIImage *)icon
{
	UIImage * image = UIImageWithQRCode(string, size);
	if (icon && image) {
		CGFloat w = icon.size.width;
		CGFloat h = icon.size.height;
		CGFloat x = (size - w) * 0.5f;
		CGFloat y = (size - h) * 0.5f;
		image = [image imageWithImagesAndRects:icon, CGRectMake(x, y, w, h), nil];
	}
	return image;
}

@end
