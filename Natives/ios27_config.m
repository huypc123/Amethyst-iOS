#import "ios27_config.h"
#import "LauncherPreferences.h"
#import "utils.h"

// Default iOS 27 configuration
const iOS27Config iOS27_DEFAULT_CONFIG = {
    .enabledGL4ESFix = YES,
    .forceMirroredCodeCache = YES,
    .enableMetalWarmup = YES,
    .enableFixedDrawableSize = YES,
    .enableGPUPreWarmup = YES,
    .metalWarmupDelay = 0.05f,
    .enableDebugLogging = NO
};

void iOS27_loadConfiguration(void) {
    if (@available(iOS 27.0, *)) {
        // Initialize iOS 27 preferences with defaults
        if (getPrefObject(iOS27_PREF_ENABLED) == nil) {
            setPrefBool(iOS27_PREF_ENABLED, YES);
        }
        if (getPrefObject(iOS27_PREF_GL4ES_FIX) == nil) {
            setPrefBool(iOS27_PREF_GL4ES_FIX, YES);
        }
        if (getPrefObject(iOS27_PREF_MIRROR_CACHE) == nil) {
            setPrefBool(iOS27_PREF_MIRROR_CACHE, YES);
        }
        if (getPrefObject(iOS27_PREF_METAL_WARMUP) == nil) {
            setPrefBool(iOS27_PREF_METAL_WARMUP, YES);
        }
        if (getPrefObject(iOS27_PREF_DRAWABLE_SIZE_FIX) == nil) {
            setPrefBool(iOS27_PREF_DRAWABLE_SIZE_FIX, YES);
        }
        if (getPrefObject(iOS27_PREF_GPU_PREWARMUP) == nil) {
            setPrefBool(iOS27_PREF_GPU_PREWARMUP, YES);
        }
        if (getPrefObject(iOS27_PREF_DEBUG_LOGGING) == nil) {
            setPrefBool(iOS27_PREF_DEBUG_LOGGING, NO);
        }
        if (getPrefObject(iOS27_PREF_METAL_WARMUP_DELAY) == nil) {
            setPrefFloat(iOS27_PREF_METAL_WARMUP_DELAY, 0.05f);
        }
        
        NSLog(@"[iOS27Config] Configuration loaded successfully");
    }
}

iOS27Config iOS27_getConfiguration(void) {
    iOS27Config config = iOS27_DEFAULT_CONFIG;
    
    if (@available(iOS 27.0, *)) {
        config.enabledGL4ESFix = getPrefBool(iOS27_PREF_GL4ES_FIX);
        config.forceMirroredCodeCache = getPrefBool(iOS27_PREF_MIRROR_CACHE);
        config.enableMetalWarmup = getPrefBool(iOS27_PREF_METAL_WARMUP);
        config.enableFixedDrawableSize = getPrefBool(iOS27_PREF_DRAWABLE_SIZE_FIX);
        config.enableGPUPreWarmup = getPrefBool(iOS27_PREF_GPU_PREWARMUP);
        config.enableDebugLogging = getPrefBool(iOS27_PREF_DEBUG_LOGGING);
        config.metalWarmupDelay = getPrefFloat(iOS27_PREF_METAL_WARMUP_DELAY);
    }
    
    return config;
}

void iOS27_saveConfiguration(iOS27Config config) {
    if (@available(iOS 27.0, *)) {
        setPrefBool(iOS27_PREF_GL4ES_FIX, config.enabledGL4ESFix);
        setPrefBool(iOS27_PREF_MIRROR_CACHE, config.forceMirroredCodeCache);
        setPrefBool(iOS27_PREF_METAL_WARMUP, config.enableMetalWarmup);
        setPrefBool(iOS27_PREF_DRAWABLE_SIZE_FIX, config.enableFixedDrawableSize);
        setPrefBool(iOS27_PREF_GPU_PREWARMUP, config.enableGPUPreWarmup);
        setPrefBool(iOS27_PREF_DEBUG_LOGGING, config.enableDebugLogging);
        setPrefFloat(iOS27_PREF_METAL_WARMUP_DELAY, config.metalWarmupDelay);
        
        NSLog(@"[iOS27Config] Configuration saved successfully");
    }
}

void iOS27_resetConfiguration(void) {
    if (@available(iOS 27.0, *)) {
        iOS27_saveConfiguration(iOS27_DEFAULT_CONFIG);
        NSLog(@"[iOS27Config] Configuration reset to defaults");
    }
}

NSString* iOS27_getVersionString(void) {
    if (@available(iOS 27.0, *)) {
        return @"iOS 27";
    }
    return [NSString stringWithFormat:@"iOS %ld", (long)NSProcessInfo.processInfo.operatingSystemVersion.majorVersion];
}

BOOL iOS27_isSupported(void) {
    if (@available(iOS 27.0, *)) {
        return YES;
    }
    return NO;
}

BOOL iOS27_isEnabled(void) {
    if (@available(iOS 27.0, *)) {
        return getPrefBool(iOS27_PREF_ENABLED);
    }
    return NO;
}
