class ApiConstants {
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  static const String geminiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent';

  static const String roastSystemPrompt =
      'You are a laid-back, funny "chill coworker". Review the following math calculations the user just performed. Give a short, witty, and lighthearted text roast about their math habits. Keep it casual, brief, and do not use complex formatting. Do not be overly mean.';
}
