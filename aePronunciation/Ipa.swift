import Swift

struct Ipa {
    
    static let NUMBER_OF_VOWELS = 21
    static let NUMBER_OF_VOWELS_FOR_DOUBLES = 19 // not ə, ɚ
    static let NUMBER_OF_CONSONANTS = 26
    static let NUMBER_OF_CONSONANTS_FOR_DOUBLES = 24 // not ʔ. ɾ
    
    static func splitDoubleSound(str: String) -> (String, String) {
        //let firstChar = s.prefix(1)
        var index = str.index(str.startIndex, offsetBy: 1)
        let firstChar = str.prefix(upTo: index)
        
        if isConsonant(ipa: firstChar) {
            return (String(firstChar), String(str[index...]))
        }
        index = str.index(str.endIndex, offsetBy: -1)
        let lastChar = str.suffix(1)
        return (String(lastChar), String(str[..<index]))
    }
    
    static func isConsonant<T>(ipa: T) -> Bool where T: StringProtocol {
        return "ptkʧfθsʃbdgʤvðzʒmnŋlwjhrʔɾ".contains(ipa)
    }
    
    static func isVowel<T>(ipa: T) -> Bool where T: StringProtocol {
        return !isConsonant(ipa: ipa)
    }
    
    static func isSpecial<T>(ipa: T) -> Bool where T: StringProtocol {
        return "ʔɾəɚ".contains(ipa)
    }
    
    static func hasTwoPronunciations<T>(ipa: T) -> Bool where T: StringProtocol {
        return "fvθðmnl".contains(ipa)
    }
    
    static func getAllVowels() -> [String] {
        
        return [
            Ipa.i,
            Ipa.i_short,
            Ipa.e_short,
            Ipa.ae,
            Ipa.a,
            Ipa.c_backwards,
            Ipa.u_short,
            Ipa.u,
            Ipa.v_upsidedown,
            Ipa.schwa,
            Ipa.ei,
            Ipa.ai,
            Ipa.au,
            Ipa.oi,
            Ipa.ou,
            Ipa.er_stressed,
            Ipa.er_unstressed,
            Ipa.ar,
            Ipa.er,
            Ipa.ir,
            Ipa.or
        ]
    }
    
    static func getAllConsonants() -> [String] {
        return [
            Ipa.p,
            Ipa.t,
            Ipa.k,
            Ipa.ch,
            Ipa.f,
            Ipa.th_voiceless,
            Ipa.s,
            Ipa.sh,
            Ipa.b,
            Ipa.d,
            Ipa.g,
            Ipa.dzh,
            Ipa.v,
            Ipa.th_voiced,
            Ipa.z,
            Ipa.zh,
            Ipa.m,
            Ipa.n,
            Ipa.ng,
            Ipa.l,
            Ipa.w,
            Ipa.j,
            Ipa.h,
            Ipa.r,
            Ipa.glottal_stop,
            Ipa.flap_t
        ]
    }
    
    static let p = "p"
    static let t = "t"
    static let k = "k"
    static let ch = "ʧ"
    static let f = "f"
    static let th_voiceless = "θ"
    static let s = "s"
    static let sh = "ʃ"
    static let b = "b"
    static let d = "d"
    static let g = "g"
    static let dzh = "ʤ"
    static let v = "v"
    static let th_voiced = "ð"
    static let z = "z"
    static let zh = "ʒ"
    static let m = "m"
    static let n = "n"
    static let ng = "ŋ"
    static let l = "l"
    static let w = "w"
    static let j = "j"
    static let h = "h"
    static let r = "r"
    static let i = "i"
    static let i_short = "ɪ"
    static let e_short = "ɛ"
    static let ae = "æ"
    static let a = "ɑ"
    static let c_backwards = "ɔ"
    static let u_short = "ʊ"
    static let u = "u"
    static let v_upsidedown = "ʌ"
    static let schwa = "ə"
    static let ei = "eɪ"
    static let ai = "aɪ"
    static let au = "aʊ"
    static let oi = "ɔɪ"
    static let ou = "oʊ"
    static let flap_t = "ɾ"
    static let er_stressed = "ɝ"
    static let er_unstressed = "ɚ"
    static let ar = "ɑr"
    static let er = "ɛr"
    static let ir = "ɪr"
    static let or = "ɔr"
    static let glottal_stop = "ʔ"
    static let left_bracket = "["
    static let right_bracket = "]"
    static let slash = "/"
    static let undertie = "‿"
    //static let space = "\u0020"
    static let primary_stress = "ˈ"
    static let secondary_stress = "ˌ"
    static let long_vowel = "ː"
    //static let return = "\n"
    static let alt_e_short = "e"
    static let alt_c_backwards = "ɒ"
    static let alt_ou = "əʊ"
    static let alt_er_stressed = "ɜː"
    static let alt_er_unstressed = "ə"
    static let alt_ar = "ɑː"
    static let alt_er = "eə"
    static let alt_ir = "ɪə"
    static let alt_or = "ɔː"
    static let alt_l = "ɫ"
    static let alt_w = "ʍ"
    static let alt_h = "ʰ"
    static let alt_r = "ɹ"
}
