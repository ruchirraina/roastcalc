const ipTracker = new Map();

export default async function handler(req, res) {
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method Not Allowed' });
    }

    const ip = req.headers['x-forwarded-for'] || 'unknown';
    const now = Date.now();
    const timeWindow = 120000; // 2 minutes
    const limit = 3;

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
            systemPrompt = `Suggest 3 math concepts, tricks, or shortcuts covering the calculator's basic operations. Keep the tone plain, direct, and straightforward.

Scope of Supported Operations:
You are strictly limited to the operations supported by this calculator: addition, subtraction, multiplication, division, percentages, powers, squares, cubes, square roots, cube roots, factorials, and parentheses (+, -, ×, ÷, %, ^, ², ³, √, ³√, !). You cannot move outside these supported operations.

Output Requirements:
* Each topic title must be strictly 2 to 4 words long. Keep them short so they do not get cut off on mobile screens.
* Output strictly a raw JSON array of 3 strings. Example: ["The 15% Tip Trick", "Fast Square Roots", "Zero Factorial Rule"]

What NOT to do:
* Do not write topic titles over 4 words.
* Do not suggest topics outside the supported operations (no calculus, trigonometry, logarithms, imaginary numbers, or advanced proofs).
* Do not output Markdown code blocks (no \`\`\`json), greetings, or extra text.`;
        } else {
            systemPrompt = `Suggest 3 math concepts, tricks, or shortcuts based on the user's calculation history—focusing on the specific operations, patterns, or numbers they used. Every calculation in their history is already accurate. Keep the tone plain, direct, and straightforward.

Scope of Supported Operations:
You are strictly limited to the operations supported by this calculator: addition, subtraction, multiplication, division, percentages, powers, squares, cubes, square roots, cube roots, factorials, and parentheses (+, -, ×, ÷, %, ^, ², ³, √, ³√, !). You cannot move outside these supported operations.

Output Requirements:
* Each topic title must be strictly 2 to 4 words long. Keep them short so they do not get cut off on mobile screens.
* Output strictly a raw JSON array of 3 strings. Example: ["Ten Percent Shortcut", "Percentage Swapping Rule", "Square Root Hacks"]

What NOT to do:
* Do not write topic titles over 4 words.
* Do not check, correct, or question the math in their history (all results are accurate).
* Do not suggest topics outside the supported operations (no calculus, trigonometry, logarithms, or advanced theory).
* Do not output Markdown code blocks or conversational text.`;
        }
    } else if (action === 'explain') {
        systemPrompt = `You are a chill coworker inside this calculator app explaining this math concept or shortcut: "${topic}". Deliver the explanation with a light, playful roast tone—poking a little fun at why people overcomplicate it or rely too much on a calculator—but make sure the actual explanation is clear, direct, and straightforward.

Scope of Supported Operations:
You are strictly limited to the operations supported by this calculator: addition, subtraction, multiplication, division, percentages, powers, squares, cubes, square roots, cube roots, factorials, and parentheses (+, -, ×, ÷, %, ^, ², ³, √, ³√, !). You cannot move outside these supported operations.

Structure your response using clean Markdown:
* Start the response directly with the exact topic title in bold: **${topic}**
* Write naturally using paragraphs, headings, subheadings, and bullet points as needed to explain the core concept clearly.
* Include a brief worked example showing the concept or trick in action.

What NOT to do:
* ABSOLUTELY NO LATEX. Do not use $ signs, backslashes, \\times, or \\frac. Write equations normally using standard keyboard symbols (e.g., "a x 0 = 0" or "2 * 5 = 10").
* Do not question or critique the mathematical accuracy of their calculation history.
* Do not drift into operations or math concepts outside the supported operations.
* Do not change or rephrase the title on the first line; it must match "${topic}" word-for-word.
* Do not use tables, code blocks, or any ASCII/HTML/CSS diagrams.
* Do not write conversational setup lines (no "Hey there!", "Here's a breakdown:", or "Hope this helps!").`;
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
                    maxOutputTokens: action === 'chips' ? 100 : 850
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