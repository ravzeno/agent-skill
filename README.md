# Agent Skills

คลังสำหรับสร้างและดูแล Agent Skills ส่วนตัว แต่ละ skill อยู่ในโฟลเดอร์ของตัวเองใต้ `skills/` โดยมี `SKILL.md` เป็นไฟล์หลัก

## โครงสร้าง

```text
skills/
  <skill-name>/
    SKILL.md
    agents/openai.yaml   # optional: metadata สำหรับหน้าจอ Codex
    scripts/             # optional: helpers ที่ใช้ซ้ำ
    references/          # optional: คู่มือเฉพาะงาน
    assets/              # optional: ไฟล์ที่นำไปใช้ในผลลัพธ์

templates/
  SKILL.md               # starter สำหรับ skill ใหม่
```

เพิ่มเฉพาะไฟล์ประกอบที่ช่วยให้ skill ทำงานได้จริง ไม่ต้องสร้างโฟลเดอร์ว่างไว้ล่วงหน้า

## Skills

### Git workflow

- [`push`](skills/push/SKILL.md) — ตรวจ เตรียม commit และ push การเปลี่ยนแปลงเมื่อผู้ใช้สั่ง

### Backend development

- [`spring-boot-feature`](skills/spring-boot-feature/SKILL.md) — เพิ่มหรือขยายฟีเจอร์ Java/Spring Boot ตาม conventions ของ service
- [`backend-debugging`](skills/backend-debugging/SKILL.md) — หาสาเหตุและแก้ปัญหา runtime, dependency injection, build, generated code, query หรือ test
- [`backend-code-review`](skills/backend-code-review/SKILL.md) — รีวิวโค้ด backend เพื่อหาบั๊ก regression, ความเสี่ยง และพฤติกรรมที่ขาด
- [`change-impact-analysis`](skills/change-impact-analysis/SKILL.md) — ไล่ผลกระทบต่อ callers, contract, business flow, data, config และ tests
- [`local-dev-setup`](skills/local-dev-setup/SKILL.md) — จัดเตรียมวิธีรัน service ในเครื่อง รวม Compose และ environment config

## เพิ่ม skill ใหม่

1. เลือกชื่อสั้น ๆ ด้วยตัวพิมพ์เล็ก ตัวเลข และขีดกลาง เช่น `meeting-notes`.
2. สร้าง `skills/<skill-name>/SKILL.md` โดยเริ่มจาก `templates/SKILL.md`.
3. เขียน `description` ให้ชัดว่า skill ทำอะไรและควรเรียกใช้เมื่อใด.
4. ใส่เฉพาะแนวทางที่เปลี่ยนการตัดสินใจหรือช่วยให้ทำงานได้ดีขึ้น; รายละเอียดเฉพาะโหมดแยกไปไว้ใน `references/`.
5. ตรวจ frontmatter, ชื่อโฟลเดอร์, ลิงก์อ้างอิง และไฟล์ประกอบ แล้วเพิ่มรายการในสารบัญนี้

## ติดตั้งจาก GitHub

เมื่อเผยแพร่คลังนี้เป็น GitHub repository แล้ว ผู้ใช้ติดตั้ง skill เดียวเข้า Codex ได้ด้วย [Vercel Skills CLI](https://www.skills.sh/docs/cli):

```bash
npx skills add YOUR_GITHUB_USERNAME/agent-skill --skill backend-debugging --agent codex
```

ดูรายชื่อ skill ที่ติดตั้งได้:

```bash
npx skills add YOUR_GITHUB_USERNAME/agent-skill --list
```

ติดตั้งทุก skill จากคลัง หรือเลือกให้ใช้ได้ทุกโปรเจกต์ของผู้ใช้:

```bash
npx skills add YOUR_GITHUB_USERNAME/agent-skill --all --agent codex
npx skills add YOUR_GITHUB_USERNAME/agent-skill --skill backend-debugging --agent codex --global
```

อัปเดต skill ที่ติดตั้งจากแหล่งเดิม:

```bash
npx skills update
```

แทน `YOUR_GITHUB_USERNAME/agent-skill` ด้วย owner และชื่อ repository จริงก่อนแชร์คำสั่ง เมื่อ repo เป็น public คนอื่นใช้คำสั่งเดียวกันได้โดยไม่ต้อง clone repo เอง; หน้า skills.sh จะแสดง skill ตามแหล่ง GitHub และ install command ของ skill นั้น
