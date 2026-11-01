// Sources/KikoCore/Core/CatAvatar.swift
import Foundation

public enum CatAvatar: String, CaseIterable, Identifiable, Sendable, Codable {
    case ginger = "ginger"
    case blackCat = "blackcat"
    case calico = "calico"
    case whiteCat = "whitecat"
    case brownCat = "browncat"
    case siamese = "siamese"
    case tiger = "tiger"
    case astronaut = "astronaut"
    case batman = "batman"
    case demon = "demon"
    case santa = "santa"
    case vampire = "vampire"
    case witch = "witch"
    
    // Legacy aliases
    public static var kiko: CatAvatar { .ginger }
    public static var kuro: CatAvatar { .blackCat }
    public static var mochi: CatAvatar { .whiteCat }
    public static var smokey: CatAvatar { .brownCat }
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .ginger: return "Ginger (Kiko)"
        case .blackCat: return "Black Cat (Kuro)"
        case .calico: return "Calico"
        case .whiteCat: return "White Cat (Mochi)"
        case .brownCat: return "Brown Cat"
        case .siamese: return "Siamese"
        case .tiger: return "Tiger"
        case .astronaut: return "Astronaut 🚀"
        case .batman: return "Batcat 🦇"
        case .demon: return "Little Demon 😈"
        case .santa: return "Santa Cat 🎅"
        case .vampire: return "Vampire 🧛"
        case .witch: return "Witch 🧙‍♀️"
        }
    }
    
    public var shortName: String {
        switch self {
        case .ginger: return "Kiko"
        case .blackCat: return "Kuro"
        case .calico: return "Calico"
        case .whiteCat: return "Mochi"
        case .brownCat: return "Brownie"
        case .siamese: return "Siamese"
        case .tiger: return "Tiger"
        case .astronaut: return "Astro"
        case .batman: return "Batcat"
        case .demon: return "Demon"
        case .santa: return "Santa"
        case .vampire: return "Vampy"
        case .witch: return "Witch"
        }
    }
    
    public var breedDescription: String {
        switch self {
        case .ginger: return "A cheerful ginger cat who loves jumping on windows, running around, and attacking toys."
        case .blackCat: return "A sleek midnight black cat with swift reflexes and playful stealth."
        case .calico: return "A lucky calico with a sweet, curious disposition and gentle purrs."
        case .whiteCat: return "A snowy white cat who loves head pats, sleeping in warm spots, and gentle naps."
        case .brownCat: return "A relaxed, cuddly brown cat who loves loafing and snoozing."
        case .siamese: return "An elegant, talkative Siamese cat with inquisitive bright eyes."
        case .tiger: return "A fierce little striped tiger cat always ready for pounces and zoomies."
        case .astronaut: return "A space-faring cat equipped with an authentic astronaut spacesuit!"
        case .batman: return "A mysterious masked hero watching over your desktop from window ledges."
        case .demon: return "A tiny horned troublemaker packed with chaotic zoomie energy."
        case .santa: return "Festive holiday cheer in cat form, spreading cozy winter vibes."
        case .vampire: return "A spooky, charming creature of the night who loves sleeping in shadows."
        case .witch: return "A magical feline companion complete with witchy robes and mischief."
        }
    }
    
    public var defaultPersonality: Personality {
        switch self {
        case .ginger:
            return Personality(name: "Kiko", playful: 0.85, lazy: 0.30, curious: 0.85, mischievous: 0.60, shy: 0.15, affectionate: 0.85, energetic: 0.80, independent: 0.35)
        case .blackCat:
            return Personality(name: "Kuro", playful: 0.90, lazy: 0.20, curious: 0.90, mischievous: 0.90, shy: 0.20, affectionate: 0.50, energetic: 0.90, independent: 0.85)
        case .calico:
            return Personality(name: "Calico", playful: 0.70, lazy: 0.40, curious: 0.75, mischievous: 0.40, shy: 0.25, affectionate: 0.90, energetic: 0.60, independent: 0.40)
        case .whiteCat:
            return Personality(name: "Mochi", playful: 0.60, lazy: 0.55, curious: 0.60, mischievous: 0.30, shy: 0.65, affectionate: 0.95, energetic: 0.45, independent: 0.25)
        case .brownCat:
            return Personality(name: "Brownie", playful: 0.40, lazy: 0.85, curious: 0.45, mischievous: 0.25, shy: 0.30, affectionate: 0.80, energetic: 0.30, independent: 0.50)
        case .siamese:
            return Personality(name: "Siamese", playful: 0.75, lazy: 0.35, curious: 0.95, mischievous: 0.70, shy: 0.20, affectionate: 0.75, energetic: 0.75, independent: 0.60)
        case .tiger:
            return Personality(name: "Tiger", playful: 0.95, lazy: 0.20, curious: 0.80, mischievous: 0.85, shy: 0.10, affectionate: 0.60, energetic: 0.95, independent: 0.70)
        case .astronaut:
            return Personality(name: "Astro", playful: 0.80, lazy: 0.30, curious: 0.98, mischievous: 0.50, shy: 0.10, affectionate: 0.70, energetic: 0.85, independent: 0.75)
        case .batman:
            return Personality(name: "Batcat", playful: 0.70, lazy: 0.40, curious: 0.85, mischievous: 0.80, shy: 0.30, affectionate: 0.40, energetic: 0.80, independent: 0.95)
        case .demon:
            return Personality(name: "Demon", playful: 0.95, lazy: 0.15, curious: 0.90, mischievous: 0.98, shy: 0.05, affectionate: 0.35, energetic: 0.98, independent: 0.90)
        case .santa:
            return Personality(name: "Santa", playful: 0.65, lazy: 0.60, curious: 0.55, mischievous: 0.35, shy: 0.10, affectionate: 0.95, energetic: 0.50, independent: 0.30)
        case .vampire:
            return Personality(name: "Vampy", playful: 0.75, lazy: 0.70, curious: 0.70, mischievous: 0.80, shy: 0.40, affectionate: 0.55, energetic: 0.60, independent: 0.85)
        case .witch:
            return Personality(name: "Witch", playful: 0.85, lazy: 0.35, curious: 0.92, mischievous: 0.88, shy: 0.20, affectionate: 0.65, energetic: 0.80, independent: 0.80)
        }
    }
    
    public var spritePrefix: String {
        rawValue
    }
}
