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

เรียกใช้ skill ได้โดยบอกชื่อหรืออธิบายงานให้ตรงกับขอบเขตของ skill เช่น “ใช้ `diagnosing-bugs` ช่วยหาสาเหตุ error นี้” หรือ “ช่วยรีวิว diff นี้ด้วย `code-review`” ถ้า skill ถูกติดตั้งและตรงกับคำขอ Codex ก็สามารถเลือกใช้ให้อัตโนมัติได้

### General development

| Skill | ทำอะไร | ใช้เมื่อ / ตัวอย่างการเรียก |
| --- | --- | --- |
| [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md) | ไล่หาสาเหตุของ error, บั๊ก, build ล้มเหลว, งานค้าง หรือพฤติกรรมที่เปลี่ยนไป โดยอาศัยหลักฐานจากโค้ดและการรันจริง | เมื่อมีอาการผิดปกติ เช่น “ใช้ `diagnosing-bugs` หาสาเหตุที่ endpoint นี้ตอบ 500” |
| [`feature-workflow`](skills/feature-workflow/SKILL.md) | ทำ feature ตั้งแต่เข้าใจ requirement ไปจนถึง implementation, รีวิวแยก และตรวจสอบตามเกณฑ์รับงาน | เมื่ออยากให้ทำ feature แบบครบขั้นตอน เช่น “ใช้ `feature-workflow` เพิ่มระบบค้นหาตามเงื่อนไขนี้” |
| [`code-review`](skills/code-review/SKILL.md) | ตรวจ diff, branch, commit หรือ PR เพื่อหาบั๊ก regression ช่องโหว่ และพฤติกรรมที่ขาด พร้อมรายงานเป็น findings | เมื่อต้องการรีวิวโดยยังไม่ให้แก้โค้ด เช่น “ใช้ `code-review` รีวิว diff ปัจจุบัน” |

### Git workflow

| Skill | ทำอะไร | ใช้เมื่อ / ตัวอย่างการเรียก |
| --- | --- | --- |
| [`push`](skills/push/SKILL.md) | ตรวจและเตรียมเฉพาะไฟล์ที่เกี่ยวข้อง ก่อน commit และ push ตามขั้นตอนยืนยันข้อความ commit | เมื่อสั่งให้เผยแพร่การเปลี่ยนแปลง เช่น “ใช้ `push` commit และ push งานนี้” |
| [`release-changelog`](skills/release-changelog/SKILL.md) | เทียบ Git version tags แล้วสรุปการเปลี่ยนแปลง และสร้างหรืออัปเดต changelog | เมื่อทำ release หรืออยากดูความต่างของเวอร์ชัน เช่น “ใช้ `release-changelog` ทำ release notes จาก tag v1.2.0” |

### Backend development

| Skill | ทำอะไร | ใช้เมื่อ / ตัวอย่างการเรียก |
| --- | --- | --- |
| [`spring-boot-feature`](skills/spring-boot-feature/SKILL.md) | เพิ่มหรือปรับ API, business logic, persistence หรือ integration ใน Java/Spring Boot โดยยึด conventions ของ service | เมื่อมี feature เฉพาะ Spring Boot เช่น “ใช้ `spring-boot-feature` เพิ่ม endpoint สำหรับ…” |
| [`change-impact-analysis`](skills/change-impact-analysis/SKILL.md) | วิเคราะห์ว่าการเปลี่ยน backend อาจกระทบ callers, API contract, business flow, data, config และ tests ตรงไหนบ้าง | เมื่ออยากประเมินผลก่อนหรือหลังแก้โค้ด เช่น “ใช้ `change-impact-analysis` วิเคราะห์ผลกระทบของ diff นี้” |
| [`local-dev-setup`](skills/local-dev-setup/SKILL.md) | ตรวจและจัดทำขั้นตอนรัน backend ในเครื่อง รวม dependency, Docker Compose และ environment variables | เมื่อต้องเตรียม dev environment เช่น “ใช้ `local-dev-setup` ช่วยบอกวิธีรัน service นี้ในเครื่อง” |

## เพิ่ม skill ใหม่

1. เลือกชื่อสั้น ๆ ด้วยตัวพิมพ์เล็ก ตัวเลข และขีดกลาง เช่น `meeting-notes`.
2. สร้าง `skills/<skill-name>/SKILL.md` โดยเริ่มจาก `templates/SKILL.md`.
3. เขียน `description` ให้ชัดว่า skill ทำอะไรและควรเรียกใช้เมื่อใด.
4. ใส่เฉพาะแนวทางที่เปลี่ยนการตัดสินใจหรือช่วยให้ทำงานได้ดีขึ้น; รายละเอียดเฉพาะโหมดแยกไปไว้ใน `references/`.
5. ตรวจ frontmatter, ชื่อโฟลเดอร์, ลิงก์อ้างอิง และไฟล์ประกอบ แล้วเพิ่มรายการในสารบัญนี้

## ติดตั้งจาก GitHub

เมื่อเผยแพร่คลังนี้เป็น GitHub repository แล้ว ผู้ใช้ติดตั้ง skill เดียวเข้า Codex ได้ด้วย [Vercel Skills CLI](https://www.skills.sh/docs/cli):

```bash
npx skills add YOUR_GITHUB_USERNAME/agent-skill --skill diagnosing-bugs --agent codex
```

ดูรายชื่อ skill ที่ติดตั้งได้:

```bash
npx skills add YOUR_GITHUB_USERNAME/agent-skill --list
```

ติดตั้งทุก skill จากคลัง หรือเลือกให้ใช้ได้ทุกโปรเจกต์ของผู้ใช้:

```bash
npx skills add YOUR_GITHUB_USERNAME/agent-skill --all --agent codex
npx skills add YOUR_GITHUB_USERNAME/agent-skill --skill diagnosing-bugs --agent codex --global
```

อัปเดต skill ที่ติดตั้งจากแหล่งเดิม:

```bash
npx skills update
```

แทน `YOUR_GITHUB_USERNAME/agent-skill` ด้วย owner และชื่อ repository จริงก่อนแชร์คำสั่ง เมื่อ repo เป็น public คนอื่นใช้คำสั่งเดียวกันได้โดยไม่ต้อง clone repo เอง; หน้า skills.sh จะแสดง skill ตามแหล่ง GitHub และ install command ของ skill นั้น
