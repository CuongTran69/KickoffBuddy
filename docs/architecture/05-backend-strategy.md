---
id: arch-backend-strategy
title: Backend Strategy
status: planned
phase: phase-2
depends-on: [arch-tech-stack]
related: [future-magic-add-llm, ops-analytics, ops-monetization]
last-updated: 2026-05-25
---

## Mục đích

Định nghĩa chiến lược backend cho Kickoff Buddy. MVP không có backend. Phase 2 dùng Cloudflare Workers làm proxy cho LLM API.

## Phạm vi

### In scope

- MVP: no backend (fully offline)
- Phase 2: Cloudflare Workers
- Decision matrix: Workers vs Firebase vs Supabase
- Cost projection

### Out of scope

- Database backend (dùng local Isar cho MVP)
- Authentication server
- Real-time data pipeline

---

## MVP: No Backend

Phase 1 hoàn toàn offline:
- Dữ liệu lưu local (Isar + SharedPreferences)
- Notification local (không cần push server)
- Rule cards và vocabulary từ JSON bundle trong assets
- WC 2026 seed từ JSON bundle

**Lợi ích:** Không có chi phí server, không có dependency ngoài, không có privacy risk từ data transmission.

---

## Phase 2: Cloudflare Workers

### Lý do chọn Cloudflare Workers

| Tiêu chí | Cloudflare Workers | Firebase Functions | Supabase Edge Functions |
|---|---|---|---|
| PoP tại Việt Nam | HCM + HN | Không có | Không có |
| Cold start | Không có | Có (~1-2s) | Có |
| Free tier | 100k req/ngày | 2M req/tháng | 500k req/tháng |
| Chi phí paid | ~$5/tháng | ~$10-20/tháng | ~$25/tháng |
| Complexity | Thấp | Trung bình | Trung bình |
| Vendor lock-in | Thấp | Cao (Firebase ecosystem) | Trung bình |

**Kết luận:** Cloudflare Workers tốt nhất cho use case này — latency thấp từ Việt Nam, không cold start, chi phí thấp.

### Free Tier Analysis

- Cloudflare Workers free: 100k requests/ngày
- 10k DAU × 10 Magic Add calls/ngày = 100k requests/ngày
- **Đúng bằng giới hạn free tier** — cần monitor chặt

Nếu vượt free tier: $0.50/1M requests (rất rẻ).

### Workers Use Cases (Phase 2)

1. **LLM Proxy:** Forward request đến Gemini/Claude, không expose API key trong client
2. **Rate Limiting:** Giới hạn 10 Magic Add LLM calls/user/ngày
3. **Analytics Ingestion:** Nhận events từ client (nếu không dùng Firebase Analytics)

### Workers Architecture

```
Flutter App
    │
    ▼ HTTPS
Cloudflare Workers (HCM PoP)
    │
    ├── /api/magic-add → Gemini Flash-Lite API
    │                  → Claude Haiku (fallback)
    │
    └── /api/events   → Analytics storage (KV / D1)
```

### Workers Code Pattern (không implement trong docs — chỉ reference)

```
POST /api/magic-add
Headers: Authorization: Bearer <user-token>
Body: { "text": "...", "userTimezone": "Asia/Ho_Chi_Minh", "today": "2026-06-12" }

Response: { "teamA": "...", "teamB": "...", "date": "...", ... }
```

---

## Phase 3+: Potential Additions

| Service | Dùng cho | Khi nào |
|---|---|---|
| Cloudflare D1 | User data sync | Phase 3 (cloud sync) |
| Cloudflare KV | Rate limit counters, cache | Phase 2 |
| Firebase Auth | Login | Phase 3 (optional) |
| Firebase Firestore | Cloud sync | Phase 3 (nếu không dùng D1) |

---

## Security

- API keys (Gemini, Claude) lưu trong Cloudflare Workers Secrets, không trong client
- Rate limiting tại Workers layer, không chỉ client-side
- Không log `sourceText` của user (privacy)
- HTTPS only

---

## Edge cases

- Cloudflare outage: fallback về form thủ công (không block user)
- Rate limit đạt: thông báo rõ ràng, không crash
- API key hết hạn: Workers trả về 503, client fallback về form

## Open questions

- Cần xác định authentication strategy cho rate limiting (device ID vs user account)

## Next steps

- Setup Cloudflare Workers account trong Phase 2
- Implement LLM proxy endpoint
- Implement rate limiting với Cloudflare KV
