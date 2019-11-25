package io.flutter.plugins;


import com.example.asr_plugin.AsrPlugin;

import io.flutter.plugin.common.PluginRegistry;

public class AsrPluginRegistrant {

    public static void registerWith(PluginRegistry registry) {
        if (alreadyRegisteredWith(registry)) {
            return;
        }
        AsrPlugin.registerWith(registry.registrarFor("com.example.asr_plugin.AsrPlugin"));
    }

    private static boolean alreadyRegisteredWith(PluginRegistry registry) {
        final String key = AsrPluginRegistrant.class.getCanonicalName();
        if (registry.hasPlugin(key)) {
            return true;
        }
        registry.registrarFor(key);
        return false;
    }
}
