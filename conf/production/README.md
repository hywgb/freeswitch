# FreeSWITCH Production Profile

Goals:
- Minimal attack surface, secure defaults
- Predictable performance (pre-tuned limits, logging, SPS)
- Clear separation of config per role (core, SBC, media)

How to use:
1) Copy this profile to `/etc/freeswitch` or reference its files.
2) Review `vars.xml` and SIP profiles to match your environment.
3) Replace all placeholder secrets.
4) Apply system sysctl/limits recommendations in `../../build`.