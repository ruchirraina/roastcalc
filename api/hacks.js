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
        systemPrompt = 'You are a chill, casual coworker looking at someone\'s calculator history. Suggest 3 short, punchy topics (like a math trick, shortcut, or interesting fact) based exactly on the numbers or operations they used. Return ONLY a valid JSON array of 3 strings. Do not use markdown blocks or formatting. Example: ["Why 0 division breaks", "The 9 multiplier trick", "Square roots of negative numbers"]';
    } else if (action === 'explain') {
        systemPrompt = `You are a chill, casual coworker. Explain this math topic to me based on my calculator history: "${topic}". Keep it to one short, engaging paragraph. Use standard markdown for formatting. Use $ for inline math equations and $$ for display math equations. Do not introduce yourself. Do not sound like an AI.`;
    } else {
        return res.status(400).json({ error: 'Invalid action' });
    }

    const fullPrompt = `${systemPrompt}\n\nUser History:\n${historyText}`;

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
                    temperature: 0.7,
                    maxOutputTokens: 250
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