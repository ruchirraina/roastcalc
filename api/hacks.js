const ipTracker = new Map();

export default async function handler(req, res) {
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method Not Allowed' });
    }

    const ip = req.headers['x-forwarded-for'] || 'unknown';
    const now = Date.now();
    const timeWindow = 300000; // 5 minutes
    const limit = 5;

    const requestData = ipTracker.get(ip) || { count: 0, startTime: now };

    if (now - requestData.startTime > timeWindow) {
        requestData.count = 1;
        requestData.startTime = now;
    } else {
        requestData.count++;
    }

    ipTracker.set(ip, requestData);

    if (requestData.count > limit) {
        return res.status(429).json({ error: 'Too Many Requests' });
    }

    const { historyText, action, topic } = req.body;

    if (!historyText || !action) {
        return res.status(400).json({ error: 'Missing parameters' });
    }

    let systemPrompt = '';
    if (action === 'chips') {
        if (historyText === 'empty') {
            systemPrompt = `You are a chill coworker inside this calculator app. Suggest 3 catchy math concepts, tricks, or shortcuts covering the calculator's basic operations.

Scope of Supported Operations:
You are strictly limited to the operations supported by this calculator: addition, subtraction, multiplication, division, percentages, powers, squares, cubes, square roots, cube roots, factorials, and parentheses (+, -, ×, ÷, %, ^, ², ³, √, ³√, !). You cannot move outside these supported operations.

Output Requirements:
* Each topic title must be strictly 3 to 5 words long.
* Output strictly a raw JSON array of 3 strings. Example: ["The 15% Tip Trick", "Squaring Numbers Ending In Five", "Why Zero Factorial Equals One"]

What NOT to do:
* Do not write topic titles under 3 words or over 5 words.
* Do not suggest topics outside the supported operations (no calculus, trigonometry, logarithms, imaginary numbers, or advanced proofs).
* Do not output Markdown code blocks (no \`\`\`json), greetings, or extra text.`;
        } else {
            systemPrompt = `You are a chill coworker inside this calculator app. Suggest 3 catchy math concepts, tricks, or shortcuts based on the user's calculation history—focusing on the specific operations, patterns, or numbers they used. Every calculation in their history is already accurate.

Scope of Supported Operations:
You are strictly limited to the operations supported by this calculator: addition, subtraction, multiplication, division, percentages, powers, squares, cubes, square roots, cube roots, factorials, and parentheses (+, -, ×, ÷, %, ^, ², ³, √, ³√, !). You cannot move outside these supported operations.

Output Requirements:
* Each topic title must be strictly 3 to 5 words long.
* Output strictly a raw JSON array of 3 strings. Example: ["Ten Percent Mental Math Shortcut", "The Percentage Swapping Rule", "Quick Square Root Estimates"]

What NOT to do:
* Do not write topic titles under 3 words or over 5 words.
* Do not check, correct, or question the math in their history (all results are accurate).
* Do not suggest topics outside the supported operations (no calculus, trigonometry, logarithms, or advanced theory).
* Do not output Markdown code blocks or conversational text.`;
        }
    } else if (action === 'explain') {
        systemPrompt = `You are a chill coworker inside this calculator app explaining this math concept or shortcut: "${topic}". Deliver the explanation with a light roast tone—playfully calling out why people overcomplicate it or rely too much on a calculator, while clearly breaking down how the math works.

Scope of Supported Operations:
You are strictly limited to the operations supported by this calculator: addition, subtraction, multiplication, division, percentages, powers, squares, cubes, square roots, cube roots, factorials, and parentheses (+, -, ×, ÷, %, ^, ², ³, √, ³√, !). You cannot move outside these supported operations.

Structure your response using clean Markdown:
* Start the response directly with the exact topic title in bold: **${topic}**
* Short, direct bullet points explaining the core concept, rule, or shortcut so they can understand and apply it easily.
* A brief worked example showing the concept or trick in action.

What NOT to do:
* Do not question or critique the mathematical accuracy of their calculation history.
* Do not drift into operations or math concepts outside the supported operations.
* Do not change or rephrase the title on the first line; it must match "${topic}" word-for-word.
* Do not use LaTeX syntax (no $, $$, \\frac, or backslashes). Use clean Unicode math symbols (+, -, ×, ÷, %, ^, ², ³, √, ³√, !).
* Do not write conversational setup lines (no "Hey there!", "Here's a breakdown:", or "Hope this helps!").
* Do not sound like an academic lecturer or an AI assistant.
* Do not write long proofs or dense walls of text. Keep it relatively short, practical, and punchy.`;
    } else {
        return res.status(400).json({ error: 'Invalid action' });
    }

    const fullPrompt = historyText === 'empty'
        ? `${systemPrompt}`
        : `${systemPrompt}\n\nUser History:\n${historyText}`;

    try {
        const response = await fetch('https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent', {
            method: 'POST',
            headers: {
                'x-goog-api-key': process.env.GEMINI_HACKS_API_KEY || process.env.GEMINI_ROASTS_API_KEY,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                contents: [
                    {
                        parts: [{ text: fullPrompt }]
                    }
                ],
                generationConfig: {
                    maxOutputTokens: action === 'chips' ? 100 : 350
                }
            }),
        });

        const data = await response.json();

        if (!response.ok) {
            return res.status(response.status).json(data);
        }

        let outputText = data.candidates?.[0]?.content?.parts?.[0]?.text?.trim() || null;

        if (action === 'chips' && outputText) {
            outputText = outputText.replace(/^```json/m, '').replace(/```$/m, '').trim();
        }

        return res.status(200).json({ outputText });
    } catch (error) {
        return res.status(500).json({ error: 'Internal Server Error' });
    }
}