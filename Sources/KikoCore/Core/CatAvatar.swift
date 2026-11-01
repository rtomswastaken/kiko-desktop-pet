// Sources/Core/CatAvatar.swift
import Foundation

public enum CatAvatar: String, CaseIterable, Identifiable, Sendable, Codable {
    case kiko = "kiko"
    case smokey = "smokey"
    case kuro = "kuro"
    case mochi = "mochi"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .kiko: return "Kiko (Ginger Tabby)"
        case .smokey: return "Smokey (Grey Tabby)"
        case .kuro: return "Kuro (Midnight Void)"
        case .mochi: return "Mochi (Snow White)"
        }
    }
    
    public var shortName: String {
        switch self {
        case .kiko: return "Kiko"
        case .smokey: return "Smokey"
        case .kuro: return "Kuro"
        case .mochi: return "Mochi"
        }
    }
    
    public var breedDescription: String {
        switch self {
        case .kiko: return "A cheerful, curious ginger tabby who loves exploring windows and chasing cursor dots."
        case .smokey: return "A calm, sleepy grey tabby who loves cardboard boxes, loafing, and warm naps."
        case .kuro: return "A sleek, quick black cat with lots of mischievous zoomies and midnight energy."
        case .mochi: return "A soft, affectionate pure white cat who loves head pets, snuggles, and floating hearts."
        }
    }
    
    public var defaultPersonality: Personality {
        switch self {
        case .kiko: return .kiko
        case .smokey: return .smokey
        case .kuro: return .kuro
        case .mochi: return .mochi
        }
    }
    
    public var spritePrefix: String {
        rawValue
    }
    
    public var variantPortraitFilename: String {
        switch self {
        case .kiko: return "kiko_variant_orange.png"
        case .smokey: return "kiko_variant_grey.png"
        case .kuro: return "kiko_variant_black.png"
        case .mochi: return "kiko_variant_white.png"
        }
    }
}
