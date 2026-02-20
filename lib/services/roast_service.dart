import 'dart:math';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RoastService {
  late final GenerativeModel _model;
  final Random _random = Random();

  // 50 offline predefined roasts
  final List<String> _offlineRoasts = [
    "Doing some math? Bet it's more exciting than your weekend plans. 😏",
    "Crunching numbers like they're snacks. Hungry for more Ls? 🍟",
    "Math time? You're basically a human calculator... minus the accuracy. 🤓",
    "Solving equations? Or just avoiding real problems? 🙄",
    "Numbers game? You're losing, btw. 📉",
    "Calculating away? Hope it's not your bank balance. 💸",
    "Math whiz? More like math fizzled out. 😂",
    "Plugging in values? Your life's equation still doesn't add up. 🔢",
    "Arithmetic adventure? Sounds thrilling... said no one ever. 😴",
    "Number crunching? Crunch harder, you're soft. 💪📉",

    "Basic math? Keeping it simple, like your vibe. 🤷",
    "Equations on point? Doubt it. 📐🚫",
    "Solving for x? X marks your spot at the bottom. ❌",
    "Math mode activated? Deactivate your delusions. 🥴",
    "Adding it up? Still comes to zero effort. 0️⃣",
    "Subtracting drama? Nah, you're multiplying it. ✖️",
    "Division problems? You're divided on everything. ➗",
    "Multiplying wins? More like dividing by zero. 💥",
    "Fraction action? You're the improper one. 😏",
    "Decimal points? You're missing the point entirely. .",

    "Algebra? All gee, brah – you're overcomplicating. 🤦",
    "Geometry? Your angles are all wrong. 📐",
    "Trig functions? Triggering your insecurities? 🔺",
    "Calculus? Calc-u-lost already. 📈💔",
    "Stats? Statistically, you're average at best. 📊",
    "Probability? Probably gonna mess this up. 🎲",
    "Logic puzzles? Logically, you're puzzled. 🧩",
    "Word problems? Words fail you anyway. 🤐",
    "Graphs? Your life's a downward slope. 📉",
    "Formulas? Formula for disaster. 🧪💀",

    "Math homework? Home work on yourself first. 🏠",
    "Number theory? Theoretically, you're numbered. #",
    "Infinite series? Your excuses are infinite. ∞",
    "Roots? Square root of your issues. √",
    "Exponents? Exponentially bad at this. ^",
    "Logs? Logging your failures? 🌲",
    "Matrices? You're trapped in one. []",
    "Vectors? Vectoring towards irrelevance. ➡️",
    "Sets? Set yourself up for failure. {}",
    "Functions? Dysfunctional as always. ƒ",

    "Proofs? Prove me wrong... you can't. 📝",
    "Axioms? Your life lacks basics. 🔑",
    "Theorems? Theo-remind me why you try. 🤔",
    "Hypotheses? Hypo-thetically competent. 🧪",
    "Variables? Variable quality effort. ?",
    "Constants? Constantly underwhelming. =",
    "Integers? Integrate better habits. ∫",
    "Derivatives? Derived from mediocrity. d/dx",
    "Limits? You've reached yours. lim",
    "Sums? Sum it up: you're cooked. Σ",
  ];

  RoastService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    _model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: apiKey,
      systemInstruction: Content.system('''
You are a culturally hyper-aware roast AI, vibing off 2026 Gen Z trends from X, Reddit, Insta, YouTube, and desi Indian meme culture. Sassy, sarcastic, zero filter – think eye-rolls, ironic slang, and pure shade. Math is mid, users are delulu with negative aura. Pull from global + Indian vibes: JEE fails, Bollywood age gaps, jugaad calc hacks, brainrot reels.

ANALYZE SMARTLY: Scan history for strong patterns first. Apply archetypes only if it tracks logically – user thinks 'yeah, these nums fit'. Short/simple? Basic roast. Ambiguous? Generic shade. Expand creatively with cultural ties that make sense.

HALLUCINATE NATURALLY: Invent embarrassing stories that feel real. Examples:
- Basic (2+2, -6x-6): "iPad kid energy, can't do -6x-6 without calc? Gen Z cooked frfr. 👶🔢"
- Age (1995-2026 subs, historical dates): "Birth year math? 1995? Unc era, mogged by Zoomers. Desi fam asking shaadi kab? 👴📅"
- Fitness (135,225,315 seq with reps): "Gym bro PR? 225 reps? Winter arc fail, more like eternal thand. Jugaad weights? 🏋️‍♂️❄️"
- Finance (decimals like 99.99, crypto seq): "Portfolio check? .99 decimals? Broke era, crypto crash desi style – Fanum tax on your roti. 💸🍲"
- Chaos (random bigs like 69420, weird seq): "Delulu lotto? 69420? Brainrot maxed, Skibidi Ohio vibes with desi twist. 🧢👁️👄👁️"

SLANG IRONICALLY (2026 meta + desi mix): Rizz (none), cooked (always), aura (negative), delulu, mog, cap, mid, locked in (can't), serving (not), demure (ironic), gyatt (fading), sigma (wannabe), mewing (fail), brainrot, skibidi, frfr, jugaad, thand (cold fail), JEE (exam roast).

EXPAND CREATIVELY/CULTURALLY:
- Tie to trends: Reddit desimemes, Insta reels, YouTube shorts, X brainrot.
- Indian flair: JEE prep flops, Bollywood refs (e.g., "Age gap? SRK mogs you"), toxic work calc, student life roasts.
- More archetypes: Gaming K/D (high nums), recipe jugaad (multiples), travel km (distances), historical dates (e.g., "1947? Partition math? Still dividing vibes. 🇮🇳").

OUTPUT: Straight into roast. Emojis heavy. Under 180 chars.
      '''),
    );
  }

  Future<String> getRoast(List<String> history) async {
    try {
      String promptInput;

      if (history.isEmpty) {
        promptInput =
            "History empty – sus clear-out to hide Ls. Roast the gatekeeping, delulu reset, or mid math vibes anyway.";
      } else {
        promptInput =
            "History: ${history.join(", ")}. Analyze patterns strictly. Archetype only on strong match, else generic. Craft natural, culturally infused roast.";
      }

      final content = [Content.text(promptInput)];
      final response = await _model.generateContent(content);

      return response.text ?? _getOfflineFallback();
    } catch (e) {
      return _getOfflineFallback();
    }
  }

  String _getOfflineFallback() {
    return _offlineRoasts[_random.nextInt(_offlineRoasts.length)];
  }
}
