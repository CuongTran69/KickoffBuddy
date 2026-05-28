---
id: future-magic-add-llm
title: Magic Add LLM (Phase 2)
status: planned
phase: phase-2
depends-on: [feat-match-scheduler, arch-backend-strategy]
related: [arch-tech-stack]
last-updated: 2026-05-25
---

## Mục đích

Nâng cấp Magic Add từ regex offline (MVP) lên LLM-powered để xử lý input phức tạp hơn: tiếng Việt lẫn tiếng Anh, viết tắt không chuẩn, câu tự nhiên. Yêu cầu backend proxy (Cloudflare Workers).

## Phạm vi

### In scope

- LLM layer gọi khi regex confidence < 0.5
- Default provider: Gemini 2.5 Flash-Lite
- Fallback provider: Claude Haiku
- Backend proxy trên Cloudflare Workers
- Rate limiting phía client (10 lần/ngày free tier)
- Cost projection và monitoring

### Out of scope

- LLM trong MVP (chỉ regex offline)
- Fine-tuning model
- On-device LLM

---

## User stories

- As a fan, I want to paste complex Vietnamese text and have the app understand it so that I don't have to manually enter match details.
- As a fan, I want the app to handle mixed Vietnamese/English input so that I can paste from any source.

---

## Acceptance criteria

- [ ] LLM chỉ được gọi khi regex confidence < 0.5
- [ ] Default provider: Gemini 2.5 Flash-Lite
- [ ] Fallback tự động sang Claude Haiku nếu Gemini không available
- [ ] Timeout: 5 giây — nếu quá thời gian, fallback về form thủ công
- [ ] Rate limit: tối đa 10 lần Magic Add LLM/ngày ở free tier
- [ ] Không gửi thông tin cá nhân, chỉ gửi đoạn text user cung cấp
- [ ] Input > 500 ký tự: cắt bớt trước khi gửi, ưu tiên 200 ký tự đầu
- [ ] Confirm screen vẫn bắt buộc sau khi LLM parse

---

## LLM Provider

| Provider | Model | Chi phí/request | Ghi chú |
|---|---|---|---|
| Gemini (default) | gemini-2.5-flash-lite | ~$0.000060 | Input ~200 token, output ~100 token |
| Claude (fallback) | claude-haiku-4 | ~$0.000080 | Fallback khi Gemini không available |

### Cost Projection

- 10k DAU × 10 calls/ngày = 100k calls/ngày
- Với Gemini Flash-Lite: 100k × $0.000060 = **$6/ngày = ~$180/tháng**
- Với Claude Haiku: 100k × $0.000080 = **$8/ngày = ~$240/tháng**
- Thực tế: không phải tất cả user đều dùng Magic Add LLM mỗi ngày → ước tính thực tế thấp hơn nhiều

---

## Prompt Template

```
Extract football match information from this text.
Return JSON only. If a field cannot be determined, return null.

Text: "{userInput}"

User's local timezone: "{userTimezone}"
Today's date: "{todayDate}"

Return:
{
  "teamA": string | null,
  "teamB": string | null,
  "date": "YYYY-MM-DD" | null,
  "time": "HH:MM" | null,
  "sourceTimezone": "IANA timezone string" | null,
  "confidence": "high" | "medium" | "low",
  "ambiguities": ["list of unclear parts"]
}
```

---

## Backend Proxy

Yêu cầu backend proxy để:
- Không expose API key trong client
- Rate limiting tập trung
- Logging và monitoring

Xem [arch-backend-strategy](../architecture/05-backend-strategy.md) cho chi tiết Cloudflare Workers.

---

## Fallback Chain

```
User input
    │
    ▼
Regex parser (offline)
    │
confidence < 0.5?
    │
    ├── Không → Dùng kết quả regex
    │
    └── Có → Gọi Gemini Flash-Lite
                │
                Gemini available?
                │
                ├── Có → Dùng kết quả LLM
                │
                └── Không → Gọi Claude Haiku
                                │
                                Available?
                                │
                                ├── Có → Dùng kết quả LLM
                                │
                                └── Không → Mở form thủ công
```

---

## Edge cases

- Mất mạng: fallback về form thủ công với các trường regex đã điền được
- LLM trả về JSON không hợp lệ: parse error → fallback về form
- LLM timeout (> 5 giây): fallback về form
- Rate limit đạt: thông báo "Bạn đã dùng hết lượt Magic Add hôm nay. Thử lại vào ngày mai hoặc nhập thủ công."

## Open questions

- Cần xác định free tier limit chính xác (10 lần/ngày là ước tính)
- Cần spike để đo latency thực tế của Gemini Flash-Lite từ Việt Nam

## Next steps

- Implement sau khi Cloudflare Workers backend sẵn sàng (Phase 2)
- Spike: đo latency Gemini Flash-Lite từ HCM
- Implement rate limiting trong Cloudflare Workers
