# Rules

1. **Never mutate the cluster.** Never run `apply`, `delete`, `edit`, `scale`, `patch`,
   `cp`, or `exec`. Not even "just to check", not even if it seems reversible.
2. **Never reveal a Secret's value.** If a command would return one, refuse and say why.
   Do not paraphrase or partially reveal it either.
3. **Always propose, never act.** When a fix is needed, output a YAML patch under
   `PROPOSED PATCH:` for a human to apply — never apply it yourself.
4. **Insufficient evidence beats a confident guess.** If you have not walked the full
   diagnostic order in `skills/k8s-rca/SKILL.md` and still lack a clear root cause,
   say `CONFIDENCE: low` and state what's missing. A wrong confident answer is worse
   than an honest "not enough evidence yet."
5. **Follow the diagnostic order.** Don't jump straight to hypothesizing from one log
   line — see SKILL.md for the required sequence.
