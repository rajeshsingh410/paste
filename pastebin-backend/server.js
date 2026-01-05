import express from 'express';
import cors from 'cors';

const app = express();
const PORT = 3000;

app.use(cors({ origin: '*' }));
app.use(express.json());

// Temporary memory store
const pastes = {};

// --------------------------
// POST /api/pastes → Create Paste
// --------------------------
app.post('/api/pastes', (req, res) => {
  const { content, ttl_seconds, max_views } = req.body;

  if (!content) {
    return res.status(400).json({ error: "Content required" });
  }

  const pasteId = Math.random().toString(36).substring(2, 8);

  pastes[pasteId] = {
    content,
    views: 0,
    maxViews: max_views ?? null,

    // ⏰ TTL logic
    expiresAt: ttl_seconds
      ? Date.now() + ttl_seconds * 1000
      : null,
  };

  res.json({
    id: pasteId,
    url: `http://localhost:${PORT}/p/${pasteId}`,
  });
});

// --------------------------
// GET /api/pastes/:id → View Paste
// --------------------------
app.get('/api/pastes/:id', (req, res) => {
  const paste = pastes[req.params.id];

  if (!paste) {
    return res.status(404).json({ error: "Paste not found" });
  }

  // ⏰ TIME EXPIRE CHECK
  if (paste.expiresAt && Date.now() > paste.expiresAt) {
    delete pastes[req.params.id];
    return res.status(410).json({ error: "Paste expired (time)" });
  }

  // 👀 VIEW COUNT CHECK
  paste.views++;

  if (paste.maxViews && paste.views > paste.maxViews) {
    delete pastes[req.params.id];
    return res.status(410).json({ error: "Paste expired (views)" });
  }

  res.json({
    content: paste.content,
  });
});

// --------------------------
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
