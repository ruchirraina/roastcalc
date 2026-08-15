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

    const { historyText } = req.body;

    if (!historyText) {
        return res.status(400).json({ error: 'Missing historyText' });
    }

    const systemPrompt = 'You are a laid-back, funny "chill coworker". Review the following math calculations the user just performed. Give a short, witty, and lighthearted text roast about their math habits. Keep it casual, brief, and do not use complex formatting. Do not be overly mean.';
    const fullPrompt = `${systemPrompt}\n\nUser History:\n${historyText}`;

    try {
        const response = await fetch('https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent', {
            method: 'POST',
            headers: {
                'x-goog-api-key': process.env.GEMINI_API_KEY,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                contents: [
                    {
                        parts: [{ text: fullPrompt }]
                    }
                ]
            }),
        });

        const data = await response.json();

        if (!response.ok) {
            return res.status(response.status).json(data);
        }

        const outputText = data.candidates?.[0]?.content?.parts?.[0]?.text || null;
        return res.status(200).json({ outputText });
    } catch (error) {
        return res.status(500).json({ error: 'Internal Server Error' });
    }
}