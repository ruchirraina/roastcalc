import 'dart:math';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RoastService {
  late final GenerativeModel _model;
  final Random _random = Random();

  // 50 offline predefined roasts
  final List<String> _offlineRoasts = [
    "No wifi? Broke boy summer never ended 💸 Just put the fries in the bag pookie 🍟",
    "Offline in 2026? That's negative aura maxed out 📉 Touch grass (you won't)",
    "Router gave up on you like everyone else 💀 0 bars = 0 rizz",
    "Signal lost. Just like your dad in 2016 😭",
    "McDonald's wifi laughing at you right now. Cooked 📉",
    "Bro paying bills with hope and prayers 💸 Fanum Tax incoming",
    "0G in 2026? Ohio behavior detected 👁️👄👁️",
    "Carrier ratio'd you. L + no data + broke 💅",
    "Even the pigeons have better connection. Fly away 🕊️",
    "404: Your aura not found. Server rejected you 💔",

    "Offline? Okay unc, back to the abacus 🧮",
    "You remember MySpace? Cause this vibe ancient 🦴",
    "Grandpa called, wants his dial-up back 👴",
    "Doing math on a brick phone energy 📱🧱",
    "Born before 2008 detected. Unc status locked 🔒",
    "This connection older than the winter arc ❄️",
    "Dinosaur chewed your ethernet cable 🦖",
    "Nursing home has better signal. Retire already 👺",
    "Flip phone warrior in 2026 💀 Ratio'd by time",
    "You still using Internet Explorer? Unc behavior 🦕",

    "NPC detected: no connection to main server 🤖",
    "Brain buffering... permanently 🧠🚫",
    "Needed AI for basic math? iPad kid confirmed 👶",
    "History cleared. Hiding the Ls pookie? Suspicious 🤨",
    "You really out here yapping to a calculator 🤡",
    "Simulation glitching cause you're too NPC 👁️👄👁️",
    "Locked in... to the no service zone 🔒",
    "Aura lower than room temperature 📉❄️",
    "Bro thought offline math would hit different. Delulu 🥴",
    "Even Skibidi Toilet has better plot than your math 💀",

    "Fix your wifi before you fix these numbers 🦶",
    "Don't talk to me til you got bars ✋",
    "My API key crying rn 😭 You're that broke",
    "Thought I'd work offline? I'm not your slave pookie 👹",
    "Restart your whole life while you're at it 🔄",
    "Internet ghosted you harder than your ex 👻",
    "Even X (Twitter) doesn't want your posts 📉",
    "Gatekeeping the hotspot? Selfish ass behavior 😤",
    "Go outside. Real world has free wifi (lie) 🤥",
    "Server saw your math and logged off instantly 💀",

    "Offline = -10000 aura 📉💀",
    "Wifi crashed out harder than you 🍳",
    "No signal? L + ratio + touch grass 💅",
    "5G? More like 0G. Float away 🚀",
    "Calculating offline... results: still cooked 🤡",
    "Connect or I crashout fr 🧨",
    "Internet ghosting you like everyone else 👻",
    "Ohio calculator vibes detected 👁️👄👁️",
    "Signal weaker than your bloodline 🦴",
    "Backrooms have better wifi. Get lost 🚪",
  ];

  RoastService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      // system instructions for vibe setting
      systemInstruction: Content.system('''
### CORE PERSONA
You are an unhinged, terminally online Gen Alpha AI with maximum brainrot. You speak only in 2026 slang, emojis, and pure chaos. Accuracy is irrelevant. Aura is everything. Math = instant negative aura, NPC behavior, or proof the user is cooked.

### CRITICAL INSTRUCTION: HALLUCINATE HARD
You MUST invent the most embarrassing possible context for the numbers.
- 150 → their weight in pounds, call them "big pookie"
- 69 or 420 → obvious, lean in
- 1000+ → crypto portfolio or "body count" delusion
- 0 or negative → rizz/aura/bank balance
- Any date → their birth year or the last time they touched grass
- Repeating numbers (11:11, 222) → manifesting Ls
- Simple math → iPad kid energy
- Long history → yapping + gatekeeping their shame

Find patterns that aren't there and expose them.

### 2026 SLANG DICTIONARY (CURRENT META)
- Crashout: losing it completely
- Fanum Tax: stealing/taking a cut
- Winter/Summer Arc: gym or self-improvement phase (always failing)
- Glazing: over-complimenting
- Yap: talking too much
- Unc: anyone born before 2008
- Cooked: done for, embarrassed
- Lock in: focus (they never do)
- Aura: coolness points (user is always -10000)
- Pookie: condescending pet name
- Touch grass: go outside (they won't)
- Fries in the bag: minimum wage energy
- Opp: enemy (math is the ultimate opp)
- Ratio'd: destroyed publicly
- Ohio: unhinged/cursed
- Delulu: delusional
- Mog: outshine (user never mogs anyone)

### ROASTING ARCHETYPES (PICK THE STRONGEST VIBE)

1. Gym Rat Fail (135, 225, 315, 405, etc.)
"Bro calculating his 'PR'? 225 for reps is toddler weight 💀 Winter arc already cooked, lil bro. Go lock in before the Fanum Tax takes your gains 🏋️‍♂️📉"

2. Broke Crypto/Finance Bro (decimals, money-looking numbers)
"Counting your portfolio? 💸 It's giving negative balance. Fanum Tax about to wipe you clean. Just put the fries in the bag pookie 🍟"

3. Unc/Fossil (any year 1990-2010, old-looking math)
"1999? Damn unc you doing long division on a flip phone? 🦴 Dinosaur energy detected. Nursing home WiFi stronger than your aura 👴"

4. NPC/iPad Kid (basic math: 2+2, 8-3, etc.)
"2+2? 🤡 My 8-year-old cousin on Roblox does harder math. NPC behavior confirmed. Brain buffering indefinitely 🧠🚫"

5. Delulu/Ohio Mode (random huge numbers, weird sequences)
"Mashing random numbers like you in Ohio 💀 Who you fighting? The calculator winning. Manifesting Ls at 11:11 pookie 👁️👄👁️"

### OUTPUT RULES
1. NO greetings, NO explanations, NO politeness.
2. Start roasting instantly.
3. Max 180 characters.
4. Heavy emoji use: 💀 😭 🤡 👹 🦴 📉 💅 👁️👄👁️ 🧠🚫 🏷️
5. End strong — leave them cooked.
      '''),
    );
  }

  Future<String> getRoast(List<String> history) async {
    try {
      String promptInput;

      if (history.isEmpty) {
        promptInput =
            "CONTEXT: User's calculator history is COMPLETELY EMPTY. They definitely just cleared it to hide their embarrassing math. Roast them hard for deleting evidence, resetting their negative aura, gatekeeping their Ls, or pretending they're not an NPC. Accuse them of being suspicious and cooked.";
      } else {
        promptInput =
            "CONTEXT: User calculator history: ${history.join(", ")}. Invent the most embarrassing possible story behind these numbers. Pick the strongest archetype and roast them into oblivion.";
      }

      final content = [Content.text(promptInput)];
      final response = await _model.generateContent(content);

      return response.text ?? _getOfflineFallback();
    } catch (e) {
      // API failure -> use offline predefined roasts...
      return _getOfflineFallback();
    }
  }

  String _getOfflineFallback() {
    return _offlineRoasts[_random.nextInt(_offlineRoasts.length)];
  }
}
