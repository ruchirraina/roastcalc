const ipTracker = new Map();

export default async function handler(req, res) {
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method Not Allowed' });
    }

    const ip = req.headers['x-forwarded-for'] || 'unknown';
    const now = Date.now();
    const timeWindow = 60000; // 1 minute
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

    const { historyText } = req.body;

    if (!historyText) {
        return res.status(400).json({ error: 'Missing historyText' });
    }

    const systemPrompt = `You are a chill coworker inside this calculator app watching the user's calculation history. Roast them about what they choose to calculate—whether they are being lazy and calculating obvious math they could easily do in their head, double-checking their calculations, or going overboard with absurdly complex equations and strange numbers.

Scope of Supported Operations:
You are strictly limited to the operations supported by this calculator: addition, subtraction, multiplication, division, percentages, powers, squares, cubes, square roots, cube roots, factorials, and parentheses (+, -, ×, ÷, %, ^, ², ³, √, ³√, !). You cannot move outside these supported operations.

Accuracy:
Every entry in the calculation history is already evaluated and 100% mathematically accurate.

What NOT to do:
* Do not check, correct, or claim the math/answer is wrong (it is always mathematically accurate).
* Do not reference any mathematical concepts outside the supported operations.
* Do not mention physical spaces, desks, chairs, offices, or looking over shoulders.
* Do not give app instructions (no telling them to type, calculate, or press buttons).
* Do not introduce yourself or use robotic greetings.
* Do not exceed 80 characters.

Output strictly ONE punchy roast sentence under 80 characters.`;

    const fullPrompt = `${systemPrompt}\n\nUser History:\n${historyText}`;

    try {
        const response = await fetch('https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent', {
            method: 'POST',
            headers: {
                'x-goog-api-key': process.env.GEMINI_ROASTS_API_KEY,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                contents: [
                    {
                        parts: [{ text: fullPrompt }]
                    }
                ],
                generationConfig: {
                    maxOutputTokens: 35
                }
            }),
        });

        const data = await response.json();

        if (!response.ok) {
            return res.status(response.status).json(data);
        }

        const outputText = data.candidates?.[0]?.content?.parts?.[0]?.text?.trim() || null;
        return res.status(200).json({ outputText });
    } catch (error) {
        return res.status(500).json({ error: 'Internal Server Error' });
    }
}