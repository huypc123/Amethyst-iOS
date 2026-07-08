#ifndef IOS27_CONFIG_H
#define IOS27_CONFIG_H

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// iOS 27 Graphics Compatibility Configuration
typedef struct {
    BOOL enabledGL4ESFix;
    BOOL forceMirroredCodeCache;
    BOOL enableMetalWarmup;
    BOOL enableFixedDrawableSize;
    BOOL enableGPUPreWarmup;
    float metalWarmupDelay;
    BOOL enableDebugLogging;
} iOS27Config;

// Default iOS 27 configuration
extern const iOS27Config iOS27_DEFAULT_CONFIG;

// Preference keys for iOS 27
#define iOS27_PREF_ENABLED                  @"video.ios27_fixes_enabled"
#define iOS27_PREF_GL4ES_FIX                @"video.ios27_gl4es_fix"
#define iOS27_PREF_MIRROR_CACHE             @"video.ios27_mirror_cache"
#define iOS27_PREF_METAL_WARMUP             @"video.ios27_metal_warmup"
#define iOS27_PREF_DRAWABLE_SIZE_FIX        @"video.ios27_drawable_size_fix"
#define iOS27_PREF_GPU_PREWARMUP            @"video.ios27_gpu_prewarmup"
#define iOS27_PREF_DEBUG_LOGGING            @"debug.ios27_debug_logging"
#define iOS27_PREF_METAL_WARMUP_DELAY       @"video.ios27_warmup_delay"

// Function declarations
void iOS27_loadConfiguration(void);
iOS27Config iOS27_getConfiguration(void);
void iOS27_saveConfiguration(iOS27Config config);
void iOS27_resetConfiguration(void);

// Utility functions
NSString* iOS27_getVersionString(void);
BOOL iOS27_isSupported(void);
BOOL iOS27_isEnabled(void);

#endif /* IOS27_CONFIG_H */
