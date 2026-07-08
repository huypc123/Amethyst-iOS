#import <Metal/Metal.h>
#import <UIKit/UIKit.h>
#include "utils.h"
#import "ios27_config.h"

// iOS 27 Graphics Rendering Fix
// Ensures proper Metal rendering initialization on iOS 27+

void iOS27_initializeGraphicsContext(void) {
    if (@available(iOS 27.0, *)) {
        iOS27Config config = iOS27_getConfiguration();
        
        if (!config.enabledGL4ESFix && !config.enableGPUPreWarmup) {
            return;
        }
        
        @autoreleasepool {
            // Get Metal device to pre-initialize GPU context
            id<MTLDevice> device = MTLCreateSystemDefaultDevice();
            if (device) {
                if (config.enableDebugLogging) {
                    NSLog(@"[iOS27] Metal device: %@", device.name);
                }
                
                id<MTLCommandQueue> queue = [device newCommandQueue];
                if (queue && config.enableGPUPreWarmup) {
                    id<MTLCommandBuffer> buffer = [queue commandBuffer];
                    [buffer commit];
                    
                    if (config.enableDebugLogging) {
                        NSLog(@"[iOS27] Metal GPU context initialized successfully");
                    }
                }
            } else {
                NSLog(@"[iOS27] Warning: Could not create Metal device");
            }
        }
    }
}

// Fix for black screen on iOS 27 - Force CAMetalLayer initialization
void iOS27_fixCAMetalLayerRendering(CALayer *layer) {
    if (@available(iOS 27.0, *)) {
        iOS27Config config = iOS27_getConfiguration();
        
        if (!config.enableFixedDrawableSize) {
            return;
        }
        
        if (![layer isKindOfClass:CAMetalLayer.class]) {
            return;
        }
        
        CAMetalLayer *metalLayer = (CAMetalLayer *)layer;
        
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
        
        if (config.enableDebugLogging) {
            NSLog(@"[iOS27] CAMetalLayer rendering fixed: size=%@", NSStringFromCGSize(metalLayer.drawableSize));
        }
    }
}

// Workaround for iOS 27 Surface initialization delay
void iOS27_warmupSurfaceViewIfNeeded(UIView *surfaceView) {
    if (@available(iOS 27.0, *)) {
        iOS27Config config = iOS27_getConfiguration();
        
        if (!config.enableMetalWarmup) {
            return;
        }
        
        // Force layout calculation before rendering
        [surfaceView layoutIfNeeded];
        [surfaceView setNeedsDisplay];
        
        if (config.enableDebugLogging) {
            NSLog(@"[iOS27] Surface view layout requested");
        }
        
        // Pre-render a frame to warmup the GPU
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(config.metalWarmupDelay * NSEC_PER_SEC)), 
                       dispatch_get_main_queue(), ^{
            [surfaceView.layer display];
            
            if (config.enableDebugLogging) {
                NSLog(@"[iOS27] Surface view warmup completed");
            }
        });
    }
}

// Apply GL4ES compatibility fixes for iOS 27
void iOS27_applyGL4ESFixes(void) {
    if (@available(iOS 27.0, *)) {
        iOS27Config config = iOS27_getConfiguration();
        
        if (!config.enabledGL4ESFix) {
            return;
        }
        
        // Set GL4ES environment variables for iOS 27 compatibility
        setenv("LIBGL_NOINTOVLHACK", "1", 1);
        setenv("LIBGL_NORMALIZE", "1", 1);
        setenv("MESA_GL_VERSION_OVERRIDE", "4.1", 1);
        
        if (config.enableDebugLogging) {
            NSLog(@"[iOS27] GL4ES fixes applied");
        }
    }
}

// Apply mirror mapped code cache for iOS 27
void iOS27_applyMirrorMappedCodeCache(void) {
    if (@available(iOS 27.0, *)) {
        iOS27Config config = iOS27_getConfiguration();
        
        if (!config.forceMirroredCodeCache) {
            return;
        }
        
        // This is handled by JVM flags in JavaLauncher.m
        // This function is here for reference and potential future enhancements
        
        if (config.enableDebugLogging) {
            NSLog(@"[iOS27] Mirror mapped code cache enabled");
        }
    }
}

// Comprehensive iOS 27 initialization
void iOS27_initializeAll(void) {
    if (@available(iOS 27.0, *)) {
        iOS27_loadConfiguration();
        iOS27_applyGL4ESFixes();
        iOS27_applyMirrorMappedCodeCache();
        iOS27_initializeGraphicsContext();
        
        NSLog(@"[iOS27] Full initialization completed - Version: %@", iOS27_getVersionString());
    }
}

// Get readable status string
NSString* iOS27_getStatusString(void) {
    if (!iOS27_isSupported()) {
        return @"Not supported on this iOS version";
    }
    
    if (!iOS27_isEnabled()) {
        return @"iOS 27 fixes are disabled";
    }
    
    iOS27Config config = iOS27_getConfiguration();
    NSMutableString *status = [NSMutableString new];
    
    [status appendString:@"iOS 27 Fixes Enabled:\n"];
    [status appendFormat:@"• GL4ES Fix: %@\n", config.enabledGL4ESFix ? @"✓" : @"✗"];
    [status appendFormat:@"• Mirror Cache: %@\n", config.forceMirroredCodeCache ? @"✓" : @"✗"];
    [status appendFormat:@"• Metal Warmup: %@\n", config.enableMetalWarmup ? @"✓" : @"✗"];
    [status appendFormat:@"• Drawable Size Fix: %@\n", config.enableFixedDrawableSize ? @"✓" : @"✗"];
    [status appendFormat:@"• GPU Prewarmup: %@\n", config.enableGPUPreWarmup ? @"✓" : @"✗"];
    [status appendFormat:@"• Warmup Delay: %.3fs", config.metalWarmupDelay];
    
    return status;
}
