// Easter.swift
// Copyright © 2023 Kaleb A. Ascevich
//
// This app is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This app is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this app. If not, see https://www.gnu.org/licenses/.

fileprivate enum KonamiCharacters: String {
    // Just about every single Unicode character I can come up with that even vaugely represents these symbols.
    case up = "^ˆΔΛᴧᶺ‸↑↟↥↾↿⇈⇑⇞⇡⇧⇪⇫⇬⇭⇮⇯∆∧≙≜⊼⋀⋏⌂⌃⌅⌆⍓⍙⍲⏃⏄⏅⏏︎⏏️⏫️▲△▴▵◬◭◮☝︎☝️☝🏻☝🏼☝🏽☝🏾☝🏿♠︎♤⚨⟑⟰⤉⤊⤒⤴️⥉⥔⥘⥜⥠⥣⦽⧊⧋⧌⧍⨣⨨⨹⨺⨻⩑⩓⩕⩘⩚⩜⩞⩟⩠⬆︎⬆️ꜛ︽︿＾𐅉𐅐𐅢𐅺𝚫𝚲𝛥𝛬𝜟𝜦𝝙𝝠𝞓𝞚🆙👆👆🏻👆🏼👆🏽👆🏾👆🏿👍👍🏻👍🏼👍🏽👍🏾👍🏿🔝🔺🔼🖕🖕🏻🖕🏼🖕🏽🖕🏾🖕🏿"
    case down = "Vvᴠ↓↡↧↯⇂⇃⇊⇓⇟⇣⇩∀∇∨≚⊻⊽⋁⋎⌄⍌⍒⍔⍗⍢⍫⍱⎀⏚⏬️▼▽▾▿☟♡♥︎⟱⤈⤋⤓⤵️⥕⥙⥝⥡⥥⧨⧩⧪⧬⧭⨈⩒⩔⩖⩗⩛⩝⩡⩢⩣⬇︎⬇️ꜜ︾﹀𝝯👇👇🏻👇🏼👇🏽🏾👇🏿👎👎🏻👎🏼👎🏽👎🏾👎🏿🔻🔽"
    case left = "<←↚↜↞↢↤↩︎↩️↫↼↽⇇⇍⇐⇚⇜⇠⇤⇦⇷⇺⇽∢≤≦≨≪≮≰≲≴≺≼≾⊀⊰⊲⊴⋖⋘⋜⋞⋠⋦⋨⋪⋬⌫⍃⏎⏪️⏮️◀︎◀️◁◂◃◄◅☚☜✍︎❮⟨⟪⟵⟸⟻⟽⤂⤆⤌⤎⤚⤜⤝⤟⤺⤽⥆⥒⥖⥚⥞⥢⥪⥫⥳⦃⦅⦇⦉⦑⦓⦖⦴⧙⧛⩤⩹⩻⩽⩿⪁⪃⪅⪇⪉⪍⪕⪗⪙⪛⪝⪟⪡⪣⪦⪨⪪⪬⪯⪱⪳⪵⪷⪹⪻⫷⫹⬅︎⬅️＜𐅻𒑱👈👈🏻👈🏼👈🏽👈🏾👈🏿🔙🔚🡐🤛🤛🏻🤛🏼🤛🏽🤛🏾🤛🏿🫲🫲🏻🫲🏼🫲🏽🫲🏾🫲🏿"
    case right = ">→↛↝↠↣↦↪️↬⇀⇁⇉⇏⇒⇛⇝⇢⇥⇨⇰⇴⇶⇸⇻⇾≥≧≩≫≯≱≳≻≽≿⊁⋗⋙⋝⋟⋡⋧⋩⋫⋭⌦⌲⍄⍩⏩️⏭️⏯️▶︎▶️▷▸▹►▻☛☞⚩✏︎✑✒︎❯➔➙➛➜➝➞➟➠➡︎➡️➢➣➤➥➦➧➨➩➪➫➬➭➮➯➱➲➳➵➸➺➻➼➽➾⟩⟫⟶⟹⟼⟾⟿⤀⤁⤃⤅⤇⤍⤏⤐⤑⤔⤕⤖⤗⤘⤙⤛⤞⤠⤳⤻⤼⥅⥇⥈⥓⥗⥛⥟⥤⥬⥭⥱⥲⥴⥵⦄⦆⦈⦊⦒⦔⦕⦳⧐⧘⧚⧴⧽⨠⩥⩺⩼⩾⪀⪂⪄⪆⪈⪊⪎⪖⪘⪚⪜⪞⪠⪧⪩⪫⪭⪰⪲⪴⪶⪸⪺⪼⫸⫺⸖＞𐅙👉👉🏻👉🏼👉🏽👉🏾👉🏿🔜🚩🡒🤜🤜🏻🤜🏼🤜🏽🤜🏾🤜🏿🫱🫱🏻🫱🏼🫱🏽🫱🏾🫱🏿"
    case b = "BbƀƁƂƃƄƅɃɓʙΒβϸᴃᴮᴯᵇᵝᵦᶀḂḃḄḅḆḇℬ⒝Ⓑⓑ♭𝄡𝄫𝐁𝐛𝐵𝑏𝑩𝒃𝒷𝓑𝓫𝔅𝔟𝔹𝕓𝕭𝖇𝖡𝗕𝗯𝘉𝘣𝘽𝙗𝙱𝚋𝚩𝛃𝛣𝛽𝜝𝜷𝝗𝝱𝞑𝞫🄑🄱🅑🅱🅱️🇧"
    case a = "@AaÀÁÂÃÄÅâãäåĀāĂăĄąǍǎǞǟǠǡǺǻȀȁȂȃȦȧȺɐɑɒΆΑάαᴀᴬᵃᵄᵅᶏᶐᶛḀḁẚẠạẢảẤấẦầẨẩẪẫẬậẮắẰằẲẳẴẵẶặἀἀἁἂἃἄἅἆἇἈἉἊἋἌἍἎἏὰᾀᾁᾂᾄᾅᾆᾇᾰᾱᾲᾳᾴᾶᾷᾸᾹᾺ⒜Ⓐⓐⱥ＠𝐀𝐚𝐴𝑎𝑨𝒂𝒜𝒶𝓐𝓪𝔄𝔞𝔸𝕒𝕬𝖆𝖠𝖺𝗔𝗮𝘈𝘢𝘼𝙖𝙰𝚊𝚨𝛂𝛢𝛼𝜜𝜶𝝖𝝰𝞐𝞪🄐🄰🅐🅰🅰️🇦"
}
fileprivate let konamiSequence: [KonamiCharacters] = [.up, .up, .down, .down, .left, .right, .left, .right, .b, .a]

/// Checks whether the provided string is a valid variant of the Konami code.
///
/// - Parameter code: The string to check.
///
/// - Returns: `true` if `code` is a valid valid variant of the Konami code;
///   otherwise, `false`.
func isValidKonamiCode(_ code: String) -> Bool {
    guard code.count == konamiSequence.count else { return false }
    
    return code.enumerated().allSatisfy { (index, character) in
        konamiSequence[index].rawValue.contains(character)
    }
}
