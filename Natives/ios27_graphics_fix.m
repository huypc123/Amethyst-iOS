#import <Metal/Metal.h>
#import <UIKit/UIKit.h>
#include "utils.h"

// iOS 27 Graphics Rendering Fix
// Ensures proper Metal rendering initialization on iOS 27+

void iOS27_initializeGraphicsContext(void) {
    @autoreleasepool {
        // Get Metal device to pre-initialize GPU context
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        if (device) {
            id<MTLCommandQueue> queue = [device newCommandQueue];
            if (queue) {
                NSLog(@"[iOS27] Metal GPU context initialized successfully");
                // Warm up the command queue
                id<MTLCommandBuffer> buffer = [queue commandBuffer];
                [buffer commit];
            }
            // Don't release device, Metal manages it
        } else {
            NSLog(@"[iOS27] Warning: Could not create Metal device");
        }
    }
}

// Fix for black screen on iOS 27 - Force CAMetalLayer initialization
void iOS27_fixCAMetalLayerRendering(CALayer *layer) {
    if (![layer isKindOfClass:CAMetalLayer.class]) {
        return;
    }
    
    CAMetalLayer *metalLayer = (CAMetalLayer *)layer;
    if (@available(iOS 27.0, *)) {
        // iOS 27 requires explicit drawable size configuration
        UIScreen *screen = UIScreen.mainScreen;
        CGSize size = screen.bounds.size;
        CGFloat scale = screen.scale;
        
        metalLayer.drawableSize = CGSizeMake(size.width * scale, size.height * scale);
        metalLayer.presentsWithTransaction = YES;
        metalLayer.framebufferOnly = NO;
        
        // Force Metal to use high quality rendering on iOS 27
        if (@available(iOS 16.0, *)) {
            metalLayer.developerHUDProperties = @{@"mode": @"default"};
        }
        
        NSLog(@"[iOS27] CAMetalLayer rendering fixed: size=%@", NSStringFromCGSize(metalLayer.drawableSize));
    }
}

// Workaround for iOS 27 Surface initialization delay
void iOS27_warmupSurfaceViewIfNeeded(UIView *surfaceView) {
    if (@available(iOS 27.0, *)) {
        // Force layout calculation before rendering
        [surfaceView layoutIfNeeded];
        [surfaceView setNeedsDisplay];
        
        // Pre-render a frame to warmup the GPU
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC), 
                       dispatch_get_main_queue(), ^{
            [surfaceView.layer display];
        });
        
        NSLog(@"[iOS27] Surface view warmup initiated");
    }
}
