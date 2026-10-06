# Mandatory AI Agent Workflow Rules

1. **FIRST STEP - ALWAYS READ `WORKLOG.md`**:
   Before doing any task or answering any question, you MUST read `WORKLOG.md` to understand the big picture of the project, recent changes, and current tasks.

2. **PREVENT TOKEN EXHAUSTION / CONTEXT LOSS**:
   Before processing any new user request or complex task, immediately write a concise summary of the requested feature into the "Đang làm / Vừa được yêu cầu" section of `WORKLOG.md`. This ensures continuity across sessions and prevents loss of context if tokens run out.

3. **PRESERVE DESCRIPTIONS & CREDITS**:
   Never overwrite item descriptions or wipe out existing affixes ("Ngũ hành vũ khí", "Tiến cử", "[Khảm]"). Preserve author credits (vnakira, Silva.Fox).

4. **INTEGRITY CHECK**:
   Always verify the build pipeline and pjass compilation (100% pass) after modifying scripts or JASS.
