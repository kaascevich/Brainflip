/// Checks whether the provided string is a valid variant of the Konami code.
///
/// - Parameter code: The string to check.
///
/// - Returns: `true` if `code` is a valid valid variant of the Konami code;
///   otherwise, `false`.
func isValidKonamiCode(_ code: String) -> Bool {
    enum KonamiCharacters: String {
        // Just about every single Unicode character I can come up with that even vaugely represents these symbols.
        case up = "^ˆΔΛᴧᶺ‸↑↟↥↾↿⇈⇑⇞⇡⇧⇪⇫⇬⇭⇮⇯∆∧≙≜⊼⋀⋏⌂⌃⌅⌆⍓⍙⍲⏃⏄⏅⏏︎⏏️⏫️▲△▴▵◬◭◮☝︎☝️☝🏻☝🏼☝🏽☝🏾☝🏿♠︎♤⚨⟑⟰⤉⤊⤒⤴️⥉⥔⥘⥜⥠⥣⦽⧊⧋⧌⧍⨣⨨⨹⨺⨻⩑⩓⩕⩘⩚⩜⩞⩟⩠⬆︎⬆️ꜛ︽︿＾𐅉𐅐𐅢𐅺𝚫𝚲𝛥𝛬𝜟𝜦𝝙𝝠𝞓𝞚🆙👆👆🏻👆🏼👆🏽👆🏾👆🏿👍👍🏻👍🏼👍🏽👍🏾👍🏿🔝🔺🔼🖕🖕🏻🖕🏼🖕🏽🖕🏾🖕🏿"
        case down = "Vvᴠ↓↡↧↯⇂⇃⇊⇓⇟⇣⇩∀∇∨≚⊻⊽⋁⋎⌄⍌⍒⍔⍗⍢⍫⍱⎀⏚⏬️▼▽▾▿☟♡♥︎⟱⤈⤋⤓⤵️⥕⥙⥝⥡⥥⧨⧩⧪⧬⧭⨈⩒⩔⩖⩗⩛⩝⩡⩢⩣⬇︎⬇️ꜜ︾﹀𝝯👇👇🏻👇🏼👇🏽🏾👇🏿👎👎🏻👎🏼👎🏽👎🏾👎🏿🔻🔽"
        case left = "<←↚↜↞↢↤↩︎↩️↫↼↽⇇⇍⇐⇚⇜⇠⇤⇦⇷⇺⇽∢≤≦≨≪≮≰≲≴≺≼≾⊀⊰⊲⊴⋖⋘⋜⋞⋠⋦⋨⋪⋬⌫⍃⏎⏪️⏮️◀︎◀️◁◂◃◄◅☚☜✍︎❮⟨⟪⟵⟸⟻⟽⤂⤆⤌⤎⤚⤜⤝⤟⤺⤽⥆⥒⥖⥚⥞⥢⥪⥫⥳⦃⦅⦇⦉⦑⦓⦖⦴⧙⧛⩤⩹⩻⩽⩿⪁⪃⪅⪇⪉⪍⪕⪗⪙⪛⪝⪟⪡⪣⪦⪨⪪⪬⪯⪱⪳⪵⪷⪹⪻⫷⫹⬅︎⬅️＜𐅻𒑱👈👈🏻👈🏼👈🏽👈🏾👈🏿🔙🔚🡐🤛🤛🏻🤛🏼🤛🏽🤛🏾🤛🏿🫲🫲🏻🫲🏼🫲🏽🫲🏾🫲🏿"
        case right = ">→↛↝↠↣↦↪️↬⇀⇁⇉⇏⇒⇛⇝⇢⇥⇨⇰⇴⇶⇸⇻⇾≥≧≩≫≯≱≳≻≽≿⊁⋗⋙⋝⋟⋡⋧⋩⋫⋭⌦⌲⍄⍩⏩️⏭️⏯️▶︎▶️▷▸▹►▻☛☞⚩✏︎✑✒︎❯➔➙➛➜➝➞➟➠➡︎➡️➢➣➤➥➦➧➨➩➪➫➬➭➮➯➱➲➳➵➸➺➻➼➽➾⟩⟫⟶⟹⟼⟾⟿⤀⤁⤃⤅⤇⤍⤏⤐⤑⤔⤕⤖⤗⤘⤙⤛⤞⤠⤳⤻⤼⥅⥇⥈⥓⥗⥛⥟⥤⥬⥭⥱⥲⥴⥵⦄⦆⦈⦊⦒⦔⦕⦳⧐⧘⧚⧴⧽⨠⩥⩺⩼⩾⪀⪂⪄⪆⪈⪊⪎⪖⪘⪚⪜⪞⪠⪧⪩⪫⪭⪰⪲⪴⪶⪸⪺⪼⫸⫺⸖＞𐅙👉👉🏻👉🏼👉🏽👉🏾👉🏿🔜🚩🡒🤜🤜🏻🤜🏼🤜🏽🤜🏾🤜🏿🫱🫱🏻🫱🏼🫱🏽🫱🏾🫱🏿"
        case b = "BbƀƁƂƃƄƅɃɓʙΒβϸᴃᴮᴯᵇᵝᵦᶀḂḃḄḅḆḇℬ⒝Ⓑⓑ♭𝄡𝄫𝐁𝐛𝐵𝑏𝑩𝒃𝒷𝓑𝓫𝔅𝔟𝔹𝕓𝕭𝖇𝖡𝗕𝗯𝘉𝘣𝘽𝙗𝙱𝚋𝚩𝛃𝛣𝛽𝜝𝜷𝝗𝝱𝞑𝞫🄑🄱🅑🅱🅱️🇧"
        case a = "@AaÀÁÂÃÄÅâãäåĀāĂăĄąǍǎǞǟǠǡǺǻȀȁȂȃȦȧȺɐɑɒΆΑάαᴀᴬᵃᵄᵅᶏᶐᶛḀḁẚẠạẢảẤấẦầẨẩẪẫẬậẮắẰằẲẳẴẵẶặἀἀἁἂἃἄἅἆἇἈἉἊἋἌἍἎἏὰᾀᾁᾂᾄᾅᾆᾇᾰᾱᾲᾳᾴᾶᾷᾸᾹᾺ⒜Ⓐⓐⱥ＠𝐀𝐚𝐴𝑎𝑨𝒂𝒜𝒶𝓐𝓪𝔄𝔞𝔸𝕒𝕬𝖆𝖠𝖺𝗔𝗮𝘈𝘢𝘼𝙖𝙰𝚊𝚨𝛂𝛢𝛼𝜜𝜶𝝖𝝰𝞐𝞪🄐🄰🅐🅰🅰️🇦"
    }
    
    let konamiSequence: [KonamiCharacters] = [.up, .up, .down, .down, .left, .right, .left, .right, .b, .a]
    let code = Array(code)
    
    guard code.count == konamiSequence.count else { return false }
    
    for i in konamiSequence.indices {
        guard konamiSequence[i].rawValue.contains(code[i]) else { return false }
    }
    
    return true
}
